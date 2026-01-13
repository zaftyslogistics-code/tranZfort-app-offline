import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TtsService {
  static final TtsService _instance = TtsService._();
  static TtsService get instance => _instance;
  
  TtsService._();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  
  bool _isEnabled = true;
  double _speechRate = 0.5;
  double _volume = 1.0;
  double _pitch = 1.0;
  String _language = 'en-US';

  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;
  double get speechRate => _speechRate;
  double get volume => _volume;
  double get pitch => _pitch;
  String get language => _language;

  Future<void> initialize() async {
    if (_isInitialized) return;

    _flutterTts = FlutterTts();

    await _loadPreferences();

    _flutterTts!.setStartHandler(() {
      _isSpeaking = true;
      if (kDebugMode) {
        print('[TtsService] Started speaking');
      }
    });

    _flutterTts!.setCompletionHandler(() {
      _isSpeaking = false;
      if (kDebugMode) {
        print('[TtsService] Completed speaking');
      }
    });

    _flutterTts!.setErrorHandler((msg) {
      _isSpeaking = false;
      if (kDebugMode) {
        print('[TtsService] Error: $msg');
      }
    });

    await _configureTts();
    _isInitialized = true;
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('tts_enabled') ?? true;
    _speechRate = prefs.getDouble('tts_speech_rate') ?? 0.5;
    _volume = prefs.getDouble('tts_volume') ?? 1.0;
    _pitch = prefs.getDouble('tts_pitch') ?? 1.0;
    _language = prefs.getString('tts_language') ?? 'en-US';
  }

  Future<void> _configureTts() async {
    if (_flutterTts == null) return;

    await _flutterTts!.setLanguage(_language);
    await _flutterTts!.setSpeechRate(_speechRate);
    await _flutterTts!.setVolume(_volume);
    await _flutterTts!.setPitch(_pitch);
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || text.isEmpty) return;

    await initialize();

    if (_isSpeaking) {
      await stop();
    }

    try {
      await _flutterTts!.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print('[TtsService] Failed to speak: $e');
      }
    }
  }

  Future<void> stop() async {
    if (_flutterTts == null) return;
    
    try {
      await _flutterTts!.stop();
      _isSpeaking = false;
    } catch (e) {
      if (kDebugMode) {
        print('[TtsService] Failed to stop: $e');
      }
    }
  }

  Future<void> pause() async {
    if (_flutterTts == null) return;
    
    try {
      await _flutterTts!.pause();
    } catch (e) {
      if (kDebugMode) {
        print('[TtsService] Failed to pause: $e');
      }
    }
  }

  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tts_enabled', enabled);
    
    if (!enabled && _isSpeaking) {
      await stop();
    }
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_speech_rate', _speechRate);
    
    if (_flutterTts != null) {
      await _flutterTts!.setSpeechRate(_speechRate);
    }
  }

  Future<void> setVolume(double vol) async {
    _volume = vol.clamp(0.0, 1.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_volume', _volume);
    
    if (_flutterTts != null) {
      await _flutterTts!.setVolume(_volume);
    }
  }

  Future<void> setPitch(double p) async {
    _pitch = p.clamp(0.5, 2.0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('tts_pitch', _pitch);
    
    if (_flutterTts != null) {
      await _flutterTts!.setPitch(_pitch);
    }
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tts_language', lang);
    
    if (_flutterTts != null) {
      await _flutterTts!.setLanguage(lang);
    }
  }

  Future<List<String>> getAvailableLanguages() async {
    await initialize();
    
    try {
      final languages = await _flutterTts!.getLanguages;
      if (languages is List) {
        return languages.cast<String>();
      }
      return ['en-US'];
    } catch (e) {
      if (kDebugMode) {
        print('[TtsService] Failed to get languages: $e');
      }
      return ['en-US'];
    }
  }

  void dispose() {
    _flutterTts?.stop();
    _isInitialized = false;
    _isSpeaking = false;
  }
}
