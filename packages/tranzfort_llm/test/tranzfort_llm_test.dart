import 'package:flutter_test/flutter_test.dart';
import 'package:tranzfort_llm/tranzfort_llm.dart';
import 'package:tranzfort_llm/tranzfort_llm_platform_interface.dart';
import 'package:tranzfort_llm/tranzfort_llm_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTranzfortLlmPlatform
    with MockPlatformInterfaceMixin
    implements TranzfortLlmPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> loadModel({
    required String modelPath,
    required int contextSize,
    required int threads,
    required bool useGpu,
  }) => Future.value(true);

  @override
  Future<void> unloadModel() => Future.value();

  @override
  Future<bool> isModelLoaded() => Future.value(false);

  @override
  Future<String> generateText({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) => Future.value('Mock response');

  @override
  Stream<String> generateTextStream({
    required String prompt,
    required int maxTokens,
    required double temperature,
    required double topP,
    required int topK,
    String? stopSequence,
  }) => Stream.value('Mock stream response');

  @override
  Future<void> cancelGeneration() => Future.value();
}

void main() {
  final TranzfortLlmPlatform initialPlatform = TranzfortLlmPlatform.instance;

  test('$MethodChannelTranzfortLlm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTranzfortLlm>());
  });

  test('getPlatformVersion', () async {
    final TranzfortLlm tranzfortLlmPlugin = TranzfortLlm.instance;
    MockTranzfortLlmPlatform fakePlatform = MockTranzfortLlmPlatform();
    TranzfortLlmPlatform.instance = fakePlatform;

    expect(await tranzfortLlmPlugin.getPlatformVersion(), '42');
  });
}
