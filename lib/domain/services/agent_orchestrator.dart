import 'package:flutter/foundation.dart';

import '../models/tool_call.dart';
import '../models/tool_result.dart';
import '../models/query_intent.dart';
import 'ai_engine.dart';
import 'tool_executor.dart';

class AgentOrchestrator extends ChangeNotifier {
  final AiEngine _engine;
  final ToolExecutor _toolExecutor;

  bool _isProcessing = false;
  ToolResult? _lastToolResult;

  AgentOrchestrator({
    required AiEngine engine,
    required ToolExecutor toolExecutor,
  })  : _engine = engine,
        _toolExecutor = toolExecutor;

  ToolResult? get lastToolResult => _lastToolResult;

  bool get isProcessing => _isProcessing;

  List<ChatMessage> get messages => _engine.messages;

  List<String> getSuggestions() => _engine.getSuggestions();

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final toolCall = _tryParseToolCall(trimmed);
      if (toolCall != null) {
        _lastToolResult = await _toolExecutor.execute(toolCall);
        return;
      }
      await _engine.processUserMessage(trimmed);
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearHistory() {
    _engine.clearHistory();
    _lastToolResult = null;
    notifyListeners();
  }

  ToolCall? _tryParseToolCall(String input) {
    // Placeholder: real tool-call parsing will be implemented in Phase1-F.
    // We deliberately do NOT attempt to parse free-form user text here.
    // Expected future envelope example:
    // {"tool_call": {"id": "...", "name": "query_trips", "arguments": {}}}
    return null;
  }
}
