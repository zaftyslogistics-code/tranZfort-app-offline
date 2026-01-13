import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tranzfort_llm_platform_interface.dart';

/// An implementation of [TranzfortLlmPlatform] that uses method channels.
class MethodChannelTranzfortLlm extends TranzfortLlmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tranzfort_llm');
  
  /// The event channel used for streaming token generation.
  @visibleForTesting
  final eventChannel = const EventChannel('tranzfort_llm/stream');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<bool> loadModel({
    required String modelPath,
    required int contextSize,
    required int threads,
    required bool useGpu,
  }) async {
    final result = await methodChannel.invokeMethod<bool>('loadModel', {
      'modelPath': modelPath,
      'contextSize': contextSize,
      'threads': threads,
      'useGpu': useGpu,
    });
    return result ?? false;
  }

  @override
  Future<void> unloadModel() async {
    await methodChannel.invokeMethod<void>('unloadModel');
  }

  @override
  Future<bool> isModelLoaded() async {
    final result = await methodChannel.invokeMethod<bool>('isModelLoaded');
    return result ?? false;
  }

  @override
  Future<String> generateText({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) async {
    final result = await methodChannel.invokeMethod<String>('generateText', {
      'prompt': prompt,
      'maxTokens': maxTokens,
      'temperature': temperature,
      'topP': topP,
      'topK': topK,
      'stopSequence': stopSequence,
    });
    return result ?? '';
  }

  @override
  Stream<String> generateTextStream({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) {
    // Start streaming generation via method channel
    methodChannel.invokeMethod<void>('startStreamingGeneration', {
      'prompt': prompt,
      'maxTokens': maxTokens,
      'temperature': temperature,
      'topP': topP,
      'topK': topK,
      'stopSequence': stopSequence,
    });
    
    // Return stream of tokens from event channel
    return eventChannel.receiveBroadcastStream().map((event) {
      if (event is String) {
        return event;
      } else if (event is Map) {
        // Handle error events
        if (event['error'] != null) {
          throw Exception(event['error']);
        }
        return event['token']?.toString() ?? '';
      }
      return '';
    });
  }

  @override
  Future<void> cancelGeneration() async {
    await methodChannel.invokeMethod<void>('cancelGeneration');
  }
}
