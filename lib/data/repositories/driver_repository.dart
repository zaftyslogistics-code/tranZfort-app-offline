import 'package:drift/drift.dart';
import '../database.dart';

part 'driver_repository.g.dart';

@DriftAccessor(tables: [Drivers])
class DriverRepository extends DatabaseAccessor<AppDatabase> with _$DriverRepositoryMixin {
  DriverRepository(AppDatabase db) : super(db);

  // Get all drivers
  Future<List<Driver>> getAllDrivers() => select(drivers).get();

  // Get driver by ID
  Future<Driver?> getDriverById(String id) =>
      (select(drivers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get drivers by status
  Future<List<Driver>> getDriversByStatus(String status) =>
      (select(drivers)..where((tbl) => tbl.status.equals(status))).get();

  // Add new driver
  Future<void> addDriver(DriversCompanion driver) => into(drivers).insert(driver);

  // Update driver
  Future<void> updateDriver(Driver driver) => update(drivers).replace(driver);

  // Delete driver
  Future<void> deleteDriver(String id) =>
      (delete(drivers)..where((tbl) => tbl.id.equals(id))).go();

  // Get available drivers (ACTIVE status)
  Future<List<Driver>> getAvailableDrivers() =>
      (select(drivers)..where((tbl) => tbl.status.equals('ACTIVE'))).get();

  // Search drivers by name or phone
  Future<List<Driver>> searchDrivers(String query) => (select(drivers)
        ..where((tbl) => tbl.name.contains(query) | tbl.phone.contains(query)))
      .get();

  // Get driver count by status
  Future<int> getDriverCountByStatus(String status) async {
    final driverList = await (select(drivers)..where((tbl) => tbl.status.equals(status))).get();
    return driverList.length;
  }

  // Get driver statistics
  Future<Map<String, int>> getDriverStatistics() async {
    final activeCount = await getDriverCountByStatus('ACTIVE');
    final inactiveCount = await getDriverCountByStatus('INACTIVE');
    final onLeaveCount = await getDriverCountByStatus('ON_LEAVE');

    return {
      'ACTIVE': activeCount,
      'INACTIVE': inactiveCount,
      'ON_LEAVE': onLeaveCount,
      'TOTAL': activeCount + inactiveCount + onLeaveCount,
    };
  }

  // Get drivers by license type
  Future<List<Driver>> getDriversByLicenseType(String licenseType) =>
      (select(drivers)..where((tbl) => tbl.licenseType.equals(licenseType))).get();

  // Get drivers with expiring licenses (within 30 days)
  Future<List<Driver>> getDriversWithExpiringLicenses() async {
    final thirtyDaysFromNow = DateTime.now().add(const Duration(days: 30));
    final allDrivers = await getAllDrivers();
    return allDrivers.where((driver) {
      final expiry = driver.licenseExpiry;
      return expiry != null && expiry.isBefore(thirtyDaysFromNow);
    }).toList();
  }

  // Update driver status
  Future<void> updateDriverStatus(String id, String status) async {
    final driver = await getDriverById(id);
    if (driver != null) {
      await updateDriver(driver.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Check if phone number is unique
  Future<bool> isPhoneUnique(String phone, {String? excludeId}) async {
    final drivers = await getAllDrivers();
    return drivers.every((driver) =>
        driver.phone != phone || (excludeId != null && driver.id == excludeId));
  }

  // Check if license number is unique
  Future<bool> isLicenseNumberUnique(String licenseNumber, {String? excludeId}) async {
    final drivers = await getAllDrivers();
    return drivers.every((driver) =>
        driver.licenseNumber != licenseNumber || (excludeId != null && driver.id == excludeId));
  }
}
