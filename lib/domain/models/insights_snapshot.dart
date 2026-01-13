import '../services/analytics_service.dart';
import '../../data/database.dart';

class InsightsSnapshot {
  final List<CashFlowData> cashFlow;
  final List<ProfitTrendData> profitTrend;
  final List<RouteProfitData> routeProfitability;
  final Map<String, double> expenseBreakdown;
  final Map<String, double> vehicleUtilization;
  final List<DriverPerformanceData> driverPerformance;
  final List<Trip> recentTrips;

  const InsightsSnapshot({
    required this.cashFlow,
    required this.profitTrend,
    required this.routeProfitability,
    required this.expenseBreakdown,
    required this.vehicleUtilization,
    required this.driverPerformance,
    required this.recentTrips,
  });
}
