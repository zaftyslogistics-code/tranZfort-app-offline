import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'tranzfort_llm_platform_interface.dart';

/// An implementation of [TranzfortLlmPlatform] that uses method channels.
class MethodChannelTranzfortLlm extends TranzfortLlmPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('tranzfort_llm');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
