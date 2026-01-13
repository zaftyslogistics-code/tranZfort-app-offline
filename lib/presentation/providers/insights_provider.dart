import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/insights_snapshot.dart';
import 'analytics_service_provider.dart';
import 'suggestion_provider.dart';

final insightsProvider = FutureProvider<InsightsSnapshot>((ref) async {
  final analytics = ref.watch(analyticsServiceProvider);
  final suggestions = ref.watch(suggestionServiceProvider);

  final cashFlow = await analytics.getCashFlow(6);
  final profitTrend = await analytics.getProfitTrend(6);
  final routeProfitability = await analytics.getRouteProfitability();
  final expenseBreakdown = await analytics.getExpenseBreakdown();
  final vehicleUtilization = await analytics.getVehicleUtilization();
  final driverPerformance = await analytics.getDriverPerformance();
  final recentTrips = await suggestions.getRecentTrips(limit: 5);

  return InsightsSnapshot(
    cashFlow: cashFlow,
    profitTrend: profitTrend,
    routeProfitability: routeProfitability,
    expenseBreakdown: expenseBreakdown,
    vehicleUtilization: vehicleUtilization,
    driverPerformance: driverPerformance,
    recentTrips: recentTrips,
  );
});
