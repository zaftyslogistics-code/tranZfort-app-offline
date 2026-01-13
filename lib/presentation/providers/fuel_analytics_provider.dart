import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;

import '../../data/database.dart';
import 'database_provider.dart';

class FuelAnalyticsSummary {
  final double totalLiters;
  final double totalCost;
  final double avgMileage;
  final double totalDistance;
  final double avgCostPerKm;

  const FuelAnalyticsSummary({
    required this.totalLiters,
    required this.totalCost,
    required this.avgMileage,
    required this.totalDistance,
    required this.avgCostPerKm,
  });
}

final fuelAnalyticsSummaryProvider = FutureProvider<FuelAnalyticsSummary>((ref) async {
  final database = ref.watch(databaseProvider);
  
  final fuelEntries = await database.select(database.fuelEntries).get();
  
  if (fuelEntries.isEmpty) {
    return const FuelAnalyticsSummary(
      totalLiters: 0,
      totalCost: 0,
      avgMileage: 0,
      totalDistance: 0,
      avgCostPerKm: 0,
    );
  }

  final totalLiters = fuelEntries.fold<double>(0, (sum, e) => sum + e.quantityLiters);
  final totalCost = fuelEntries.fold<double>(0, (sum, e) => sum + e.totalCost);
  
  fuelEntries.sort((a, b) => a.odometerReading.compareTo(b.odometerReading));
  final totalDistance = fuelEntries.isNotEmpty && fuelEntries.length > 1
      ? fuelEntries.last.odometerReading - fuelEntries.first.odometerReading
      : 0.0;
  
  final avgMileage = totalLiters > 0 ? totalDistance / totalLiters : 0.0;
  final avgCostPerKm = totalDistance > 0 ? totalCost / totalDistance : 0.0;

  return FuelAnalyticsSummary(
    totalLiters: totalLiters,
    totalCost: totalCost,
    avgMileage: avgMileage,
    totalDistance: totalDistance,
    avgCostPerKm: avgCostPerKm,
  );
});

final maintenanceSummaryProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final database = ref.watch(databaseProvider);
  
  final schedules = await database.select(database.maintenanceSchedules).get();
  
  final totalServices = schedules.length;
  final completedServices = schedules.where((s) => s.status == 'COMPLETED').length;
  
  return {
    'totalServices': totalServices,
    'completedServices': completedServices,
    'pendingServices': schedules.where((s) => s.status == 'PENDING').length,
  };
});
