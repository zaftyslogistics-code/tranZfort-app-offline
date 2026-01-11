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
}

void main() {
  final TranzfortLlmPlatform initialPlatform = TranzfortLlmPlatform.instance;

  test('$MethodChannelTranzfortLlm is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTranzfortLlm>());
  });

  test('getPlatformVersion', () async {
    TranzfortLlm tranzfortLlmPlugin = TranzfortLlm();
    MockTranzfortLlmPlatform fakePlatform = MockTranzfortLlmPlatform();
    TranzfortLlmPlatform.instance = fakePlatform;

    expect(await tranzfortLlmPlugin.getPlatformVersion(), '42');
  });
}
