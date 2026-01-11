import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tranzfort_llm/tranzfort_llm_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelTranzfortLlm platform = MethodChannelTranzfortLlm();
  const MethodChannel channel = MethodChannel('tranzfort_llm');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
