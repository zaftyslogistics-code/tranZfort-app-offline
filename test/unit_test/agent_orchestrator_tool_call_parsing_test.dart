import 'dart:convert';

import 'package:drift/drift.dart' as drift;
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
  group('AgentOrchestrator tool_call parsing', () {
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

    test('mutation tool_call enters confirmation state and executes on confirm', () async {
      final envelope = _toolCallEnvelope(
        id: 'tc_create_trip_1',
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
      expect(orchestrator.pendingToolCall!.name, 'create_trip');
      expect(orchestrator.messages.length, 1);
      expect(orchestrator.messages.first.isUser, true);

      await orchestrator.confirmToolExecution();

      expect(orchestrator.isAwaitingConfirmation, false);
      expect(orchestrator.pendingToolCall, isNull);
      expect(orchestrator.messages.length, 2);

      final last = orchestrator.messages.last;
      expect(last.isUser, false);
      expect(last.type, MessageType.data);
      expect(last.data, isNotNull);
      expect(last.data!['toolName'], 'create_trip');
      expect(last.data!['toolCallId'], 'tc_create_trip_1');

      final trips = await db.select(db.trips).get();
      expect(trips.length, 1);
      expect(trips.first.fromLocation, 'Mumbai');
      expect(trips.first.toLocation, 'Pune');
    });

    test('query tool_call executes immediately without confirmation', () async {
      final now = DateTime.now();
      await db.into(db.trips).insert(
            TripsCompanion(
              id: const drift.Value('t1'),
              fromLocation: const drift.Value('Delhi'),
              toLocation: const drift.Value('Jaipur'),
              vehicleId: const drift.Value(''),
              driverId: const drift.Value(''),
              partyId: const drift.Value(''),
              freightAmount: const drift.Value(1000.0),
              advanceAmount: const drift.Value(null),
              status: const drift.Value('PENDING'),
              startDate: drift.Value(now),
              expectedEndDate: const drift.Value(null),
              actualEndDate: const drift.Value(null),
              notes: const drift.Value(null),
              createdAt: drift.Value(now),
              updatedAt: drift.Value(now),
            ),
          );

      final envelope = _toolCallEnvelope(
        id: 'tc_query_trips_1',
        name: 'query_trips',
        arguments: {
          'status': 'PENDING',
        },
      );

      await orchestrator.sendMessage(envelope);

      expect(orchestrator.isAwaitingConfirmation, false);
      expect(orchestrator.pendingToolCall, isNull);
      expect(orchestrator.messages.length, 2);

      final last = orchestrator.messages.last;
      expect(last.isUser, false);
      expect(last.type, MessageType.data);
      expect(last.data, isNotNull);
      expect(last.data!['toolName'], 'query_trips');
      expect(last.data!['toolCallId'], 'tc_query_trips_1');
    });

    test('cancelToolExecution clears confirmation state', () async {
      final envelope = _toolCallEnvelope(
        id: 'tc_cancel_1',
        name: 'add_expense',
        arguments: {
          'category': 'Fuel',
          'amount': 100,
        },
      );

      await orchestrator.sendMessage(envelope);
      expect(orchestrator.isAwaitingConfirmation, true);
      expect(orchestrator.pendingToolCall, isNotNull);

      orchestrator.cancelToolExecution();
      expect(orchestrator.isAwaitingConfirmation, false);
      expect(orchestrator.pendingToolCall, isNull);
    });
  });
}
