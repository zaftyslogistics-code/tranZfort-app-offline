import 'package:drift/drift.dart';
import '../database.dart';

part 'trip_repository.g.dart';

@DriftAccessor(tables: [Trips, Expenses, Payments])
class TripRepository extends DatabaseAccessor<AppDatabase> with _$TripRepositoryMixin {
  TripRepository(AppDatabase db) : super(db);

  // Get all trips
  Future<List<Trip>> getAllTrips() => select(trips).get();

  // Get trip by ID
  Future<Trip?> getTripById(String id) =>
      (select(trips)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get trips by status
  Future<List<Trip>> getTripsByStatus(String status) =>
      (select(trips)..where((tbl) => tbl.status.equals(status))).get();

  // Add new trip
  Future<void> addTrip(TripsCompanion trip) => into(trips).insert(trip);

  // Update trip
  Future<void> updateTrip(Trip trip) => update(trips).replace(trip);

  // Delete trip
  Future<void> deleteTrip(String id) =>
      (delete(trips)..where((tbl) => tbl.id.equals(id))).go();

  // Get active trips
  Future<List<Trip>> getActiveTrips() =>
      (select(trips)..where((tbl) => tbl.status.equals('ACTIVE'))).get();

  // Get completed trips
  Future<List<Trip>> getCompletedTrips() =>
      (select(trips)..where((tbl) => tbl.status.equals('COMPLETED'))).get();

  // Get trips by vehicle
  Future<List<Trip>> getTripsByVehicle(String vehicleId) =>
      (select(trips)..where((tbl) => tbl.vehicleId.equals(vehicleId))).get();

  // Get trips by driver
  Future<List<Trip>> getTripsByDriver(String driverId) =>
      (select(trips)..where((tbl) => tbl.driverId.equals(driverId))).get();

  // Get trips by party
  Future<List<Trip>> getTripsByParty(String partyId) =>
      (select(trips)..where((tbl) => tbl.partyId.equals(partyId))).get();

  // Search trips by location
  Future<List<Trip>> searchTripsByLocation(String query) => (select(trips)
        ..where((tbl) => tbl.fromLocation.contains(query) | tbl.toLocation.contains(query)))
      .get();

  // Get trip count by status
  Future<int> getTripCountByStatus(String status) async {
    final tripList = await (select(trips)..where((tbl) => tbl.status.equals(status))).get();
    return tripList.length;
  }

  // Get trips by date range
  Future<List<Trip>> getTripsByDateRange(DateTime startDate, DateTime endDate) =>
      (select(trips)
            ..where((tbl) => tbl.startDate.isBetweenValues(startDate, endDate)))
          .get();

  // Update trip status
  Future<void> updateTripStatus(String id, String status) async {
    final trip = await getTripById(id);
    if (trip != null) {
      await updateTrip(trip.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Check if vehicle is available for new trip
  Future<bool> isVehicleAvailable(String vehicleId, {String? excludeTripId}) async {
    final activeTrips = await getActiveTrips();
    return activeTrips.every((trip) =>
        trip.vehicleId != vehicleId || (excludeTripId != null && trip.id == excludeTripId));
  }

  // Check if driver is available for new trip
  Future<bool> isDriverAvailable(String driverId, {String? excludeTripId}) async {
    final activeTrips = await getActiveTrips();
    return activeTrips.every((trip) =>
        trip.driverId != driverId || (excludeTripId != null && trip.id == excludeTripId));
  }

  // Get trip statistics
  Future<Map<String, int>> getTripStatistics() async {
    final activeCount = await getTripCountByStatus('ACTIVE');
    final completedCount = await getTripCountByStatus('COMPLETED');
    final cancelledCount = await getTripCountByStatus('CANCELLED');

    return {
      'ACTIVE': activeCount,
      'COMPLETED': completedCount,
      'CANCELLED': cancelledCount,
      'TOTAL': activeCount + completedCount + cancelledCount,
    };
  }

  // Get recent trips (last 7 days)
  Future<List<Trip>> getRecentTrips() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(trips)
          ..where((tbl) => tbl.startDate.isBiggerThanValue(sevenDaysAgo))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startDate)]))
        .get();
  }

  // Get trips with pending payments
  Future<List<Trip>> getTripsWithPendingPayments() async {
    // TODO: Implement when payment module is ready
    // For now, return all active trips
    return getActiveTrips();
  }

  // Get expenses by trip
  Future<List<Expense>> getExpensesByTrip(String tripId) =>
      (select(expenses)..where((tbl) => tbl.tripId.equals(tripId))).get();

  // Get payments by trip
  Future<List<Payment>> getPaymentsByTrip(String tripId) =>
      (select(payments)..where((tbl) => tbl.tripId.equals(tripId))).get();
}
