import 'package:flutter/foundation.dart';

import '../models/query_intent.dart';
import 'ai_engine.dart';

class AgentOrchestrator extends ChangeNotifier {
  final AiEngine _engine;

  bool _isProcessing = false;

  AgentOrchestrator({
    required AiEngine engine,
  }) : _engine = engine;

  bool get isProcessing => _isProcessing;

  List<ChatMessage> get messages => _engine.messages;

  List<String> getSuggestions() => _engine.getSuggestions();

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      await _engine.processUserMessage(trimmed);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearHistory() {
    _engine.clearHistory();
    notifyListeners();
  }
}
