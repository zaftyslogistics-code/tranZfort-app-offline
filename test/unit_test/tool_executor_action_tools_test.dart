import 'package:flutter_test/flutter_test.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/domain/models/tool_call.dart';
import 'package:tranzfort_tms/domain/services/query_builder_service.dart';
import 'package:tranzfort_tms/domain/services/tool_executor.dart';
import 'package:tranzfort_tms/domain/services/tool_registry.dart';

void main() {
  group('ToolExecutor action tools', () {
    late AppDatabase db;
    late ToolExecutor executor;

    setUp(() {
      db = AppDatabase.forTesting();
      final registry = ToolRegistry.defaultRegistry();
      final queryBuilder = QueryBuilderService(db);
      executor = ToolExecutor(
        registry: registry,
        queryBuilder: queryBuilder,
        database: db,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('create_trip fails with missing required args', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '1',
          name: 'create_trip',
          arguments: {},
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('fromLocation'));
    });

    test('create_trip fails with empty fromLocation', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '1a',
          name: 'create_trip',
          arguments: {
            'fromLocation': '   ',
            'toLocation': 'Pune',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('fromLocation'));
    });

    test('create_trip fails with invalid startDate', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '1b',
          name: 'create_trip',
          arguments: {
            'fromLocation': 'Mumbai',
            'toLocation': 'Pune',
            'startDate': 'not-a-date',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('startDate'));
    });

    test('create_trip fails with freightAmount wrong type', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '1c',
          name: 'create_trip',
          arguments: {
            'fromLocation': 'Mumbai',
            'toLocation': 'Pune',
            'freightAmount': '5000',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('freightAmount'));
    });

    test('create_trip inserts trip into DB', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '2',
          name: 'create_trip',
          arguments: {
            'fromLocation': 'Mumbai',
            'toLocation': 'Pune',
            'freightAmount': 5000,
          },
        ),
      );

      expect(result.success, true);
      expect(result.data, isNotNull);
      expect(result.data!['tripId'], isNotNull);

      final trips = await db.select(db.trips).get();
      expect(trips.length, 1);
      expect(trips.first.fromLocation, 'Mumbai');
      expect(trips.first.toLocation, 'Pune');
      expect(trips.first.status, 'PENDING');
    });

    test('add_expense fails with invalid amount', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '3',
          name: 'add_expense',
          arguments: {
            'category': 'Fuel',
            'amount': 0,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('amount'));
    });

    test('add_expense fails with empty category', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '3a',
          name: 'add_expense',
          arguments: {
            'category': ' ',
            'amount': 100,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('category'));
    });

    test('add_expense fails with amount wrong type', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '3b',
          name: 'add_expense',
          arguments: {
            'category': 'Fuel',
            'amount': '1200',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('amount'));
    });

    test('add_expense inserts expense into DB', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '4',
          name: 'add_expense',
          arguments: {
            'category': 'Fuel',
            'amount': 1200,
            'paymentMode': 'cash',
            'description': 'Diesel refill',
          },
        ),
      );

      expect(result.success, true);

      final expenses = await db.select(db.expenses).get();
      expect(expenses.length, 1);
      expect(expenses.first.category, 'Fuel');
      expect(expenses.first.amount, 1200);
      expect(expenses.first.paidMode, 'cash');
    });

    test('add_payment fails with missing partyId', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '5',
          name: 'add_payment',
          arguments: {
            'amount': 1000,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('partyId'));
    });

    test('add_payment fails with empty partyId', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '5a',
          name: 'add_payment',
          arguments: {
            'partyId': ' ',
            'amount': 1000,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('partyId'));
    });

    test('add_payment fails with invalid date type', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '5b',
          name: 'add_payment',
          arguments: {
            'partyId': 'party_1',
            'amount': 1000,
            'date': 123,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('date'));
    });

    test('add_payment fails with invalid date string', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '5c',
          name: 'add_payment',
          arguments: {
            'partyId': 'party_1',
            'amount': 1000,
            'date': 'not-a-date',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('date'));
    });

    test('add_payment inserts payment into DB', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '6',
          name: 'add_payment',
          arguments: {
            'partyId': 'party_1',
            'amount': 2500,
            'paymentMode': 'cash',
          },
        ),
      );

      expect(result.success, true);

      final payments = await db.select(db.payments).get();
      expect(payments.length, 1);
      expect(payments.first.partyId, 'party_1');
      expect(payments.first.amount, 2500);
      expect(payments.first.mode, 'cash');
      expect(payments.first.type, 'RECEIVED');
    });

    test('query_trips fails with unknown keys', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '7',
          name: 'query_trips',
          arguments: {
            'badKey': 'x',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('Unknown keys'));
    });

    test('query_trips fails with invalid dateRange (end before start)', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '8',
          name: 'query_trips',
          arguments: {
            'dateRange': {
              'start': '2026-01-10T00:00:00',
              'end': '2026-01-09T00:00:00',
            },
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('dateRange'));
    });

    test('query_expenses fails with unknown keys', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '9',
          name: 'query_expenses',
          arguments: {
            'badKey': 'x',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('Unknown keys'));
    });

    test('query_expenses fails with invalid dateRange type', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '10',
          name: 'query_expenses',
          arguments: {
            'dateRange': 'not-an-object',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('dateRange'));
    });

    test('query_payments fails with unknown keys', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '11',
          name: 'query_payments',
          arguments: {
            'badKey': 'x',
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('Unknown keys'));
    });

    test('query_payments fails with invalid dateRange type', () async {
      final result = await executor.execute(
        const ToolCall(
          id: '12',
          name: 'query_payments',
          arguments: {
            'dateRange': 123,
          },
        ),
      );

      expect(result.success, false);
      expect(result.errorMessage, contains('dateRange'));
    });
  });
}
