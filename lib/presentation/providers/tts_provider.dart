import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/tts_service.dart';

final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService.instance;
});

final ttsEnabledProvider = StateProvider<bool>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.isEnabled;
});

final ttsSpeakingProvider = StateProvider<bool>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.isSpeaking;
});

final ttsLanguageProvider = StateProvider<String>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.language;
});

final ttsSpeechRateProvider = StateProvider<double>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.speechRate;
});

final ttsVolumeProvider = StateProvider<double>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.volume;
});

final ttsPitchProvider = StateProvider<double>((ref) {
  final tts = ref.watch(ttsServiceProvider);
  return tts.pitch;
});

final availableLanguagesProvider = FutureProvider<List<String>>((ref) async {
  final tts = ref.watch(ttsServiceProvider);
  return await tts.getAvailableLanguages();
});
