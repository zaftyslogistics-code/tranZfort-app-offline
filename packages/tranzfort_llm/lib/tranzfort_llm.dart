
import 'tranzfort_llm_platform_interface.dart';

class TranzfortLlm {
  Future<String?> getPlatformVersion() {
    return TranzfortLlmPlatform.instance.getPlatformVersion();
  }
}
