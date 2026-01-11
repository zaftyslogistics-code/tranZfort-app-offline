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
}
