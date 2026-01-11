import 'package:drift/drift.dart';
import '../database.dart';

part 'vehicle_repository.g.dart';

@DriftAccessor(tables: [Vehicles])
class VehicleRepository extends DatabaseAccessor<AppDatabase> with _$VehicleRepositoryMixin {
  VehicleRepository(AppDatabase db) : super(db);

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() => select(vehicles).get();

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) =>
      (select(vehicles)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get vehicles by status
  Future<List<Vehicle>> getVehiclesByStatus(String status) =>
      (select(vehicles)..where((tbl) => tbl.status.equals(status))).get();

  // Add new vehicle
  Future<void> addVehicle(VehiclesCompanion vehicle) => into(vehicles).insert(vehicle);

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) => update(vehicles).replace(vehicle);

  // Delete vehicle
  Future<void> deleteVehicle(String id) =>
      (delete(vehicles)..where((tbl) => tbl.id.equals(id))).go();

  // Get available vehicles (IDLE status)
  Future<List<Vehicle>> getAvailableVehicles() =>
      (select(vehicles)..where((tbl) => tbl.status.equals('IDLE'))).get();

  // Search vehicles by truck number
  Future<List<Vehicle>> searchVehicles(String query) =>
      (select(vehicles)..where((tbl) => tbl.truckNumber.contains(query))).get();

  // Get vehicle count by status
  Future<int> getVehicleCountByStatus(String status) async {
    final vehicleList = await (select(vehicles)..where((tbl) => tbl.status.equals(status))).get();
    return vehicleList.length;
  }

  // Get vehicle statistics
  Future<Map<String, int>> getVehicleStatistics() async {
    final idleCount = await getVehicleCountByStatus('IDLE');
    final onTripCount = await getVehicleCountByStatus('ON_TRIP');
    final maintenanceCount = await getVehicleCountByStatus('MAINTENANCE');

    return {
      'IDLE': idleCount,
      'ON_TRIP': onTripCount,
      'MAINTENANCE': maintenanceCount,
      'TOTAL': idleCount + onTripCount + maintenanceCount,
    };
  }
}
