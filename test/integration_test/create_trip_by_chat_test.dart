import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/domain/models/query_intent.dart';
import 'package:tranzfort_tms/domain/services/agent_orchestrator.dart';
import 'package:tranzfort_tms/domain/services/ai_engine.dart';
import 'package:tranzfort_tms/domain/services/query_builder_service.dart';
import 'package:tranzfort_tms/domain/services/tool_executor.dart';
import 'package:tranzfort_tms/domain/services/tool_registry.dart';

class _FakeAiEngine implements AiEngine {
  final List<ChatMessage> _messages = [];

  @override
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  @override
  void clearHistory() {
    _messages.clear();
  }

  @override
  List<String> getSuggestions() => const [];

  @override
  Future<void> processUserMessage(String userInput) async {
    _messages.add(
      ChatMessage(
        id: 'u1',
        content: userInput,
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
    _messages.add(
      ChatMessage(
        id: 'a1',
        content: 'ok',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }
}

String _toolCallEnvelope({
  required String id,
  required String name,
  required Map<String, dynamic> arguments,
}) {
  return jsonEncode({
    'tool_call': {
      'id': id,
      'name': name,
      'arguments': arguments,
    },
  });
}

void main() {
  group('Phase1-K Integration: Create trip by chat', () {
    late AppDatabase db;
    late AgentOrchestrator orchestrator;

    setUp(() {
      db = AppDatabase.forTesting();

      final registry = ToolRegistry.defaultRegistry();
      final queryBuilder = QueryBuilderService(db);
      final executor = ToolExecutor(
        registry: registry,
        queryBuilder: queryBuilder,
        database: db,
      );

      orchestrator = AgentOrchestrator(
        engine: _FakeAiEngine(),
        toolExecutor: executor,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('tool_call -> confirmation -> execution inserts trip into DB', () async {
      final envelope = _toolCallEnvelope(
        id: 'tc_create_trip_integration_1',
        name: 'create_trip',
        arguments: {
          'fromLocation': 'Mumbai',
          'toLocation': 'Pune',
          'freightAmount': 5000,
        },
      );

      await orchestrator.sendMessage(envelope);

      expect(orchestrator.isAwaitingConfirmation, true);
      expect(orchestrator.pendingToolCall, isNotNull);

      await orchestrator.confirmToolExecution();

      final trips = await db.select(db.trips).get();
      expect(trips.length, 1);
      expect(trips.first.fromLocation, 'Mumbai');
      expect(trips.first.toLocation, 'Pune');

      // Tool result message should be present.
      expect(orchestrator.messages.length, 2);
      final toolMsg = orchestrator.messages.last;
      expect(toolMsg.isUser, false);
      expect(toolMsg.type, MessageType.data);
      expect(toolMsg.data, isNotNull);
      expect(toolMsg.data!['toolName'], 'create_trip');
      expect(toolMsg.data!['toolCallId'], 'tc_create_trip_integration_1');
    });
  });
}
