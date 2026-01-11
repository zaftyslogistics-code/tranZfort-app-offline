import 'dart:io' show Platform;

import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice Input Service
/// Handles speech-to-text and text-to-speech for hands-free operation
class VoiceInputService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isInitialized = false;
  bool _isListening = false;
  String _currentLanguage = 'en-US';

  /// Initialize voice services
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      _isInitialized = await _speechToText.initialize(
        onError: (error) => print('Speech recognition error: $error'),
        onStatus: (status) => print('Speech recognition status: $status'),
      );

      if (_isInitialized) {
        await _configureTts();
      }

      return _isInitialized;
    } catch (e) {
      print('Error initializing voice services: $e');
      return false;
    }
  }

  /// Configure text-to-speech
  Future<void> _configureTts() async {
    await _flutterTts.setLanguage(_currentLanguage);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Check if speech recognition is available
  bool get isAvailable => _isInitialized;

  /// Check if currently listening
  bool get isListening => _isListening;

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    if (!_isInitialized) return [];
    
    final locales = await _speechToText.locales();
    return locales.map((locale) => locale.localeId).toList();
  }

  /// Set language for speech recognition
  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = _getLocaleId(languageCode);
    if (_isInitialized) {
      await _flutterTts.setLanguage(_currentLanguage);
    }
  }

  /// Convert app language code to locale ID
  String _getLocaleId(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'en-US';
      case 'hi':
        return 'hi-IN';
      case 'pa':
        return 'pa-IN';
      case 'ta':
        return 'ta-IN';
      case 'te':
        return 'te-IN';
      case 'mr':
        return 'mr-IN';
      case 'gu':
        return 'gu-IN';
      case 'bn':
        return 'bn-IN';
      default:
        return 'en-US';
    }
  }

  /// Start listening for voice input
  Future<void> startListening({
    required Function(String) onResult,
    Function(String)? onPartialResult,
  }) async {
    if (Platform.isWindows) {
      throw Exception(
        'Voice dictation is not available on this Windows setup (HRESULT: 80070490). '
        'Please enable Windows Speech features and microphone permission, or use voice input on Android.',
      );
    }

    if (!_isInitialized) {
      throw Exception('Voice service not initialized');
    }

    if (_isListening) {
      await stopListening();
    }

    _isListening = true;

    try {
      await _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            onResult(result.recognizedWords);
            _isListening = false;
          } else if (onPartialResult != null) {
            onPartialResult(result.recognizedWords);
          }
        },
        localeId: _currentLanguage,
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
        partialResults: true,
      );
    } catch (e) {
      _isListening = false;
      rethrow;
    }
  }

  /// Stop listening
  Future<void> stopListening() async {
    if (_isListening) {
      await _speechToText.stop();
      _isListening = false;
    }
  }

  /// Speak text (voice feedback)
  Future<void> speak(String text) async {
    if (!_isInitialized) return;
    
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking: $e');
    }
  }

  /// Stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  /// Parse voice command for expense entry
  ExpenseVoiceCommand? parseExpenseCommand(String text) {
    final lowerText = text.toLowerCase();
    
    // Extract amount
    final amountRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:rupees?|rs|₹)?');
    final amountMatch = amountRegex.firstMatch(lowerText);
    final amount = amountMatch != null ? double.tryParse(amountMatch.group(1)!) : null;

    // Extract category
    String? category;
    if (lowerText.contains('fuel') || lowerText.contains('diesel') || lowerText.contains('petrol')) {
      category = 'FUEL';
    } else if (lowerText.contains('toll')) {
      category = 'TOLL';
    } else if (lowerText.contains('food') || lowerText.contains('lunch') || lowerText.contains('dinner')) {
      category = 'FOOD';
    } else if (lowerText.contains('maintenance') || lowerText.contains('repair')) {
      category = 'MAINTENANCE';
    } else if (lowerText.contains('parking')) {
      category = 'PARKING';
    }

    if (amount != null) {
      return ExpenseVoiceCommand(
        amount: amount,
        category: category,
        notes: text,
      );
    }

    return null;
  }

  /// Parse voice command for trip updates
  TripVoiceCommand? parseTripCommand(String text) {
    final lowerText = text.toLowerCase();

    // Check for status updates
    if (lowerText.contains('complete') || lowerText.contains('finish')) {
      return TripVoiceCommand(
        action: TripAction.complete,
        status: 'COMPLETED',
      );
    } else if (lowerText.contains('start') || lowerText.contains('begin')) {
      return TripVoiceCommand(
        action: TripAction.start,
        status: 'IN_PROGRESS',
      );
    } else if (lowerText.contains('cancel')) {
      return TripVoiceCommand(
        action: TripAction.cancel,
        status: 'CANCELLED',
      );
    }

    // Check for location updates
    if (lowerText.contains('reached') || lowerText.contains('arrived')) {
      final locationRegex = RegExp(r'(?:reached|arrived)\s+(?:at\s+)?(.+)');
      final match = locationRegex.firstMatch(lowerText);
      if (match != null) {
        return TripVoiceCommand(
          action: TripAction.updateLocation,
          location: match.group(1)?.trim(),
        );
      }
    }

    return null;
  }

  /// Parse voice search query
  SearchVoiceCommand? parseSearchCommand(String text) {
    final lowerText = text.toLowerCase();

    // Time-based searches
    if (lowerText.contains('today')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'today',
      );
    } else if (lowerText.contains('yesterday')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'yesterday',
      );
    } else if (lowerText.contains('this week')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'this_week',
      );
    } else if (lowerText.contains('last week')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'last_week',
      );
    } else if (lowerText.contains('this month')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'this_month',
      );
    } else if (lowerText.contains('last month')) {
      return SearchVoiceCommand(
        type: SearchType.date,
        timeRange: 'last_month',
      );
    }

    // Entity-based searches
    if (lowerText.contains('trip')) {
      return SearchVoiceCommand(
        type: SearchType.trips,
        query: text,
      );
    } else if (lowerText.contains('expense')) {
      return SearchVoiceCommand(
        type: SearchType.expenses,
        query: text,
      );
    } else if (lowerText.contains('payment')) {
      return SearchVoiceCommand(
        type: SearchType.payments,
        query: text,
      );
    } else if (lowerText.contains('vehicle')) {
      return SearchVoiceCommand(
        type: SearchType.vehicles,
        query: text,
      );
    }

    return SearchVoiceCommand(
      type: SearchType.general,
      query: text,
    );
  }

  /// Dispose resources
  void dispose() {
    _speechToText.cancel();
    _flutterTts.stop();
  }
}

/// Expense voice command model
class ExpenseVoiceCommand {
  final double amount;
  final String? category;
  final String notes;

  ExpenseVoiceCommand({
    required this.amount,
    this.category,
    required this.notes,
  });
}

/// Trip voice command model
class TripVoiceCommand {
  final TripAction action;
  final String? status;
  final String? location;

  TripVoiceCommand({
    required this.action,
    this.status,
    this.location,
  });
}

enum TripAction {
  start,
  complete,
  cancel,
  updateLocation,
}

/// Search voice command model
class SearchVoiceCommand {
  final SearchType type;
  final String? query;
  final String? timeRange;

  SearchVoiceCommand({
    required this.type,
    this.query,
    this.timeRange,
  });
}

enum SearchType {
  general,
  trips,
  expenses,
  payments,
  vehicles,
  date,
}
