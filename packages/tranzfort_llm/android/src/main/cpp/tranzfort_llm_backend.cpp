#include "tranzfort_llm_backend.h"

#include <android/log.h>

#include <algorithm>
#include <fstream>
#include <string>
#include <vector>

#include <llama.h>

#define LOG_TAG "tranzfort_llm_backend"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

namespace {
bool AbortCallback(void* user_data) {
  auto* flag = reinterpret_cast<std::atomic<bool>*>(user_data);
  return flag != nullptr && flag->load();
}

bool EndsWith(const std::string& s, const std::string& suffix) {
  if (suffix.empty()) return false;
  if (s.size() < suffix.size()) return false;
  return std::equal(suffix.rbegin(), suffix.rend(), s.rbegin());
}
}  // namespace

TranzfortLlmBackend& TranzfortLlmBackend::Instance() {
  static TranzfortLlmBackend instance;
  return instance;
}

bool TranzfortLlmBackend::LoadModel(const std::string& model_path, int context_size, int threads, bool /*use_gpu*/) {
  std::lock_guard<std::mutex> lock(mutex_);

  // Ensure previous state is cleaned up.
  if (ctx_ != nullptr) {
    llama_free(ctx_);
    ctx_ = nullptr;
  }
  if (model_ != nullptr) {
    llama_model_free(model_);
    model_ = nullptr;
  }
  vocab_ = nullptr;

  model_loaded_ = false;
  loaded_model_path_.clear();
  cancel_requested_.store(false);

  {
    std::ifstream f(model_path, std::ios::binary);
    if (!f.good()) {
      LOGE("Model file not found: %s", model_path.c_str());
      return false;
    }
  }

  llama_backend_init();

  auto mparams = llama_model_default_params();
  mparams.use_mmap = true;
  mparams.use_mlock = false;
  mparams.n_gpu_layers = 0;

  const int64_t t0 = llama_time_us();
  model_ = llama_model_load_from_file(model_path.c_str(), mparams);
  if (model_ == nullptr) {
    LOGE("Failed to load model from: %s", model_path.c_str());
    return false;
  }

  auto cparams = llama_context_default_params();
  cparams.n_ctx = context_size > 0 ? static_cast<uint32_t>(context_size) : 2048;
  cparams.n_batch = std::min<uint32_t>(cparams.n_ctx, 128u);
  cparams.n_ubatch = std::min<uint32_t>(cparams.n_ctx, 128u);
  cparams.n_seq_max = 1;
  cparams.n_threads = threads > 0 ? threads : 4;
  cparams.n_threads_batch = cparams.n_threads;
  cparams.flash_attn_type = LLAMA_FLASH_ATTN_TYPE_DISABLED;
  cparams.abort_callback = AbortCallback;
  cparams.abort_callback_data = &cancel_requested_;

  ctx_ = llama_init_from_model(model_, cparams);
  if (ctx_ == nullptr) {
    LOGE("Failed to create llama context");
    llama_model_free(model_);
    model_ = nullptr;
    return false;
  }

  vocab_ = llama_model_get_vocab(model_);
  context_size_ = static_cast<int>(cparams.n_ctx);
  threads_ = static_cast<int>(cparams.n_threads);

  loaded_model_path_ = model_path;
  model_loaded_ = true;

  const int64_t t1 = llama_time_us();
  LOGI("Model loaded. n_ctx=%d threads=%d load_ms=%.1f", context_size_, threads_, (t1 - t0) / 1000.0);
  return true;
}

void TranzfortLlmBackend::UnloadModel() {
  std::lock_guard<std::mutex> lock(mutex_);

  if (ctx_ != nullptr) {
    llama_free(ctx_);
    ctx_ = nullptr;
  }
  if (model_ != nullptr) {
    llama_model_free(model_);
    model_ = nullptr;
  }

  vocab_ = nullptr;
  model_loaded_ = false;
  loaded_model_path_.clear();
  cancel_requested_.store(false);
}

bool TranzfortLlmBackend::IsModelLoaded() const {
  std::lock_guard<std::mutex> lock(mutex_);
  return model_loaded_ && model_ != nullptr && ctx_ != nullptr;
}

std::string TranzfortLlmBackend::GenerateText(
    const std::string& prompt,
    int max_tokens,
    double temperature,
    double top_p,
    int top_k,
    const std::string& stop_sequence) {
  // Intentionally keep the lock for the whole generation (single-context Phase-1 design).
  std::lock_guard<std::mutex> lock(mutex_);

  if (!model_loaded_ || model_ == nullptr || ctx_ == nullptr || vocab_ == nullptr) {
    return "ERROR: model not loaded";
  }

  cancel_requested_.store(false);

  // Reset KV/memory for a fresh request.
  llama_memory_clear(llama_get_memory(ctx_), true);
  llama_set_n_threads(ctx_, threads_, threads_);

  const bool add_special = true;
  const bool parse_special = false;

  const int32_t required = llama_tokenize(
      vocab_,
      prompt.c_str(),
      static_cast<int32_t>(prompt.size()),
      nullptr,
      0,
      add_special,
      parse_special);
  if (required >= 0) {
    return "ERROR: tokenization failed";
  }

  std::vector<llama_token> tokens(static_cast<size_t>(-required));
  const int32_t n_prompt = llama_tokenize(
      vocab_,
      prompt.c_str(),
      static_cast<int32_t>(prompt.size()),
      tokens.data(),
      static_cast<int32_t>(tokens.size()),
      add_special,
      parse_special);
  if (n_prompt <= 0) {
    return "ERROR: tokenization failed";
  }
  tokens.resize(static_cast<size_t>(n_prompt));

  const uint32_t n_ctx = llama_n_ctx(ctx_);
  if (n_ctx > 0 && tokens.size() > n_ctx) {
    tokens.erase(tokens.begin(), tokens.end() - static_cast<std::ptrdiff_t>(n_ctx));
  }

  // Decode the prompt.
  {
    const uint32_t n_batch = std::max<uint32_t>(1u, llama_n_batch(ctx_));
    size_t i = 0;
    while (i < tokens.size()) {
      const size_t chunk = std::min(tokens.size() - i, static_cast<size_t>(n_batch));
      auto batch = llama_batch_get_one(tokens.data() + i, static_cast<int32_t>(chunk));
      const int32_t rc = llama_decode(ctx_, batch);
      if (rc == 2 || cancel_requested_.load()) {
        cancel_requested_.store(false);
        return "";
      }
      if (rc != 0) {
        return "ERROR: decode failed";
      }
      i += chunk;
    }
  }

  // Build a sampling chain.
  auto sparams = llama_sampler_chain_default_params();
  llama_sampler* sampler = llama_sampler_chain_init(sparams);
  if (sampler == nullptr) {
    return "ERROR: sampler init failed";
  }

  const int32_t k = top_k > 0 ? top_k : 40;
  const float p = top_p > 0 ? static_cast<float>(top_p) : 0.9f;
  const float t = temperature > 0 ? static_cast<float>(temperature) : 0.7f;

  llama_sampler_chain_add(sampler, llama_sampler_init_top_k(k));
  llama_sampler_chain_add(sampler, llama_sampler_init_top_p(p, 1));
  llama_sampler_chain_add(sampler, llama_sampler_init_temp(t));
  llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

  std::string out;
  const int max_out = max_tokens > 0 ? max_tokens : 256;

  for (int i = 0; i < max_out; i++) {
    if (cancel_requested_.load()) {
      cancel_requested_.store(false);
      break;
    }

    const llama_token tok = llama_sampler_sample(sampler, ctx_, -1);
    llama_sampler_accept(sampler, tok);

    if (tok == LLAMA_TOKEN_NULL) {
      break;
    }

    if (llama_vocab_is_eog(vocab_, tok)) {
      break;
    }

    // Convert token to string.
    char buf[1024];
    const int32_t n = llama_token_to_piece(vocab_, tok, buf, static_cast<int32_t>(sizeof(buf)), 0, true);
    if (n > 0) {
      out.append(buf, buf + n);
    }

    if (!stop_sequence.empty() && EndsWith(out, stop_sequence)) {
      out.resize(out.size() - stop_sequence.size());
      break;
    }

    // Feed the sampled token back into the model.
    llama_token one = tok;
    auto batch = llama_batch_get_one(&one, 1);
    const int32_t rc = llama_decode(ctx_, batch);
    if (rc == 2 || cancel_requested_.load()) {
      cancel_requested_.store(false);
      break;
    }
    if (rc != 0) {
      break;
    }
  }

  llama_sampler_free(sampler);
  return out;
}

std::string TranzfortLlmBackend::GenerateTextWithCallback(
    const std::string& prompt,
    int max_tokens,
    double temperature,
    double top_p,
    int top_k,
    const std::string& stop_sequence,
    std::function<void(const std::string&)> token_callback) {
  std::lock_guard<std::mutex> lock(mutex_);

  if (!model_loaded_ || model_ == nullptr || ctx_ == nullptr || vocab_ == nullptr) {
    return "ERROR: model not loaded";
  }

  cancel_requested_.store(false);

  llama_memory_clear(llama_get_memory(ctx_), true);
  llama_set_n_threads(ctx_, threads_, threads_);

  const bool add_special = true;
  const bool parse_special = false;

  const int32_t required = llama_tokenize(
      vocab_,
      prompt.c_str(),
      static_cast<int32_t>(prompt.size()),
      nullptr,
      0,
      add_special,
      parse_special);
  if (required >= 0) {
    return "ERROR: tokenization failed";
  }

  std::vector<llama_token> tokens(static_cast<size_t>(-required));
  const int32_t n_prompt = llama_tokenize(
      vocab_,
      prompt.c_str(),
      static_cast<int32_t>(prompt.size()),
      tokens.data(),
      static_cast<int32_t>(tokens.size()),
      add_special,
      parse_special);
  if (n_prompt <= 0) {
    return "ERROR: tokenization failed";
  }
  tokens.resize(static_cast<size_t>(n_prompt));

  const uint32_t n_ctx = llama_n_ctx(ctx_);
  if (n_ctx > 0 && tokens.size() > n_ctx) {
    tokens.erase(tokens.begin(), tokens.end() - static_cast<std::ptrdiff_t>(n_ctx));
  }

  // Decode the prompt
  {
    const uint32_t n_batch = std::max<uint32_t>(1u, llama_n_batch(ctx_));
    size_t i = 0;
    while (i < tokens.size()) {
      const size_t chunk = std::min(tokens.size() - i, static_cast<size_t>(n_batch));
      auto batch = llama_batch_get_one(tokens.data() + i, static_cast<int32_t>(chunk));
      const int32_t rc = llama_decode(ctx_, batch);
      if (rc == 2 || cancel_requested_.load()) {
        cancel_requested_.store(false);
        return "";
      }
      if (rc != 0) {
        return "ERROR: decode failed";
      }
      i += chunk;
    }
  }

  auto sparams = llama_sampler_chain_default_params();
  llama_sampler* sampler = llama_sampler_chain_init(sparams);
  if (sampler == nullptr) {
    return "ERROR: sampler init failed";
  }

  const int32_t k = top_k > 0 ? top_k : 40;
  const float p = top_p > 0 ? static_cast<float>(top_p) : 0.9f;
  const float t = temperature > 0 ? static_cast<float>(temperature) : 0.7f;

  llama_sampler_chain_add(sampler, llama_sampler_init_top_k(k));
  llama_sampler_chain_add(sampler, llama_sampler_init_top_p(p, 1));
  llama_sampler_chain_add(sampler, llama_sampler_init_temp(t));
  llama_sampler_chain_add(sampler, llama_sampler_init_dist(LLAMA_DEFAULT_SEED));

  std::string out;
  const int max_out = max_tokens > 0 ? max_tokens : 256;

  for (int i = 0; i < max_out; i++) {
    if (cancel_requested_.load()) {
      cancel_requested_.store(false);
      break;
    }

    const llama_token tok = llama_sampler_sample(sampler, ctx_, -1);
    llama_sampler_accept(sampler, tok);

    if (tok == LLAMA_TOKEN_NULL) {
      break;
    }

    if (llama_vocab_is_eog(vocab_, tok)) {
      break;
    }

    // Convert token to string
    char buf[1024];
    const int32_t n = llama_token_to_piece(vocab_, tok, buf, static_cast<int32_t>(sizeof(buf)), 0, true);
    if (n > 0) {
      std::string token_str(buf, buf + n);
      out.append(token_str);
      
      // Call the callback with the new token
      if (token_callback) {
        token_callback(token_str);
      }
    }

    if (!stop_sequence.empty() && EndsWith(out, stop_sequence)) {
      out.resize(out.size() - stop_sequence.size());
      break;
    }

    // Feed the sampled token back
    llama_token one = tok;
    auto batch = llama_batch_get_one(&one, 1);
    const int32_t rc = llama_decode(ctx_, batch);
    if (rc == 2 || cancel_requested_.load()) {
      cancel_requested_.store(false);
      break;
    }
    if (rc != 0) {
      break;
    }
  }

  llama_sampler_free(sampler);
  return out;
}

void TranzfortLlmBackend::CancelGeneration() {
  cancel_requested_.store(true);
}
