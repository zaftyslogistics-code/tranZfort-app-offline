import '../../../domain/models/tool_result.dart';
import '../../../data/database.dart';

class AnalyticsTools {
  static const String getTripProfitToolName = 'get_trip_profit';
  static const String getMonthlyProfitTrendToolName = 'get_monthly_profit_trend';
  static const String getCashflowToolName = 'get_cashflow';
  static const String getExpenseBreakdownToolName = 'get_expense_breakdown';
  static const String getRouteProfitabilityToolName = 'get_route_profitability';
  static const String getDriverPerformanceToolName = 'get_driver_performance';

  static Map<String, dynamic> getTripProfitSchema() {
    return {
      'name': getTripProfitToolName,
      'description': 'Calculate profit for a specific trip',
      'parameters': {
        'type': 'object',
        'properties': {
          'tripId': {
            'type': 'string',
            'description': 'Trip ID to calculate profit for',
          },
        },
        'required': ['tripId'],
      },
    };
  }

  static Map<String, dynamic> getMonthlyProfitTrendSchema() {
    return {
      'name': getMonthlyProfitTrendToolName,
      'description': 'Get monthly profit trend for the last N months',
      'parameters': {
        'type': 'object',
        'properties': {
          'months': {
            'type': 'number',
            'description': 'Number of months to include (default: 6)',
          },
        },
      },
    };
  }

  static Map<String, dynamic> getCashflowSchema() {
    return {
      'name': getCashflowToolName,
      'description': 'Get cashflow breakdown (income vs expenses)',
      'parameters': {
        'type': 'object',
        'properties': {
          'startDate': {
            'type': 'string',
            'description': 'Start date (ISO 8601 format)',
          },
          'endDate': {
            'type': 'string',
            'description': 'End date (ISO 8601 format)',
          },
        },
      },
    };
  }

  static Map<String, dynamic> getExpenseBreakdownSchema() {
    return {
      'name': getExpenseBreakdownToolName,
      'description': 'Get expense breakdown by category',
      'parameters': {
        'type': 'object',
        'properties': {
          'startDate': {
            'type': 'string',
            'description': 'Start date (ISO 8601 format)',
          },
          'endDate': {
            'type': 'string',
            'description': 'End date (ISO 8601 format)',
          },
        },
      },
    };
  }

  static Map<String, dynamic> getRouteProfitabilitySchema() {
    return {
      'name': getRouteProfitabilityToolName,
      'description': 'Get profitability ranking by route',
      'parameters': {
        'type': 'object',
        'properties': {
          'limit': {
            'type': 'number',
            'description': 'Number of top routes to return (default: 10)',
          },
        },
      },
    };
  }

  static Map<String, dynamic> getDriverPerformanceSchema() {
    return {
      'name': getDriverPerformanceToolName,
      'description': 'Get performance metrics for drivers',
      'parameters': {
        'type': 'object',
        'properties': {
          'driverId': {
            'type': 'string',
            'description': 'Specific driver ID (optional, returns all if not specified)',
          },
        },
      },
    };
  }

  static Future<ToolResult> executeGetTripProfit(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final tripId = arguments['tripId'] as String?;

    if (tripId == null || tripId.isEmpty) {
      return ToolResult.failure('', 'tripId parameter is required');
    }

    try {
      final trip = await database.managers.trips.filter((f) => f.id(tripId)).getSingleOrNull();
      if (trip == null) {
        return ToolResult.failure('', 'Trip not found: $tripId');
      }

      final freight = trip.freightAmount;
      final profit = freight;

      return ToolResult.success('', {
          'tripId': tripId,
          'route': '${trip.fromLocation} → ${trip.toLocation}',
          'freight': freight,
          'profit': profit,
          'profitMargin': 100.0,
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to calculate trip profit: $e');
    }
  }

  static Future<ToolResult> executeGetMonthlyProfitTrend(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final months = (arguments['months'] as num?)?.toInt() ?? 6;

    try {
      final now = DateTime.now();
      final monthlyData = <Map<String, dynamic>>[];

      for (int i = months - 1; i >= 0; i--) {
        final monthStart = DateTime(now.year, now.month - i, 1);
        final monthEnd = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);

        final trips = await database.managers.trips.get();
        final monthTrips = trips.where((t) =>
            t.startDate.isAfter(monthStart) && t.startDate.isBefore(monthEnd));

        double totalFreight = 0;
        double totalExpenses = 0;

        for (final trip in monthTrips) {
          totalFreight += trip.freightAmount;
        }

        monthlyData.add({
          'month': '${monthStart.year}-${monthStart.month.toString().padLeft(2, '0')}',
          'revenue': totalFreight,
          'profit': totalFreight,
          'tripCount': monthTrips.length,
        });
      }

      return ToolResult.success('', {
          'months': monthlyData,
          'totalProfit': monthlyData.fold<double>(
              0, (sum, m) => sum + (m['profit'] as double)),
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to get monthly profit trend: $e');
    }
  }

  static Future<ToolResult> executeGetCashflow(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    try {
      DateTime startDate;
      DateTime endDate;

      if (arguments['startDate'] != null) {
        startDate = DateTime.parse(arguments['startDate'] as String);
      } else {
        startDate = DateTime.now().subtract(const Duration(days: 30));
      }

      if (arguments['endDate'] != null) {
        endDate = DateTime.parse(arguments['endDate'] as String);
      } else {
        endDate = DateTime.now();
      }

      final trips = await database.managers.trips.get();
      final expenses = await database.managers.expenses.get();
      final payments = await database.managers.payments.get();

      final periodTrips = trips.where(
          (t) => t.startDate.isAfter(startDate) && t.startDate.isBefore(endDate));
      final periodExpenses = expenses
          .where((e) => e.createdAt.isAfter(startDate) && e.createdAt.isBefore(endDate));
      final periodPayments = payments
          .where((p) => p.date.isAfter(startDate) && p.date.isBefore(endDate));

      final totalRevenue =
          periodTrips.fold<double>(0, (sum, t) => sum + t.freightAmount);
      final totalExpenses =
          periodExpenses.fold<double>(0, (sum, e) => sum + e.amount);
      final totalPaymentsReceived =
          periodPayments.fold<double>(0, (sum, p) => sum + p.amount);

      return ToolResult.success('', {
          'period': {
            'start': startDate.toIso8601String(),
            'end': endDate.toIso8601String(),
          },
          'revenue': totalRevenue,
          'expenses': totalExpenses,
          'paymentsReceived': totalPaymentsReceived,
          'netCashflow': totalPaymentsReceived - totalExpenses,
          'profitMargin': totalRevenue > 0 ? ((totalRevenue - totalExpenses) / totalRevenue * 100) : 0,
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to get cashflow: $e');
    }
  }

  static Future<ToolResult> executeGetExpenseBreakdown(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    try {
      DateTime startDate;
      DateTime endDate;

      if (arguments['startDate'] != null) {
        startDate = DateTime.parse(arguments['startDate'] as String);
      } else {
        startDate = DateTime.now().subtract(const Duration(days: 30));
      }

      if (arguments['endDate'] != null) {
        endDate = DateTime.parse(arguments['endDate'] as String);
      } else {
        endDate = DateTime.now();
      }

      final expenses = await database.managers.expenses.get();
      final periodExpenses = expenses
          .where((e) => e.createdAt.isAfter(startDate) && e.createdAt.isBefore(endDate));

      final categoryTotals = <String, double>{};
      for (final expense in periodExpenses) {
        categoryTotals[expense.category] =
            (categoryTotals[expense.category] ?? 0) + expense.amount;
      }

      final breakdown = categoryTotals.entries
          .map((e) => {'category': e.key, 'amount': e.value})
          .toList()
        ..sort((a, b) => (b['amount'] as double).compareTo(a['amount'] as double));

      final total = categoryTotals.values.fold<double>(0, (sum, v) => sum + v);

      return ToolResult.success('', {
          'period': {
            'start': startDate.toIso8601String(),
            'end': endDate.toIso8601String(),
          },
          'breakdown': breakdown,
          'total': total,
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to get expense breakdown: $e');
    }
  }

  static Future<ToolResult> executeGetRouteProfitability(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final limit = (arguments['limit'] as num?)?.toInt() ?? 10;

    try {
      final trips = await database.managers.trips.get();
      final completedTrips = trips.where((t) => t.status == 'completed');

      final routeProfits = <String, Map<String, dynamic>>{};

      for (final trip in completedTrips) {
        final route = '${trip.fromLocation} → ${trip.toLocation}';
        final profit = trip.freightAmount;

        if (!routeProfits.containsKey(route)) {
          routeProfits[route] = {
            'route': route,
            'totalProfit': 0.0,
            'tripCount': 0,
            'avgProfit': 0.0,
          };
        }

        routeProfits[route]!['totalProfit'] =
            (routeProfits[route]!['totalProfit'] as double) + profit;
        routeProfits[route]!['tripCount'] =
            (routeProfits[route]!['tripCount'] as int) + 1;
      }

      for (final route in routeProfits.keys) {
        final total = routeProfits[route]!['totalProfit'] as double;
        final count = routeProfits[route]!['tripCount'] as int;
        routeProfits[route]!['avgProfit'] = count > 0 ? total / count : 0;
      }

      final sortedRoutes = routeProfits.values.toList()
        ..sort((a, b) =>
            (b['avgProfit'] as double).compareTo(a['avgProfit'] as double));

      final topRoutes = sortedRoutes.take(limit).toList();

      return ToolResult.success('', {
          'routes': topRoutes,
          'totalRoutes': routeProfits.length,
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to get route profitability: $e');
    }
  }

  static Future<ToolResult> executeGetDriverPerformance(
    Map<String, dynamic> arguments,
    AppDatabase database,
  ) async {
    final driverId = arguments['driverId'] as String?;

    try {
      final trips = await database.managers.trips.get();
      final drivers = await database.managers.drivers.get();

      final driverStats = <String, Map<String, dynamic>>{};

      for (final trip in trips.where((t) => t.status == 'completed')) {
        if (trip.driverId == null) continue;
        if (driverId != null && trip.driverId != driverId) continue;

        if (!driverStats.containsKey(trip.driverId)) {
          final driver = drivers.firstWhere((d) => d.id == trip.driverId,
              orElse: () => throw Exception('Driver not found'));
          
          driverStats[trip.driverId!] = {
            'driverId': trip.driverId,
            'driverName': driver.name,
            'tripCount': 0,
            'totalRevenue': 0.0,
            'totalExpenses': 0.0,
            'totalProfit': 0.0,
            'avgProfit': 0.0,
          };
        }

        final profit = trip.freightAmount;
        driverStats[trip.driverId]!['tripCount'] =
            (driverStats[trip.driverId]!['tripCount'] as int) + 1;
        driverStats[trip.driverId]!['totalRevenue'] =
            (driverStats[trip.driverId]!['totalRevenue'] as double) +
                trip.freightAmount;
        driverStats[trip.driverId]!['totalProfit'] =
            (driverStats[trip.driverId]!['totalProfit'] as double) + profit;
      }

      for (final stats in driverStats.values) {
        final total = stats['totalProfit'] as double;
        final count = stats['tripCount'] as int;
        stats['avgProfit'] = count > 0 ? total / count : 0;
      }

      final sortedDrivers = driverStats.values.toList()
        ..sort((a, b) =>
            (b['totalProfit'] as double).compareTo(a['totalProfit'] as double));

      return ToolResult.success('', {
          'drivers': sortedDrivers,
          'totalDrivers': driverStats.length,
        },
      );
    } catch (e) {
      return ToolResult.failure('', 'Failed to get driver performance: $e');
    }
  }
}
