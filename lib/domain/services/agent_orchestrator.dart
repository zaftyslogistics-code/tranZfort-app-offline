import 'package:flutter/foundation.dart';
import 'dart:convert';

import '../models/tool_call.dart';
import '../models/tool_result.dart';
import '../models/query_intent.dart';
import 'ai_engine.dart';
import 'tool_executor.dart';
import 'tool_registry.dart';

class AgentOrchestrator extends ChangeNotifier {
  final AiEngine _engine;
  final ToolExecutor _toolExecutor;

  bool _isProcessing = false;
  ToolResult? _lastToolResult;
  final List<ChatMessage> _messages = [];
  
  // Confirmation state
  ToolCall? _pendingToolCall;
  bool _isAwaitingConfirmation = false;

  AgentOrchestrator({
    required AiEngine engine,
    required ToolExecutor toolExecutor,
  })  : _engine = engine,
        _toolExecutor = toolExecutor;

  ToolResult? get lastToolResult => _lastToolResult;

  bool get isProcessing => _isProcessing;
  
  // Confirmation state getters
  bool get isAwaitingConfirmation => _isAwaitingConfirmation;
  ToolCall? get pendingToolCall => _pendingToolCall;

  List<ChatMessage> get messages {
    if (_messages.isEmpty) {
      _messages.addAll(_engine.messages);
    }
    return List.unmodifiable(_messages);
  }

  List<String> getSuggestions() => _engine.getSuggestions();

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    try {
      final toolCall = _tryParseToolCall(trimmed);
      if (toolCall != null) {
        _messages.add(
          ChatMessage(
            id: _newId(),
            content: trimmed,
            isUser: true,
            timestamp: DateTime.now(),
            type: MessageType.text,
          ),
        );
        
        // Check if this tool requires confirmation
        if (_requiresConfirmation(toolCall.name)) {
          _pendingToolCall = toolCall;
          _isAwaitingConfirmation = true;
          notifyListeners();
          return;
        }
        
        // Execute immediately if no confirmation required
        _lastToolResult = await _toolExecutor.execute(toolCall);

        final toolMessage = _toolResultToMessage(_lastToolResult!, toolCall.name);
        _messages.add(toolMessage);
        return;
      }

      if (_engine is StreamingAiEngine) {
        final streamEngine = _engine as StreamingAiEngine;

        await for (final _ in streamEngine.streamUserMessage(trimmed)) {
          _messages
            ..clear()
            ..addAll(_engine.messages);
          notifyListeners();
        }

        _messages
          ..clear()
          ..addAll(_engine.messages);
      } else {
        await _engine.processUserMessage(trimmed);

        _messages
          ..clear()
          ..addAll(_engine.messages);
      }
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  void clearHistory() {
    _engine.clearHistory();
    _lastToolResult = null;
    _messages.clear();
    _pendingToolCall = null;
    _isAwaitingConfirmation = false;
    notifyListeners();
  }

  // Confirmation methods
  Future<void> confirmToolExecution() async {
    if (_pendingToolCall == null) return;
    
    _isAwaitingConfirmation = false;
    _isProcessing = true;
    notifyListeners();

    try {
      _lastToolResult = await _toolExecutor.execute(_pendingToolCall!);
      
      final toolMessage = _toolResultToMessage(_lastToolResult!, _pendingToolCall!.name);
      _messages.add(toolMessage);
    } catch (e) {
      // Handle error
      _lastToolResult = ToolResult.failure(_pendingToolCall!.id, 'Failed to execute tool: $e');
      final errorMessage = _toolResultToMessage(_lastToolResult!, _pendingToolCall!.name);
      _messages.add(errorMessage);
    } finally {
      _pendingToolCall = null;
      _isProcessing = false;
      notifyListeners();
    }
  }

  void cancelToolExecution() {
    _pendingToolCall = null;
    _isAwaitingConfirmation = false;
    notifyListeners();
  }

  bool _requiresConfirmation(String toolName) {
    // Define which tools require confirmation (mutations)
    const mutationTools = {
      'create_trip',
      'add_expense',
      'add_payment',
      'update_trip',
      'update_trip_status',
      'delete_trip',
      'schedule_maintenance',
    };
    return mutationTools.contains(toolName);
  }

  ToolCall? _tryParseToolCall(String input) {
    // We deliberately do NOT attempt to parse free-form user text here.
    // Only accept an explicit JSON envelope.
    // Example:
    // {"tool_call": {"id": "1", "name": "query_trips", "arguments": {"status": "COMPLETED"}}}
    final trimmed = input.trim();
    if (!trimmed.startsWith('{')) return null;

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) return null;

      final toolCallRaw = decoded['tool_call'];
      if (toolCallRaw is! Map) return null;

      final name = toolCallRaw['name'];
      final args = toolCallRaw['arguments'];
      if (name is! String) return null;
      if (args is! Map) return null;

      final id = toolCallRaw['id'];

      return ToolCall(
        id: id is String && id.isNotEmpty ? id : _newId(),
        name: name,
        arguments: Map<String, dynamic>.from(args as Map),
      );
    } catch (_) {
      return null;
    }
  }

  ChatMessage _toolResultToMessage(ToolResult result, String toolName) {
    final now = DateTime.now();

    if (!result.success) {
      return ChatMessage(
        id: _newId(),
        content: result.errorMessage ?? 'Tool failed: $toolName',
        isUser: false,
        timestamp: now,
        type: MessageType.error,
      );
    }

    final data = <String, dynamic>{
      ...(result.data ?? <String, dynamic>{}),
      'toolName': toolName,
      'toolCallId': result.toolCallId,
    };
    final type = data['type'] as String?;
    final count = data['count'] as int?;

    final summary = _summarizeQueryResult(toolName: toolName, type: type, count: count);

    return ChatMessage(
      id: _newId(),
      content: summary,
      isUser: false,
      timestamp: now,
      type: MessageType.data,
      data: data,
    );
  }

  String _summarizeQueryResult({
    required String toolName,
    required String? type,
    required int? count,
  }) {
    if (type != null && count != null) {
      return 'Tool result ($toolName): found $count $type.';
    }
    return 'Tool result ($toolName) ready.';
  }

  String _newId() => DateTime.now().microsecondsSinceEpoch.toString();
}
