import 'package:tranzfort_tms/data/database.dart';

/// Smart Suggestions Service
/// Provides intelligent suggestions based on historical data
class SuggestionService {
  final AppDatabase _database;

  SuggestionService(this._database);

  /// Get location suggestions based on user's history
  /// Returns frequently used locations sorted by usage count
  Future<List<String>> suggestLocations(String query) async {
    if (query.isEmpty) {
      return await _getFrequentLocations();
    }

    final allLocations = await _getFrequentLocations();
    return allLocations
        .where((loc) => loc.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get frequent locations from trip history
  Future<List<String>> _getFrequentLocations() async {
    final trips = await _database.select(_database.trips).get();
    
    final locationMap = <String, int>{};
    
    for (final trip in trips) {
      locationMap[trip.fromLocation] = (locationMap[trip.fromLocation] ?? 0) + 1;
      locationMap[trip.toLocation] = (locationMap[trip.toLocation] ?? 0) + 1;
    }

    final sortedLocations = locationMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedLocations.map((e) => e.key).take(20).toList();
  }

  /// Suggest freight amount based on route and vehicle type
  /// Uses historical average for similar routes
  Future<double?> suggestFreightAmount({
    required String fromLocation,
    required String toLocation,
    required String vehicleId,
  }) async {
    final vehicle = await _database.select(_database.vehicles)
        .get()
        .then((list) => list.firstWhere((v) => v.id == vehicleId));

    final similarTrips = await _database.select(_database.trips)
        .get()
        .then((list) => list.where((trip) =>
            trip.fromLocation.toLowerCase() == fromLocation.toLowerCase() &&
            trip.toLocation.toLowerCase() == toLocation.toLowerCase() &&
            trip.freightAmount > 0).toList());

    if (similarTrips.isEmpty) {
      return null;
    }

    final avgFreight = similarTrips
        .map((t) => t.freightAmount)
        .reduce((a, b) => a + b) / similarTrips.length;

    return avgFreight;
  }

  /// Suggest expense category based on description
  /// Uses keyword matching and historical patterns
  String suggestExpenseCategory(String description) {
    final lowerDesc = description.toLowerCase();

    if (lowerDesc.contains('fuel') || 
        lowerDesc.contains('diesel') || 
        lowerDesc.contains('petrol') ||
        lowerDesc.contains('gas')) {
      return 'FUEL';
    }

    if (lowerDesc.contains('toll') || 
        lowerDesc.contains('tax') ||
        lowerDesc.contains('plaza')) {
      return 'TOLL';
    }

    if (lowerDesc.contains('food') || 
        lowerDesc.contains('lunch') || 
        lowerDesc.contains('dinner') ||
        lowerDesc.contains('breakfast') ||
        lowerDesc.contains('dhaba') ||
        lowerDesc.contains('hotel')) {
      return 'FOOD';
    }

    if (lowerDesc.contains('repair') || 
        lowerDesc.contains('service') || 
        lowerDesc.contains('maintenance') ||
        lowerDesc.contains('mechanic') ||
        lowerDesc.contains('garage')) {
      return 'REPAIR';
    }

    if (lowerDesc.contains('parking') || 
        lowerDesc.contains('loading') ||
        lowerDesc.contains('unloading')) {
      return 'MISC';
    }

    return 'MISC';
  }

  /// Predict if expense amount is unusually high
  /// Returns warning if expense exceeds historical average by 50%
  Future<ExpenseWarning?> checkExpenseAmount({
    required String category,
    required double amount,
    required String tripId,
  }) async {
    final trip = await _database.select(_database.trips)
        .get()
        .then((list) => list.firstWhere((t) => t.id == tripId));

    final historicalExpenses = await _database.select(_database.expenses)
        .get()
        .then((list) => list.where((e) => 
            e.category == category && 
            e.amount > 0).toList());

    if (historicalExpenses.isEmpty) {
      return null;
    }

    final avgAmount = historicalExpenses
        .map((e) => e.amount)
        .reduce((a, b) => a + b) / historicalExpenses.length;

    final threshold = avgAmount * 1.5;

    if (amount > threshold) {
      return ExpenseWarning(
        message: 'This $category expense (₹${amount.toStringAsFixed(0)}) is '
            '${((amount / avgAmount - 1) * 100).toStringAsFixed(0)}% higher '
            'than your average (₹${avgAmount.toStringAsFixed(0)})',
        severity: amount > avgAmount * 2 ? WarningSeverity.high : WarningSeverity.medium,
      );
    }

    return null;
  }

  /// Suggest best driver for a route based on historical performance
  Future<String?> suggestDriver({
    required String fromLocation,
    required String toLocation,
  }) async {
    final trips = await _database.select(_database.trips)
        .get()
        .then((list) => list.where((trip) =>
            trip.fromLocation.toLowerCase() == fromLocation.toLowerCase() &&
            trip.toLocation.toLowerCase() == toLocation.toLowerCase() &&
            trip.driverId != null &&
            trip.status == 'COMPLETED').toList());

    if (trips.isEmpty) {
      return null;
    }

    final driverPerformance = <String, int>{};
    
    for (final trip in trips) {
      if (trip.driverId != null) {
        driverPerformance[trip.driverId!] = 
            (driverPerformance[trip.driverId!] ?? 0) + 1;
      }
    }

    if (driverPerformance.isEmpty) {
      return null;
    }

    final bestDriver = driverPerformance.entries
        .reduce((a, b) => a.value > b.value ? a : b);

    return bestDriver.key;
  }

  /// Get recent trips for quick access
  Future<List<Trip>> getRecentTrips({int limit = 5}) async {
    final trips = await _database.select(_database.trips)
        .get()
        .then((list) => list..sort((a, b) => 
            b.createdAt.compareTo(a.createdAt)));

    return trips.take(limit).toList();
  }

  /// Get frequent parties for quick selection
  Future<List<String>> getFrequentParties({int limit = 10}) async {
    final trips = await _database.select(_database.trips).get();
    
    final partyCount = <String, int>{};
    
    for (final trip in trips) {
      partyCount[trip.partyId] = (partyCount[trip.partyId] ?? 0) + 1;
    }

    final sortedParties = partyCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedParties.map((e) => e.key).take(limit).toList();
  }

  /// Check if party credit limit is exceeded
  Future<CreditWarning?> checkPartyCreditLimit(String partyId) async {
    final payments = await _database.select(_database.payments)
        .get()
        .then((list) => list.where((p) => p.partyId == partyId).toList());

    double balance = 0;
    for (final payment in payments) {
      if (payment.type == 'IN') {
        balance += payment.amount;
      } else {
        balance -= payment.amount;
      }
    }

    if (balance < -50000) {
      return CreditWarning(
        message: 'Party has outstanding balance of ₹${(-balance).toStringAsFixed(0)}',
        severity: balance < -100000 ? WarningSeverity.high : WarningSeverity.medium,
        balance: balance,
      );
    }

    return null;
  }
}

/// Expense warning model
class ExpenseWarning {
  final String message;
  final WarningSeverity severity;

  ExpenseWarning({
    required this.message,
    required this.severity,
  });
}

/// Credit warning model
class CreditWarning {
  final String message;
  final WarningSeverity severity;
  final double balance;

  CreditWarning({
    required this.message,
    required this.severity,
    required this.balance,
  });
}

/// Warning severity levels
enum WarningSeverity {
  low,
  medium,
  high,
}
