import 'dart:async';
import 'tranzfort_llm_platform_interface.dart';

export 'src/llm_model_config.dart';
export 'src/llm_generation_config.dart';
export 'src/llm_message.dart';

/// Main API for on-device LLM inference using llama.cpp
class TranzfortLlm {
  static final TranzfortLlm _instance = TranzfortLlm._();
  static TranzfortLlm get instance => _instance;
  
  TranzfortLlm._();

  /// Load a GGUF model from the given file path
  /// Returns true if successful, false otherwise
  Future<bool> loadModel({
    required String modelPath,
    int contextSize = 2048,
    int threads = 4,
    bool useGpu = false,
  }) {
    return TranzfortLlmPlatform.instance.loadModel(
      modelPath: modelPath,
      contextSize: contextSize,
      threads: threads,
      useGpu: useGpu,
    );
  }

  /// Unload the currently loaded model and free resources
  Future<void> unloadModel() {
    return TranzfortLlmPlatform.instance.unloadModel();
  }

  /// Check if a model is currently loaded
  Future<bool> isModelLoaded() {
    return TranzfortLlmPlatform.instance.isModelLoaded();
  }

  /// Generate text completion (non-streaming)
  /// Returns the generated text
  Future<String> generateText({
    required String prompt,
    int maxTokens = 512,
    double temperature = 0.7,
    double topP = 0.9,
    int topK = 40,
    String? stopSequence,
  }) {
    return TranzfortLlmPlatform.instance.generateText(
      prompt: prompt,
      maxTokens: maxTokens,
      temperature: temperature,
      topP: topP,
      topK: topK,
      stopSequence: stopSequence,
    );
  }

  /// Generate text completion with streaming
  /// Returns a stream of generated tokens
  Stream<String> generateTextStream({
    required String prompt,
    int maxTokens = 512,
    double temperature = 0.7,
    double topP = 0.9,
    int topK = 40,
    String? stopSequence,
  }) {
    return TranzfortLlmPlatform.instance.generateTextStream(
      prompt: prompt,
      maxTokens: maxTokens,
      temperature: temperature,
      topP: topP,
      topK: topK,
      stopSequence: stopSequence,
    );
  }

  /// Cancel ongoing generation
  Future<void> cancelGeneration() {
    return TranzfortLlmPlatform.instance.cancelGeneration();
  }

  /// Get platform version for debugging
  Future<String?> getPlatformVersion() {
    return TranzfortLlmPlatform.instance.getPlatformVersion();
  }
}
