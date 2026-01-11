import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/vehicle_repository.dart';
import '../../data/services/vehicle_service.dart';
import 'database_provider.dart';

// Vehicle repository provider
final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return VehicleRepository(database);
});

// Vehicle service provider
final vehicleServiceProvider = Provider<VehicleService>((ref) {
  final repository = ref.watch(vehicleRepositoryProvider);
  return VehicleService(repository);
});

// Vehicle list provider
final vehicleListProvider = FutureProvider<List<Vehicle>>((ref) {
  final service = ref.watch(vehicleServiceProvider);
  return service.getAllVehicles();
});

// Vehicle statistics provider
final vehicleStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(vehicleServiceProvider);
  return service.getVehicleStatistics();
});

// Available vehicles provider
final availableVehiclesProvider = FutureProvider<List<Vehicle>>((ref) {
  final service = ref.watch(vehicleServiceProvider);
  return service.getAvailableVehicles();
});
