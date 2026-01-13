#pragma once

#include <atomic>
#include <cstdint>
#include <mutex>
#include <string>

struct llama_model;
struct llama_context;
struct llama_vocab;

class TranzfortLlmBackend {
 public:
  static TranzfortLlmBackend& Instance();

  bool LoadModel(const std::string& model_path, int context_size, int threads, bool use_gpu);
  void UnloadModel();
  bool IsModelLoaded() const;

  std::string GenerateText(
      const std::string& prompt,
      int max_tokens,
      double temperature,
      double top_p,
      int top_k,
      const std::string& stop_sequence);

  void CancelGeneration();

 private:
  TranzfortLlmBackend() = default;

  mutable std::mutex mutex_;
  std::atomic<bool> cancel_requested_{false};

  llama_model* model_ = nullptr;
  llama_context* ctx_ = nullptr;
  const llama_vocab* vocab_ = nullptr;

  int context_size_ = 0;
  int threads_ = 0;

  bool model_loaded_ = false;
  std::string loaded_model_path_;
};
