import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import '../models/tool_call.dart';
import '../models/tool_result.dart';
import '../models/query_intent.dart';
import 'tool_registry.dart';
import 'query_builder_service.dart';
import 'tools/navigation_tools.dart';
import 'tools/analytics_tools.dart';
import 'tools/trip_update_tools.dart';
import '../../data/database.dart';

class ToolExecutor {
  final ToolRegistry _registry;
  final QueryBuilderService _queryBuilder;
  final AppDatabase? _database;

  ToolExecutor({
    required ToolRegistry registry,
    required QueryBuilderService queryBuilder,
    AppDatabase? database,
  })  : _registry = registry,
        _queryBuilder = queryBuilder,
        _database = database;

  Future<ToolResult> execute(ToolCall call) async {
    final tool = _registry.findByName(call.name);
    if (tool == null) {
      return ToolResult.failure(call.id, 'Unknown tool: ${call.name}');
    }

    if (call.name == 'query_trips') {
      return _executeQueryTrips(call);
    }

    if (call.name == 'query_expenses') {
      return _executeQueryExpenses(call);
    }

    if (call.name == 'query_payments') {
      return _executeQueryPayments(call);
    }

    if (call.name == 'create_trip') {
      return _executeCreateTrip(call);
    }

    if (call.name == 'add_expense') {
      return _executeAddExpense(call);
    }

    if (call.name == 'add_payment') {
      return _executeAddPayment(call);
    }

    if (call.name == NavigationTools.openScreenToolName) {
      return _executeOpenScreen(call);
    }

    if (call.name == NavigationTools.showInsightsToolName) {
      return _executeShowInsights(call);
    }

    if (call.name == AnalyticsTools.getTripProfitToolName) {
      return _executeGetTripProfit(call);
    }

    if (call.name == AnalyticsTools.getMonthlyProfitTrendToolName) {
      return _executeGetMonthlyProfitTrend(call);
    }

    if (call.name == AnalyticsTools.getCashflowToolName) {
      return _executeGetCashflow(call);
    }

    if (call.name == AnalyticsTools.getExpenseBreakdownToolName) {
      return _executeGetExpenseBreakdown(call);
    }

    if (call.name == AnalyticsTools.getRouteProfitabilityToolName) {
      return _executeGetRouteProfitability(call);
    }

    if (call.name == AnalyticsTools.getDriverPerformanceToolName) {
      return _executeGetDriverPerformance(call);
    }

    if (call.name == TripUpdateTools.updateTripToolName) {
      return _executeUpdateTrip(call);
    }

    if (call.name == TripUpdateTools.updateTripStatusToolName) {
      return _executeUpdateTripStatus(call);
    }

    if (call.name == TripUpdateTools.scheduleMaintenanceToolName) {
      return _executeScheduleMaintenance(call);
    }

    return ToolResult.failure(call.id, 'Tool not implemented: ${tool.name}');
  }

  Future<ToolResult> _executeQueryTrips(ToolCall call) async {
    final validationError = _validateQueryTripsArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for query_trips: $validationError');
    }

    final entities = <String, dynamic>{
      'entityType': 'trips',
    };

    final dateRangeResult = _parseDateRange(call.arguments);
    if (dateRangeResult.errorMessage != null) {
      return ToolResult.failure(call.id, dateRangeResult.errorMessage!);
    }
    if (dateRangeResult.value != null) {
      entities['dateRange'] = dateRangeResult.value;
    }

    final status = call.arguments['status'];
    if (status is String && status.trim().isNotEmpty) {
      entities['status'] = status.trim();
    }

    final location = call.arguments['location'];
    if (location is String && location.trim().isNotEmpty) {
      entities['location'] = location.trim();
    }

    final intent = QueryIntent(
      type: IntentType.query,
      action: 'show',
      entities: entities,
      confidence: 1.0,
    );

    final result = await _queryBuilder.executeQuery(intent);
    if (result['success'] == true) {
      return ToolResult.success(call.id, result);
    }
    return ToolResult.failure(call.id, (result['error'] as String?) ?? 'Query failed');
  }

  Future<ToolResult> _executeQueryExpenses(ToolCall call) async {
    final validationError = _validateQueryExpensesArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for query_expenses: $validationError');
    }

    final entities = <String, dynamic>{
      'entityType': 'expenses',
    };

    final dateRangeResult = _parseDateRange(call.arguments);
    if (dateRangeResult.errorMessage != null) {
      return ToolResult.failure(call.id, dateRangeResult.errorMessage!);
    }
    if (dateRangeResult.value != null) {
      entities['dateRange'] = dateRangeResult.value;
    }

    final category = call.arguments['category'];
    if (category is String && category.trim().isNotEmpty) {
      entities['category'] = category.trim();
    }

    final intent = QueryIntent(
      type: IntentType.query,
      action: 'show',
      entities: entities,
      confidence: 1.0,
    );

    final result = await _queryBuilder.executeQuery(intent);
    if (result['success'] == true) {
      return ToolResult.success(call.id, result);
    }
    return ToolResult.failure(call.id, (result['error'] as String?) ?? 'Query failed');
  }

  Future<ToolResult> _executeQueryPayments(ToolCall call) async {
    final validationError = _validateQueryPaymentsArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for query_payments: $validationError');
    }

    final entities = <String, dynamic>{
      'entityType': 'payments',
    };

    final dateRangeResult = _parseDateRange(call.arguments);
    if (dateRangeResult.errorMessage != null) {
      return ToolResult.failure(call.id, dateRangeResult.errorMessage!);
    }
    if (dateRangeResult.value != null) {
      entities['dateRange'] = dateRangeResult.value;
    }

    final intent = QueryIntent(
      type: IntentType.query,
      action: 'show',
      entities: entities,
      confidence: 1.0,
    );

    final result = await _queryBuilder.executeQuery(intent);
    if (result['success'] == true) {
      return ToolResult.success(call.id, result);
    }
    return ToolResult.failure(call.id, (result['error'] as String?) ?? 'Query failed');
  }

  String? _validateQueryTripsArgs(Map<String, dynamic> args) {
    final allowedKeys = {'dateRange', 'status', 'location'};
    final unknownKeys = args.keys.where((k) => !allowedKeys.contains(k)).toList();
    if (unknownKeys.isNotEmpty) {
      return 'Unknown keys: ${unknownKeys.join(', ')}';
    }

    final status = args['status'];
    if (status != null && status is! String) {
      return 'status must be a string';
    }

    final location = args['location'];
    if (location != null && location is! String) {
      return 'location must be a string';
    }

    final dateRangeError = _validateDateRange(args['dateRange']);
    if (dateRangeError != null) return dateRangeError;

    return null;
  }

  String? _validateQueryExpensesArgs(Map<String, dynamic> args) {
    final allowedKeys = {'dateRange', 'category'};
    final unknownKeys = args.keys.where((k) => !allowedKeys.contains(k)).toList();
    if (unknownKeys.isNotEmpty) {
      return 'Unknown keys: ${unknownKeys.join(', ')}';
    }

    final category = args['category'];
    if (category != null && category is! String) {
      return 'category must be a string';
    }

    final dateRangeError = _validateDateRange(args['dateRange']);
    if (dateRangeError != null) return dateRangeError;

    return null;
  }

  String? _validateQueryPaymentsArgs(Map<String, dynamic> args) {
    final allowedKeys = {'dateRange'};
    final unknownKeys = args.keys.where((k) => !allowedKeys.contains(k)).toList();
    if (unknownKeys.isNotEmpty) {
      return 'Unknown keys: ${unknownKeys.join(', ')}';
    }

    final dateRangeError = _validateDateRange(args['dateRange']);
    if (dateRangeError != null) return dateRangeError;

    return null;
  }

  String? _validateDateRange(Object? rawDateRange) {
    if (rawDateRange == null) return null;
    if (rawDateRange is! Map) {
      return 'dateRange must be an object with ISO8601 start/end';
    }

    final startRaw = rawDateRange['start'];
    final endRaw = rawDateRange['end'];
    if (startRaw == null || endRaw == null) {
      return 'dateRange requires both start and end';
    }
    if (startRaw is! String || endRaw is! String) {
      return 'dateRange.start and dateRange.end must be strings';
    }

    try {
      final start = DateTime.parse(startRaw);
      final end = DateTime.parse(endRaw);
      if (end.isBefore(start)) {
        return 'dateRange.end must be after dateRange.start';
      }
    } catch (_) {
      return 'dateRange.start/end must be ISO8601 strings (e.g. 2026-01-12T00:00:00)';
    }

    return null;
  }

  _ParseResult<Map<String, DateTime>> _parseDateRange(Map<String, dynamic> args) {
    final rawDateRange = args['dateRange'];
    if (rawDateRange == null) return const _ParseResult(value: null, errorMessage: null);
    if (rawDateRange is! Map) {
      return const _ParseResult(
        value: null,
        errorMessage: 'Invalid dateRange: must be an object with start/end',
      );
    }

    final startRaw = rawDateRange['start'];
    final endRaw = rawDateRange['end'];
    if (startRaw is! String || endRaw is! String) {
      return const _ParseResult(
        value: null,
        errorMessage: 'Invalid dateRange: start/end must be strings',
      );
    }

    try {
      final start = DateTime.parse(startRaw);
      final end = DateTime.parse(endRaw);
      if (end.isBefore(start)) {
        return const _ParseResult(
          value: null,
          errorMessage: 'Invalid dateRange: end must be after start',
        );
      }
      return _ParseResult(value: {'start': start, 'end': end}, errorMessage: null);
    } catch (_) {
      return const _ParseResult(
        value: null,
        errorMessage: 'Invalid dateRange: start/end must be ISO8601 strings',
      );
    }
  }

  Future<ToolResult> _executeCreateTrip(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }

    final validationError = _validateCreateTripArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for create_trip: $validationError');
    }

    try {
      final args = call.arguments;
      final tripId = const Uuid().v4();
      final now = DateTime.now();

      final startDate = args['startDate'] != null
          ? DateTime.parse(args['startDate'] as String)
          : now;

      final trip = TripsCompanion(
        id: drift.Value(tripId),
        fromLocation: drift.Value(args['fromLocation'] as String),
        toLocation: drift.Value(args['toLocation'] as String),
        vehicleId: drift.Value(args['vehicleId'] as String? ?? ''),
        driverId: drift.Value(args['driverId'] as String? ?? ''),
        partyId: drift.Value(args['partyId'] as String? ?? ''),
        freightAmount: drift.Value((args['freightAmount'] as num?)?.toDouble() ?? 0.0),
        advanceAmount: drift.Value((args['advancePaid'] as num?)?.toDouble()),
        status: const drift.Value('PENDING'),
        startDate: drift.Value(startDate),
        expectedEndDate: const drift.Value(null),
        actualEndDate: const drift.Value(null),
        notes: drift.Value(args['notes'] as String?),
        createdAt: drift.Value(now),
        updatedAt: drift.Value(now),
      );

      await _database!.into(_database!.trips).insert(trip);

      return ToolResult.success(call.id, {
        'success': true,
        'tripId': tripId,
        'message': 'Trip created successfully from ${args['fromLocation']} to ${args['toLocation']}',
        'data': {
          'id': tripId,
          'fromLocation': args['fromLocation'],
          'toLocation': args['toLocation'],
          'status': 'PENDING',
          'freightAmount': args['freightAmount'] ?? 0.0,
        },
      });
    } catch (e) {
      return ToolResult.failure(call.id, 'Failed to create trip: $e');
    }
  }

  Future<ToolResult> _executeAddExpense(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }

    final validationError = _validateAddExpenseArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for add_expense: $validationError');
    }

    try {
      final args = call.arguments;
      final expenseId = const Uuid().v4();
      final now = DateTime.now();

      final expense = ExpensesCompanion(
        id: drift.Value(expenseId),
        tripId: drift.Value(args['tripId'] as String? ?? ''),
        category: drift.Value(args['category'] as String),
        amount: drift.Value((args['amount'] as num).toDouble()),
        paidMode: drift.Value(args['paymentMode'] as String? ?? 'cash'),
        billImagePath: const drift.Value(null),
        notes: drift.Value(args['description'] as String?),
        createdAt: drift.Value(now),
        updatedAt: drift.Value(now),
      );

      await _database!.into(_database!.expenses).insert(expense);

      return ToolResult.success(call.id, {
        'success': true,
        'expenseId': expenseId,
        'message': 'Expense added: ${args['category']} - ₹${args['amount']}',
        'data': {
          'id': expenseId,
          'category': args['category'],
          'amount': args['amount'],
          'paymentMode': args['paymentMode'] ?? 'cash',
        },
      });
    } catch (e) {
      return ToolResult.failure(call.id, 'Failed to add expense: $e');
    }
  }

  Future<ToolResult> _executeAddPayment(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }

    final validationError = _validateAddPaymentArgs(call.arguments);
    if (validationError != null) {
      return ToolResult.failure(call.id, 'Invalid arguments for add_payment: $validationError');
    }

    try {
      final args = call.arguments;
      final paymentId = const Uuid().v4();
      final now = DateTime.now();

      final paymentDate = args['date'] != null
          ? DateTime.parse(args['date'] as String)
          : now;

      final payment = PaymentsCompanion(
        id: drift.Value(paymentId),
        tripId: drift.Value(args['tripId'] as String?),
        partyId: drift.Value(args['partyId'] as String),
        amount: drift.Value((args['amount'] as num).toDouble()),
        type: const drift.Value('RECEIVED'),
        mode: drift.Value(args['paymentMode'] as String? ?? 'cash'),
        date: drift.Value(paymentDate),
        notes: drift.Value(args['notes'] as String?),
        createdAt: drift.Value(now),
        updatedAt: drift.Value(now),
      );

      await _database!.into(_database!.payments).insert(payment);

      return ToolResult.success(call.id, {
        'success': true,
        'paymentId': paymentId,
        'message': 'Payment recorded: ₹${args['amount']} from party ${args['partyId']}',
        'data': {
          'id': paymentId,
          'partyId': args['partyId'],
          'amount': args['amount'],
          'mode': args['paymentMode'] ?? 'cash',
          'date': paymentDate.toIso8601String(),
        },
      });
    } catch (e) {
      return ToolResult.failure(call.id, 'Failed to add payment: $e');
    }
  }

  String? _validateCreateTripArgs(Map<String, dynamic> args) {
    if (!args.containsKey('fromLocation') || args['fromLocation'] is! String || (args['fromLocation'] as String).trim().isEmpty) {
      return 'fromLocation is required and must be a non-empty string';
    }
    if (!args.containsKey('toLocation') || args['toLocation'] is! String || (args['toLocation'] as String).trim().isEmpty) {
      return 'toLocation is required and must be a non-empty string';
    }

    final freightAmount = args['freightAmount'];
    if (freightAmount != null && freightAmount is! num) {
      return 'freightAmount must be a number';
    }

    final advancePaid = args['advancePaid'];
    if (advancePaid != null && advancePaid is! num) {
      return 'advancePaid must be a number';
    }

    final startDate = args['startDate'];
    if (startDate != null) {
      if (startDate is! String) {
        return 'startDate must be an ISO 8601 string';
      }
      try {
        DateTime.parse(startDate);
      } catch (_) {
        return 'startDate must be a valid ISO 8601 date string';
      }
    }

    return null;
  }

  String? _validateAddExpenseArgs(Map<String, dynamic> args) {
    if (!args.containsKey('category') || args['category'] is! String || (args['category'] as String).trim().isEmpty) {
      return 'category is required and must be a non-empty string';
    }
    if (!args.containsKey('amount') || args['amount'] is! num) {
      return 'amount is required and must be a number';
    }
    if ((args['amount'] as num) <= 0) {
      return 'amount must be greater than 0';
    }

    return null;
  }

  String? _validateAddPaymentArgs(Map<String, dynamic> args) {
    if (!args.containsKey('partyId') || args['partyId'] is! String || (args['partyId'] as String).trim().isEmpty) {
      return 'partyId is required and must be a non-empty string';
    }
    if (!args.containsKey('amount') || args['amount'] is! num) {
      return 'amount is required and must be a number';
    }
    if ((args['amount'] as num) <= 0) {
      return 'amount must be greater than 0';
    }

    final date = args['date'];
    if (date != null) {
      if (date is! String) {
        return 'date must be an ISO 8601 string';
      }
      try {
        DateTime.parse(date);
      } catch (_) {
        return 'date must be a valid ISO 8601 date string';
      }
    }

    return null;
  }

  Future<ToolResult> _executeOpenScreen(ToolCall call) async {
    final result = NavigationTools.executeOpenScreen(call.arguments);
    if (result.success) {
      return ToolResult.success(call.id, result.data ?? {});
    }
    return ToolResult.failure(call.id, result.errorMessage ?? 'Failed to open screen');
  }

  Future<ToolResult> _executeShowInsights(ToolCall call) async {
    final result = NavigationTools.executeShowInsights(call.arguments);
    if (result.success) {
      return ToolResult.success(call.id, result.data ?? {});
    }
    return ToolResult.failure(call.id, result.errorMessage ?? 'Failed to show insights');
  }

  Future<ToolResult> _executeGetTripProfit(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetTripProfit(call.arguments, _database!);
  }

  Future<ToolResult> _executeGetMonthlyProfitTrend(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetMonthlyProfitTrend(call.arguments, _database!);
  }

  Future<ToolResult> _executeGetCashflow(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetCashflow(call.arguments, _database!);
  }

  Future<ToolResult> _executeGetExpenseBreakdown(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetExpenseBreakdown(call.arguments, _database!);
  }

  Future<ToolResult> _executeGetRouteProfitability(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetRouteProfitability(call.arguments, _database!);
  }

  Future<ToolResult> _executeGetDriverPerformance(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await AnalyticsTools.executeGetDriverPerformance(call.arguments, _database!);
  }

  Future<ToolResult> _executeUpdateTrip(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await TripUpdateTools.executeUpdateTrip(call.arguments, _database!);
  }

  Future<ToolResult> _executeUpdateTripStatus(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await TripUpdateTools.executeUpdateTripStatus(call.arguments, _database!);
  }

  Future<ToolResult> _executeScheduleMaintenance(ToolCall call) async {
    if (_database == null) {
      return ToolResult.failure(call.id, 'Database not available');
    }
    return await TripUpdateTools.executeScheduleMaintenance(call.arguments, _database!);
  }
}

class _ParseResult<T> {
  final T? value;
  final String? errorMessage;

  const _ParseResult({
    required this.value,
    required this.errorMessage,
  });
}
