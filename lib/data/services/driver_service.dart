import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/driver_repository.dart';

class DriverService {
  final DriverRepository _repository;
  final Uuid _uuid = const Uuid();

  DriverService(this._repository);

  // Get all drivers
  Future<List<Driver>> getAllDrivers() => _repository.getAllDrivers();

  // Get driver by ID
  Future<Driver?> getDriverById(String id) => _repository.getDriverById(id);

  // Create new driver
  Future<void> createDriver({
    required String name,
    required String phone,
    required String licenseNumber,
    required String licenseType,
    DateTime? licenseExpiry,
    String? address,
    String? emergencyContact,
    String? notes,
  }) async {
    final driver = DriversCompanion.insert(
      id: _uuid.v4(),
      name: name,
      phone: phone,
      licenseNumber: licenseNumber,
      licenseType: licenseType,
      licenseExpiry: Value(licenseExpiry),
      address: Value(address),
      emergencyContact: Value(emergencyContact),
      status: 'ACTIVE',
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addDriver(driver);
  }

  // Update driver
  Future<void> updateDriver({
    required String id,
    String? name,
    String? phone,
    String? licenseNumber,
    String? licenseType,
    DateTime? licenseExpiry,
    String? address,
    String? emergencyContact,
    String? status,
    String? notes,
  }) async {
    final existingDriver = await _repository.getDriverById(id);
    if (existingDriver == null) {
      throw Exception('Driver not found');
    }

    final updatedDriver = existingDriver.copyWith(
      name: name ?? existingDriver.name,
      phone: phone ?? existingDriver.phone,
      licenseNumber: licenseNumber ?? existingDriver.licenseNumber,
      licenseType: licenseType ?? existingDriver.licenseType,
      licenseExpiry: Value(licenseExpiry ?? existingDriver.licenseExpiry),
      address: Value(address ?? existingDriver.address),
      emergencyContact: Value(emergencyContact ?? existingDriver.emergencyContact),
      status: status ?? existingDriver.status,
      notes: Value(notes ?? existingDriver.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updateDriver(updatedDriver);
  }

  // Delete driver
  Future<void> deleteDriver(String id) async {
    final driver = await _repository.getDriverById(id);
    if (driver == null) {
      throw Exception('Driver not found');
    }

    // Check if driver is assigned to any vehicle
    // TODO: Add vehicle assignment check when vehicle-driver relationship is implemented

    await _repository.deleteDriver(id);
  }

  // Get available drivers
  Future<List<Driver>> getAvailableDrivers() => _repository.getAvailableDrivers();

  // Search drivers
  Future<List<Driver>> searchDrivers(String query) => _repository.searchDrivers(query);

  // Get driver statistics
  Future<Map<String, int>> getDriverStatistics() async {
    final activeCount = await _repository.getDriverCountByStatus('ACTIVE');
    final inactiveCount = await _repository.getDriverCountByStatus('INACTIVE');
    final onLeaveCount = await _repository.getDriverCountByStatus('ON_LEAVE');

    return {
      'ACTIVE': activeCount,
      'INACTIVE': inactiveCount,
      'ON_LEAVE': onLeaveCount,
      'TOTAL': activeCount + inactiveCount + onLeaveCount,
    };
  }

  // Update driver status
  Future<void> updateDriverStatus(String driverId, String status) async {
    final driver = await _repository.getDriverById(driverId);
    if (driver == null) {
      throw Exception('Driver not found');
    }

    await updateDriver(
      id: driverId,
      status: status,
    );
  }

  // Check if phone number is unique
  Future<bool> isPhoneUnique(String phone, {String? excludeId}) async {
    return await _repository.isPhoneUnique(phone, excludeId: excludeId);
  }

  // Check if license number is unique
  Future<bool> isLicenseNumberUnique(String licenseNumber, {String? excludeId}) async {
    return await _repository.isLicenseNumberUnique(licenseNumber, excludeId: excludeId);
  }

  // Get drivers by license type
  Future<List<Driver>> getDriversByLicenseType(String licenseType) =>
      _repository.getDriversByLicenseType(licenseType);

  // Get drivers with expiring licenses
  Future<List<Driver>> getDriversWithExpiringLicenses() =>
      _repository.getDriversWithExpiringLicenses();

  // Validate license expiry
  bool isLicenseExpiring(DateTime? expiryDate) {
    if (expiryDate == null) return false;
    final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
    return expiryDate.isBefore(thirtyDaysFromNow);
  }

  // Get license status
  String getLicenseStatus(DateTime? expiryDate) {
    if (expiryDate == null) return 'NOT_SET';
    
    final now = DateTime.now();
    final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
    
    if (expiryDate.isBefore(now)) {
      return 'EXPIRED';
    } else if (expiryDate.isBefore(thirtyDaysFromNow)) {
      return 'EXPIRING_SOON';
    } else {
      return 'VALID';
    }
  }

  // Get driver performance metrics
  Future<Map<String, dynamic>> getDriverPerformance(String driverId) async {
    // TODO: Implement when trips module is ready
    // This will include metrics like:
    // - Number of trips completed
    // - Average trip duration
    // - Fuel efficiency
    // - On-time performance
    // - Safety incidents
    
    return {
      'totalTrips': 0,
      'avgTripDuration': 0.0,
      'fuelEfficiency': 0.0,
      'onTimePerformance': 0.0,
      'safetyIncidents': 0,
    };
  }
}
