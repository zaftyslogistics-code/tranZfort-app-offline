import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/driver_repository.dart';
import '../../data/services/driver_service.dart';
import 'database_provider.dart';

// Driver repository provider
final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DriverRepository(database);
});

// Driver service provider
final driverServiceProvider = Provider<DriverService>((ref) {
  final repository = ref.watch(driverRepositoryProvider);
  return DriverService(repository);
});

// Driver list provider
final driverListProvider = FutureProvider<List<Driver>>((ref) {
  final service = ref.watch(driverServiceProvider);
  return service.getAllDrivers();
});

// Driver statistics provider
final driverStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(driverServiceProvider);
  return service.getDriverStatistics();
});

// Available drivers provider
final availableDriversProvider = FutureProvider<List<Driver>>((ref) {
  final service = ref.watch(driverServiceProvider);
  return service.getAvailableDrivers();
});

// Drivers with expiring licenses provider
final expiringLicensesProvider = FutureProvider<List<Driver>>((ref) {
  final service = ref.watch(driverServiceProvider);
  return service.getDriversWithExpiringLicenses();
});
