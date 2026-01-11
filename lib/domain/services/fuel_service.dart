import 'package:drift/drift.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Fuel Service
/// Handles fuel efficiency calculations and mileage tracking
class FuelService {
  final AppDatabase _database;

  FuelService(this._database);

  /// Calculate mileage (km per liter) for a fuel entry
  Future<double?> calculateMileage(String vehicleId, FuelEntry currentEntry) async {
    // Get previous fuel entry for this vehicle
    final previousEntries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..where((tbl) => tbl.entryDate.isSmallerThanValue(currentEntry.entryDate))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.entryDate)])
          ..limit(1))
        .get();

    if (previousEntries.isEmpty) {
      return null; // Need at least 2 entries to calculate mileage
    }

    final previousEntry = previousEntries.first;
    
    // Calculate distance traveled
    final distanceTraveled = currentEntry.odometerReading - previousEntry.odometerReading;
    
    if (distanceTraveled <= 0) {
      return null; // Invalid odometer reading
    }

    // Calculate mileage (km/liter)
    final mileage = distanceTraveled / currentEntry.quantityLiters;
    
    return mileage;
  }

  /// Calculate cost per km for a fuel entry
  Future<double?> calculateCostPerKm(String vehicleId, FuelEntry currentEntry) async {
    final mileage = await calculateMileage(vehicleId, currentEntry);
    
    if (mileage == null) {
      return null;
    }

    // Cost per km = (Cost per liter) / (km per liter)
    final costPerKm = currentEntry.costPerLiter / mileage;
    
    return costPerKm;
  }

  /// Get average mileage for a vehicle
  Future<double> getAverageMileage(String vehicleId) async {
    final entries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.entryDate)]))
        .get();

    if (entries.length < 2) {
      return 0.0;
    }

    double totalMileage = 0;
    int count = 0;

    for (int i = 0; i < entries.length - 1; i++) {
      final current = entries[i];
      final previous = entries[i + 1];
      
      final distance = current.odometerReading - previous.odometerReading;
      
      if (distance > 0) {
        final mileage = distance / current.quantityLiters;
        totalMileage += mileage;
        count++;
      }
    }

    return count > 0 ? totalMileage / count : 0.0;
  }

  /// Get average cost per km for a vehicle
  Future<double> getAverageCostPerKm(String vehicleId) async {
    final entries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.entryDate)]))
        .get();

    if (entries.length < 2) {
      return 0.0;
    }

    double totalCostPerKm = 0;
    int count = 0;

    for (int i = 0; i < entries.length - 1; i++) {
      final current = entries[i];
      final previous = entries[i + 1];
      
      final distance = current.odometerReading - previous.odometerReading;
      
      if (distance > 0) {
        final mileage = distance / current.quantityLiters;
        final costPerKm = current.costPerLiter / mileage;
        totalCostPerKm += costPerKm;
        count++;
      }
    }

    return count > 0 ? totalCostPerKm / count : 0.0;
  }

  /// Get fuel efficiency trend for a vehicle (last 10 entries)
  Future<List<FuelEfficiencyData>> getFuelEfficiencyTrend(String vehicleId) async {
    final entries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.entryDate)])
          ..limit(10))
        .get();

    if (entries.length < 2) {
      return [];
    }

    final trend = <FuelEfficiencyData>[];

    for (int i = 0; i < entries.length - 1; i++) {
      final current = entries[i];
      final previous = entries[i + 1];
      
      final distance = current.odometerReading - previous.odometerReading;
      
      if (distance > 0) {
        final mileage = distance / current.quantityLiters;
        final costPerKm = current.costPerLiter / mileage;
        
        trend.add(FuelEfficiencyData(
          date: current.entryDate,
          mileage: mileage,
          costPerKm: costPerKm,
          distance: distance,
        ));
      }
    }

    return trend.reversed.toList();
  }

  /// Get total fuel cost for a vehicle in a date range
  Future<double> getTotalFuelCost(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..where((tbl) => tbl.entryDate.isBiggerOrEqualValue(startDate))
          ..where((tbl) => tbl.entryDate.isSmallerOrEqualValue(endDate)))
        .get();

    double totalCost = 0;
    for (final entry in entries) {
      totalCost += entry.totalCost;
    }

    return totalCost;
  }

  /// Get total distance traveled for a vehicle in a date range
  Future<double> getTotalDistance(
    String vehicleId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final entries = await (_database.select(_database.fuelEntries)
          ..where((tbl) => tbl.vehicleId.equals(vehicleId))
          ..where((tbl) => tbl.entryDate.isBiggerOrEqualValue(startDate))
          ..where((tbl) => tbl.entryDate.isSmallerOrEqualValue(endDate))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.entryDate)]))
        .get();

    if (entries.length < 2) {
      return 0.0;
    }

    final firstEntry = entries.first;
    final lastEntry = entries.last;

    return lastEntry.odometerReading - firstEntry.odometerReading;
  }
}

/// Fuel Efficiency Data Model
class FuelEfficiencyData {
  final DateTime date;
  final double mileage;
  final double costPerKm;
  final double distance;

  FuelEfficiencyData({
    required this.date,
    required this.mileage,
    required this.costPerKm,
    required this.distance,
  });
}
