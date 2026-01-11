import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/vehicle_repository.dart';

class VehicleService {
  final VehicleRepository _repository;
  final Uuid _uuid = const Uuid();

  VehicleService(this._repository);

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() => _repository.getAllVehicles();

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) => _repository.getVehicleById(id);

  // Create new vehicle
  Future<void> createVehicle({
    required String truckNumber,
    required String truckType,
    required double capacity,
    required String fuelType,
    required String registrationNumber,
    DateTime? insuranceExpiry,
    DateTime? fitnessExpiry,
    String? assignedDriverId,
    String? notes,
  }) async {
    final isUnique = await isTruckNumberUnique(truckNumber);
    if (!isUnique) {
      throw Exception('Truck number must be unique');
    }

    final vehicle = VehiclesCompanion.insert(
      id: _uuid.v4(),
      truckNumber: truckNumber,
      truckType: truckType,
      capacity: capacity,
      fuelType: fuelType,
      registrationNumber: registrationNumber,
      insuranceExpiry: Value(insuranceExpiry),
      fitnessExpiry: Value(fitnessExpiry),
      assignedDriverId: Value(assignedDriverId),
      status: 'IDLE',
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addVehicle(vehicle);
  }

  // Update vehicle
  Future<void> updateVehicle({
    required String id,
    String? truckNumber,
    String? truckType,
    double? capacity,
    String? fuelType,
    String? registrationNumber,
    DateTime? insuranceExpiry,
    DateTime? fitnessExpiry,
    String? assignedDriverId,
    String? status,
    String? currentLocation,
    double? totalKm,
    DateTime? lastServiceDate,
    String? notes,
  }) async {
    final existingVehicle = await _repository.getVehicleById(id);
    if (existingVehicle == null) {
      throw Exception('Vehicle not found');
    }

    final updatedVehicle = existingVehicle.copyWith(
      truckNumber: truckNumber ?? existingVehicle.truckNumber,
      truckType: truckType ?? existingVehicle.truckType,
      capacity: capacity ?? existingVehicle.capacity,
      fuelType: fuelType ?? existingVehicle.fuelType,
      registrationNumber: registrationNumber ?? existingVehicle.registrationNumber,
      insuranceExpiry: Value(insuranceExpiry ?? existingVehicle.insuranceExpiry),
      fitnessExpiry: Value(fitnessExpiry ?? existingVehicle.fitnessExpiry),
      assignedDriverId: Value(assignedDriverId ?? existingVehicle.assignedDriverId),
      status: status ?? existingVehicle.status,
      currentLocation: Value(currentLocation ?? existingVehicle.currentLocation),
      totalKm: Value(totalKm ?? existingVehicle.totalKm),
      lastServiceDate: Value(lastServiceDate ?? existingVehicle.lastServiceDate),
      notes: Value(notes ?? existingVehicle.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updateVehicle(updatedVehicle);
  }

  // Delete vehicle
  Future<void> deleteVehicle(String id) async {
    final vehicle = await _repository.getVehicleById(id);
    if (vehicle == null) {
      throw Exception('Vehicle not found');
    }

    if (vehicle.status == 'ON_TRIP') {
      throw Exception('Cannot delete vehicle that is currently on trip');
    }

    await _repository.deleteVehicle(id);
  }

  // Get available vehicles
  Future<List<Vehicle>> getAvailableVehicles() => _repository.getAvailableVehicles();

  // Search vehicles
  Future<List<Vehicle>> searchVehicles(String query) => _repository.searchVehicles(query);

  // Get vehicle statistics
  Future<Map<String, int>> getVehicleStatistics() async {
    final idleCount = await _repository.getVehicleCountByStatus('IDLE');
    final onTripCount = await _repository.getVehicleCountByStatus('ON_TRIP');
    final maintenanceCount = await _repository.getVehicleCountByStatus('MAINTENANCE');

    return {
      'IDLE': idleCount,
      'ON_TRIP': onTripCount,
      'MAINTENANCE': maintenanceCount,
      'TOTAL': idleCount + onTripCount + maintenanceCount,
    };
  }

  // Assign driver to vehicle
  Future<void> assignDriverToVehicle(String vehicleId, String driverId) async {
    final vehicle = await _repository.getVehicleById(vehicleId);
    if (vehicle == null) {
      throw Exception('Vehicle not found');
    }

    if (vehicle.status == 'ON_TRIP') {
      throw Exception('Cannot assign driver to vehicle that is currently on trip');
    }

    await updateVehicle(
      id: vehicleId,
      assignedDriverId: driverId,
    );
  }

  // Update vehicle status
  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    final vehicle = await _repository.getVehicleById(vehicleId);
    if (vehicle == null) {
      throw Exception('Vehicle not found');
    }

    await updateVehicle(
      id: vehicleId,
      status: status,
    );
  }

  // Check if truck number is unique
  Future<bool> isTruckNumberUnique(String truckNumber, {String? excludeId}) async {
    final vehicles = await _repository.getAllVehicles();
    return vehicles.every((vehicle) => 
      vehicle.truckNumber != truckNumber || 
      (excludeId != null && vehicle.id == excludeId)
    );
  }

  // Get vehicles by driver
  Future<List<Vehicle>> getVehiclesByDriver(String driverId) async {
    final vehicles = await _repository.getAllVehicles();
    return vehicles.where((vehicle) => vehicle.assignedDriverId == driverId).toList();
  }
}
