import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/services/trip_service.dart';
import 'database_provider.dart';

// Trip repository provider
final tripRepositoryProvider = Provider<TripRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return TripRepository(database);
});

// Trip service provider
final tripServiceProvider = Provider<TripService>((ref) {
  final repository = ref.watch(tripRepositoryProvider);
  return TripService(repository);
});

// Trip list provider
final tripListProvider = FutureProvider<List<Trip>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return service.getAllTrips();
});

// Active trips provider
final activeTripsProvider = FutureProvider<List<Trip>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return service.getActiveTrips();
});

// Completed trips provider
final completedTripsProvider = FutureProvider<List<Trip>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return service.getCompletedTrips();
});

// Trip statistics provider
final tripStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return service.getTripStatistics();
});

// Recent trips provider
final recentTripsProvider = FutureProvider<List<Trip>>((ref) {
  final service = ref.watch(tripServiceProvider);
  return service.getRecentTrips();
});

// Trips by vehicle provider
final tripsByVehicleProvider = FutureProvider.family<List<Trip>, String>((ref, vehicleId) {
  final service = ref.watch(tripServiceProvider);
  return service.getTripsByVehicle(vehicleId);
});

// Trips by driver provider
final tripsByDriverProvider = FutureProvider.family<List<Trip>, String>((ref, driverId) {
  final service = ref.watch(tripServiceProvider);
  return service.getTripsByDriver(driverId);
});

// Trips by party provider
final tripsByPartyProvider = FutureProvider.family<List<Trip>, String>((ref, partyId) {
  final service = ref.watch(tripServiceProvider);
  return service.getTripsByParty(partyId);
});
