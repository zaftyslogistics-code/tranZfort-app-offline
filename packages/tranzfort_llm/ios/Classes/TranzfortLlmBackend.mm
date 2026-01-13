#include "TranzfortLlmBackend.h"

#import <Foundation/Foundation.h>

#include <algorithm>
#include <fstream>
#include <string>
#include <vector>

#include "llama.h"

#define LOG_TAG "tranzfort_llm_backend"
#define LOGI(...) NSLog(@__VA_ARGS__)
#define LOGE(...) NSLog(@"ERROR: " __VA_ARGS__)

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

bool TranzfortLlmBackend::LoadModel(const std::string& model_path, int context_size, int threads, bool use_gpu) {
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
      LOGE(@"Model file not found: %s", model_path.c_str());
      return false;
    }
  }

  llama_backend_init();

  auto mparams = llama_model_default_params();
  mparams.use_mmap = true;
  mparams.use_mlock = false;
  
  // iOS Metal GPU support (if enabled)
  if (use_gpu) {
    mparams.n_gpu_layers = 99; // Offload all layers to Metal
  } else {
    mparams.n_gpu_layers = 0;
  }

  const int64_t t0 = llama_time_us();
  model_ = llama_model_load_from_file(model_path.c_str(), mparams);
  if (model_ == nullptr) {
    LOGE(@"Failed to load model from: %s", model_path.c_str());
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
    LOGE(@"Failed to create llama context");
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
  LOGI(@"Model loaded in %.2f ms", (t1 - t0) / 1000.0);

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

  llama_backend_free();
  LOGI(@"Model unloaded");
}

bool TranzfortLlmBackend::IsModelLoaded() const {
  std::lock_guard<std::mutex> lock(mutex_);
  return model_loaded_;
}

std::string TranzfortLlmBackend::GenerateText(
    const std::string& prompt,
    int max_tokens,
    double temperature,
    double top_p,
    int top_k,
    const std::string& stop_sequence) {
  std::lock_guard<std::mutex> lock(mutex_);

  if (!model_loaded_ || model_ == nullptr || ctx_ == nullptr) {
    LOGE(@"Model not loaded");
    return "";
  }

  cancel_requested_.store(false);

  std::vector<llama_token> tokens_list;
  tokens_list.resize(prompt.size() + 16);
  const int n_prompt_tokens = llama_tokenize(
      vocab_, prompt.c_str(), prompt.size(), tokens_list.data(),
      static_cast<int>(tokens_list.size()), true, false);

  if (n_prompt_tokens < 0) {
    tokens_list.resize(-n_prompt_tokens);
    const int check = llama_tokenize(
        vocab_, prompt.c_str(), prompt.size(), tokens_list.data(),
        static_cast<int>(tokens_list.size()), true, false);
    if (check < 0) {
      LOGE(@"Tokenization failed");
      return "";
    }
  }
  tokens_list.resize(n_prompt_tokens);

  if (static_cast<int>(tokens_list.size()) > context_size_) {
    tokens_list.resize(context_size_);
  }

  llama_kv_cache_clear(ctx_);

  const int chunk_size = 128;
  for (size_t i = 0; i < tokens_list.size(); i += chunk_size) {
    const size_t batch_size = std::min<size_t>(chunk_size, tokens_list.size() - i);
    auto batch = llama_batch_get_one(&tokens_list[i], static_cast<int>(batch_size));
    if (llama_decode(ctx_, batch) != 0) {
      LOGE(@"Failed to decode prompt");
      return "";
    }
  }

  auto* sampler = llama_sampler_chain_init(llama_sampler_chain_default_params());
  llama_sampler_chain_add(sampler, llama_sampler_init_temp(temperature));
  llama_sampler_chain_add(sampler, llama_sampler_init_top_k(top_k));
  llama_sampler_chain_add(sampler, llama_sampler_init_top_p(top_p, 1));
  llama_sampler_chain_add(sampler, llama_sampler_init_dist(0));

  std::string result;
  const int max_gen = max_tokens > 0 ? max_tokens : 512;

  for (int i = 0; i < max_gen; ++i) {
    if (cancel_requested_.load()) {
      LOGI(@"Generation cancelled by user");
      break;
    }

    const llama_token new_token = llama_sampler_sample(sampler, ctx_, -1);

    if (llama_vocab_is_eog(vocab_, new_token)) {
      break;
    }

    char buf[256];
    const int n = llama_token_to_piece(vocab_, new_token, buf, sizeof(buf), 0, false);
    if (n < 0) {
      LOGE(@"Failed to convert token to text");
      break;
    }
    result.append(buf, n);

    if (!stop_sequence.empty() && EndsWith(result, stop_sequence)) {
      result.resize(result.size() - stop_sequence.size());
      break;
    }

    auto batch = llama_batch_get_one(&new_token, 1);
    if (llama_decode(ctx_, batch) != 0) {
      LOGE(@"Failed to decode generated token");
      break;
    }
  }

  llama_sampler_free(sampler);
  return result;
}

void TranzfortLlmBackend::CancelGeneration() {
  cancel_requested_.store(true);
  LOGI(@"Cancel requested");
}
