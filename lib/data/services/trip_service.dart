import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/trip_repository.dart';

class TripService {
  final TripRepository _repository;
  final Uuid _uuid = const Uuid();

  TripService(this._repository);

  // Get all trips
  Future<List<Trip>> getAllTrips() => _repository.getAllTrips();

  // Get trip by ID
  Future<Trip?> getTripById(String id) => _repository.getTripById(id);

  // Create new trip
  Future<void> createTrip({
    required String fromLocation,
    required String toLocation,
    required String vehicleId,
    required String driverId,
    required String partyId,
    required double freightAmount,
    double? advanceAmount,
    DateTime? startDate,
    DateTime? expectedEndDate,
    String? notes,
  }) async {
    // Check vehicle and driver availability
    final isVehicleAvailable = await _repository.isVehicleAvailable(vehicleId);
    if (!isVehicleAvailable) {
      throw Exception('Vehicle is already on an active trip');
    }

    final isDriverAvailable = await _repository.isDriverAvailable(driverId);
    if (!isDriverAvailable) {
      throw Exception('Driver is already on an active trip');
    }

    final trip = TripsCompanion.insert(
      id: _uuid.v4(),
      fromLocation: fromLocation,
      toLocation: toLocation,
      vehicleId: vehicleId,
      driverId: driverId,
      partyId: partyId,
      freightAmount: freightAmount,
      advanceAmount: Value(advanceAmount ?? 0.0),
      startDate: startDate ?? DateTime.now(),
      expectedEndDate: Value(expectedEndDate),
      status: 'ACTIVE',
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addTrip(trip);
  }

  // Update trip
  Future<void> updateTrip({
    required String id,
    String? fromLocation,
    String? toLocation,
    String? vehicleId,
    String? driverId,
    String? partyId,
    double? freightAmount,
    double? advanceAmount,
    DateTime? startDate,
    DateTime? expectedEndDate,
    DateTime? actualEndDate,
    String? status,
    String? notes,
  }) async {
    final existingTrip = await _repository.getTripById(id);
    if (existingTrip == null) {
      throw Exception('Trip not found');
    }

    // Check vehicle and driver availability if changing
    if (vehicleId != null && vehicleId != existingTrip.vehicleId) {
      final isVehicleAvailable = await _repository.isVehicleAvailable(vehicleId, excludeTripId: id);
      if (!isVehicleAvailable) {
        throw Exception('Vehicle is already on an active trip');
      }
    }

    if (driverId != null && driverId != existingTrip.driverId) {
      final isDriverAvailable = await _repository.isDriverAvailable(driverId, excludeTripId: id);
      if (!isDriverAvailable) {
        throw Exception('Driver is already on an active trip');
      }
    }

    final updatedTrip = existingTrip.copyWith(
      fromLocation: fromLocation ?? existingTrip.fromLocation,
      toLocation: toLocation ?? existingTrip.toLocation,
      vehicleId: vehicleId ?? existingTrip.vehicleId,
      driverId: driverId ?? existingTrip.driverId,
      partyId: partyId ?? existingTrip.partyId,
      freightAmount: freightAmount ?? existingTrip.freightAmount,
      advanceAmount: Value(advanceAmount ?? existingTrip.advanceAmount),
      startDate: startDate ?? existingTrip.startDate,
      expectedEndDate: Value(expectedEndDate ?? existingTrip.expectedEndDate),
      actualEndDate: Value(actualEndDate ?? existingTrip.actualEndDate),
      status: status ?? existingTrip.status,
      notes: Value(notes ?? existingTrip.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updateTrip(updatedTrip);
  }

  // Delete trip
  Future<void> deleteTrip(String id) async {
    final trip = await _repository.getTripById(id);
    if (trip == null) {
      throw Exception('Trip not found');
    }

    if (trip.status == 'ACTIVE') {
      throw Exception('Cannot delete an active trip');
    }

    // Check for linked expenses and payments
    final expenses = await _repository.getExpensesByTrip(id);
    final payments = await _repository.getPaymentsByTrip(id);

    if (expenses.isNotEmpty || payments.isNotEmpty) {
      throw Exception('Cannot delete trip with linked expenses or payments');
    }

    await _repository.deleteTrip(id);
  }

  // Complete trip
  Future<void> completeTrip(String id, {DateTime? actualEndDate}) async {
    final trip = await _repository.getTripById(id);
    if (trip == null) {
      throw Exception('Trip not found');
    }
    
    // Validate trip can be closed
    if (trip.status != 'ACTIVE') {
      throw Exception('Only active trips can be completed');
    }
    
    if (trip.freightAmount <= 0) {
      throw Exception('Trip must have a valid freight amount');
    }
    
    // Get expenses for this trip
    final expenses = await _repository.getExpensesByTrip(id);
    
    // Get payments for this trip
    final payments = await _repository.getPaymentsByTrip(id);
    
    // Calculate totals
    // totals are calculated for logging but not used in completion
    final totalExpenses = expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    final totalPayments = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
    
    // Update trip with completion data
    await updateTrip(
      id: id,
      status: 'COMPLETED',
      actualEndDate: actualEndDate ?? DateTime.now(),
    );
    
    // Note: Ledger is automatically calculated through getPendingBalanceForTrip/Party
    // No need to update ledger separately as it's computed on-demand
  }

  // Cancel trip
  Future<void> cancelTrip(String id, {String? reason}) async {
    await updateTrip(
      id: id,
      status: 'CANCELLED',
      notes: reason ?? 'Trip cancelled',
    );
  }

  // Get active trips
  Future<List<Trip>> getActiveTrips() => _repository.getActiveTrips();

  // Get completed trips
  Future<List<Trip>> getCompletedTrips() => _repository.getCompletedTrips();

  // Search trips
  Future<List<Trip>> searchTripsByLocation(String query) => _repository.searchTripsByLocation(query);

  // Get trips by vehicle
  Future<List<Trip>> getTripsByVehicle(String vehicleId) => _repository.getTripsByVehicle(vehicleId);

  // Get trips by driver
  Future<List<Trip>> getTripsByDriver(String driverId) => _repository.getTripsByDriver(driverId);

  // Get trips by party
  Future<List<Trip>> getTripsByParty(String partyId) => _repository.getTripsByParty(partyId);

  // Get trip statistics
  Future<Map<String, int>> getTripStatistics() => _repository.getTripStatistics();

  // Get recent trips
  Future<List<Trip>> getRecentTrips() => _repository.getRecentTrips();

  // Get trips by date range
  Future<List<Trip>> getTripsByDateRange(DateTime startDate, DateTime endDate) =>
      _repository.getTripsByDateRange(startDate, endDate);

  // Calculate trip profitability
  double calculateTripProfitability(Trip trip, double totalExpenses) {
    return trip.freightAmount - totalExpenses;
  }

  // Get trip duration
  Duration getTripDuration(Trip trip) {
    final end = trip.actualEndDate ?? DateTime.now();
    return end.difference(trip.startDate);
  }

  // Validate trip data
  bool validateTripData({
    required String fromLocation,
    required String toLocation,
    required String vehicleId,
    required String driverId,
    required String partyId,
    required double freightAmount,
    double? advanceAmount,
  }) {
    // Basic validation
    if (fromLocation.isEmpty || toLocation.isEmpty) {
      return false;
    }

    if (vehicleId.isEmpty || driverId.isEmpty || partyId.isEmpty) {
      return false;
    }

    if (freightAmount <= 0) {
      return false;
    }

    if (advanceAmount != null && advanceAmount < 0) {
      return false;
    }

    if (advanceAmount != null && advanceAmount > freightAmount) {
      return false;
    }

    return true;
  }

  // Get trip status color
  String getTripStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return 'info';
      case 'COMPLETED':
        return 'success';
      case 'CANCELLED':
        return 'danger';
      default:
        return 'warning';
    }
  }

  // Format trip duration for display
  String formatTripDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  // Get trip summary
  Map<String, dynamic> getTripSummary(Trip trip) {
    return {
      'id': trip.id,
      'route': '${trip.fromLocation} → ${trip.toLocation}',
      'status': trip.status,
      'freightAmount': trip.freightAmount,
      'advanceAmount': trip.advanceAmount,
      'balance': trip.freightAmount - (trip.advanceAmount ?? 0.0),
      'duration': formatTripDuration(getTripDuration(trip)),
      'startDate': trip.startDate,
      'expectedEndDate': trip.expectedEndDate,
      'actualEndDate': trip.actualEndDate,
    };
  }
}
