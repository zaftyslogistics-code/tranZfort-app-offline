import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'tranzfort_llm_method_channel.dart';

abstract class TranzfortLlmPlatform extends PlatformInterface {
  /// Constructs a TranzfortLlmPlatform.
  TranzfortLlmPlatform() : super(token: _token);

  static final Object _token = Object();

  static TranzfortLlmPlatform _instance = MethodChannelTranzfortLlm();

  /// The default instance of [TranzfortLlmPlatform] to use.
  ///
  /// Defaults to [MethodChannelTranzfortLlm].
  static TranzfortLlmPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [TranzfortLlmPlatform] when
  /// they register themselves.
  static set instance(TranzfortLlmPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<bool> loadModel({
    required String modelPath,
    required int contextSize,
    required int threads,
    required bool useGpu,
  }) {
    throw UnimplementedError('loadModel() has not been implemented.');
  }

  Future<void> unloadModel() {
    throw UnimplementedError('unloadModel() has not been implemented.');
  }

  Future<bool> isModelLoaded() {
    throw UnimplementedError('isModelLoaded() has not been implemented.');
  }

  Future<String> generateText({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) {
    throw UnimplementedError('generateText() has not been implemented.');
  }

  Stream<String> generateTextStream({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) {
    throw UnimplementedError('generateTextStream() has not been implemented.');
  }

  Future<void> cancelGeneration() {
    throw UnimplementedError('cancelGeneration() has not been implemented.');
  }
}
