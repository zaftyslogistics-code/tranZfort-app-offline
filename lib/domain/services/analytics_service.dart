import 'package:drift/drift.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Analytics Service
/// Provides business intelligence and analytics calculations
class AnalyticsService {
  final AppDatabase _database;

  AnalyticsService(this._database);

  /// Calculate profit/loss for a trip
  Future<double> calculateTripProfit(String tripId) async {
    final trip = await (_database.select(_database.trips)
          ..where((tbl) => tbl.id.equals(tripId)))
        .getSingle();

    final expenses = await (_database.select(_database.expenses)
          ..where((tbl) => tbl.tripId.equals(tripId)))
        .get();

    final totalExpenses = expenses.fold<double>(
      0.0,
      (sum, expense) => sum + expense.amount,
    );

    return trip.freightAmount - totalExpenses;
  }

  /// Get profit trend for last N months
  Future<List<ProfitTrendData>> getProfitTrend(int months) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - months, 1);

    final trips = await (_database.select(_database.trips)
          ..where((tbl) => tbl.startDate.isBiggerOrEqualValue(startDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.startDate)]))
        .get();

    final monthlyData = <String, double>{};

    for (final trip in trips) {
      final profit = await calculateTripProfit(trip.id);
      final monthKey = '${trip.startDate.year}-${trip.startDate.month.toString().padLeft(2, '0')}';
      monthlyData[monthKey] = (monthlyData[monthKey] ?? 0) + profit;
    }

    return monthlyData.entries
        .map((e) => ProfitTrendData(month: e.key, profit: e.value))
        .toList();
  }

  /// Calculate vehicle utilization percentage
  Future<Map<String, double>> getVehicleUtilization() async {
    final vehicles = await _database.select(_database.vehicles).get();
    final utilization = <String, double>{};

    final now = DateTime.now();
    final thirtyDaysAgo = now.subtract(const Duration(days: 30));

    for (final vehicle in vehicles) {
      final trips = await (_database.select(_database.trips)
            ..where((tbl) => tbl.vehicleId.equals(vehicle.id))
            ..where((tbl) => tbl.startDate.isBiggerOrEqualValue(thirtyDaysAgo)))
          .get();

      final activeDays = trips.length;
      final utilizationPercent = (activeDays / 30) * 100;
      utilization[vehicle.truckNumber] = utilizationPercent;
    }

    return utilization;
  }

  /// Get route profitability
  Future<List<RouteProfitData>> getRouteProfitability() async {
    final trips = await _database.select(_database.trips).get();
    final routeData = <String, RouteProfitData>{};

    for (final trip in trips) {
      final profit = await calculateTripProfit(trip.id);
      final routeKey = '${trip.fromLocation}-${trip.toLocation}';

      if (routeData.containsKey(routeKey)) {
        final existing = routeData[routeKey]!;
        routeData[routeKey] = RouteProfitData(
          route: routeKey,
          totalProfit: existing.totalProfit + profit,
          tripCount: existing.tripCount + 1,
        );
      } else {
        routeData[routeKey] = RouteProfitData(
          route: routeKey,
          totalProfit: profit,
          tripCount: 1,
        );
      }
    }

    return routeData.values.toList()
      ..sort((a, b) => b.totalProfit.compareTo(a.totalProfit));
  }

  /// Get expense breakdown by category
  Future<Map<String, double>> getExpenseBreakdown() async {
    final expenses = await _database.select(_database.expenses).get();
    final breakdown = <String, double>{};

    for (final expense in expenses) {
      breakdown[expense.category] = (breakdown[expense.category] ?? 0) + expense.amount;
    }

    return breakdown;
  }

  /// Get cash flow data (income vs expenses)
  Future<List<CashFlowData>> getCashFlow(int months) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - months, 1);

    final trips = await (_database.select(_database.trips)
          ..where((tbl) => tbl.startDate.isBiggerOrEqualValue(startDate)))
        .get();

    final expenses = await (_database.select(_database.expenses)
          ..where((tbl) => tbl.createdAt.isBiggerOrEqualValue(startDate)))
        .get();

    final monthlyData = <String, CashFlowData>{};

    for (final trip in trips) {
      final monthKey = '${trip.startDate.year}-${trip.startDate.month.toString().padLeft(2, '0')}';
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = CashFlowData(month: monthKey, income: 0, expenses: 0);
      }
      monthlyData[monthKey] = CashFlowData(
        month: monthKey,
        income: monthlyData[monthKey]!.income + trip.freightAmount,
        expenses: monthlyData[monthKey]!.expenses,
      );
    }

    for (final expense in expenses) {
      final monthKey = '${expense.createdAt.year}-${expense.createdAt.month.toString().padLeft(2, '0')}';
      if (!monthlyData.containsKey(monthKey)) {
        monthlyData[monthKey] = CashFlowData(month: monthKey, income: 0, expenses: 0);
      }
      monthlyData[monthKey] = CashFlowData(
        month: monthKey,
        income: monthlyData[monthKey]!.income,
        expenses: monthlyData[monthKey]!.expenses + expense.amount,
      );
    }

    return monthlyData.values.toList()
      ..sort((a, b) => a.month.compareTo(b.month));
  }

  /// Get driver performance metrics
  Future<List<DriverPerformanceData>> getDriverPerformance() async {
    final drivers = await _database.select(_database.drivers).get();
    final performance = <DriverPerformanceData>[];

    for (final driver in drivers) {
      final trips = await (_database.select(_database.trips)
            ..where((tbl) => tbl.driverId.equals(driver.id)))
          .get();

      double totalProfit = 0;
      for (final trip in trips) {
        totalProfit += await calculateTripProfit(trip.id);
      }

      performance.add(DriverPerformanceData(
        driverName: driver.name,
        tripCount: trips.length,
        totalProfit: totalProfit,
        averageProfit: trips.isNotEmpty ? totalProfit / trips.length : 0,
      ));
    }

    return performance..sort((a, b) => b.totalProfit.compareTo(a.totalProfit));
  }
}

/// Profit Trend Data Model
class ProfitTrendData {
  final String month;
  final double profit;

  ProfitTrendData({required this.month, required this.profit});
}

/// Route Profit Data Model
class RouteProfitData {
  final String route;
  final double totalProfit;
  final int tripCount;

  RouteProfitData({
    required this.route,
    required this.totalProfit,
    required this.tripCount,
  });

  double get averageProfit => tripCount > 0 ? totalProfit / tripCount : 0;
}

/// Cash Flow Data Model
class CashFlowData {
  final String month;
  final double income;
  final double expenses;

  CashFlowData({
    required this.month,
    required this.income,
    required this.expenses,
  });

  double get netCashFlow => income - expenses;
}

/// Driver Performance Data Model
class DriverPerformanceData {
  final String driverName;
  final int tripCount;
  final double totalProfit;
  final double averageProfit;

  DriverPerformanceData({
    required this.driverName,
    required this.tripCount,
    required this.totalProfit,
    required this.averageProfit,
  });
}
