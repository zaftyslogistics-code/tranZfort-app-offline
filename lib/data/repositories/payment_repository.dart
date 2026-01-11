import 'package:drift/drift.dart';
import '../database.dart';

part 'payment_repository.g.dart';

@DriftAccessor(tables: [Payments, Trips, Expenses])
class PaymentRepository extends DatabaseAccessor<AppDatabase> with _$PaymentRepositoryMixin {
  PaymentRepository(AppDatabase db) : super(db);

  // Get all payments
  Future<List<Payment>> getAllPayments() => select(payments).get();

  // Get payment by ID
  Future<Payment?> getPaymentById(String id) =>
      (select(payments)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get payments by trip
  Future<List<Payment>> getPaymentsByTrip(String tripId) =>
      (select(payments)..where((tbl) => tbl.tripId.equals(tripId))).get();

  // Get expenses by trip
  Future<List<Expense>> getExpensesByTrip(String tripId) =>
      (select(expenses)..where((tbl) => tbl.tripId.equals(tripId))).get();

  // Get payments by party
  Future<List<Payment>> getPaymentsByParty(String partyId) =>
      (select(payments)..where((tbl) => tbl.partyId.equals(partyId))).get();

  // Add new payment
  Future<void> addPayment(PaymentsCompanion payment) => into(payments).insert(payment);

  // Update payment
  Future<void> updatePayment(Payment payment) => update(payments).replace(payment);

  // Delete payment
  Future<void> deletePayment(String id) =>
      (delete(payments)..where((tbl) => tbl.id.equals(id))).go();

  // Get payments by type
  Future<List<Payment>> getPaymentsByType(String type) =>
      (select(payments)..where((tbl) => tbl.type.equals(type))).get();

  // Get payments by mode
  Future<List<Payment>> getPaymentsByMode(String mode) =>
      (select(payments)..where((tbl) => tbl.mode.equals(mode))).get();

  // Get payments by date range
  Future<List<Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate) =>
      (select(payments)
            ..where((tbl) => tbl.date.isBetweenValues(startDate, endDate)))
          .get();

  // Search payments by notes
  Future<List<Payment>> searchPayments(String query) => (select(payments)
        ..where((tbl) => tbl.notes.contains(query)))
      .get();

  // Get payment count by type
  Future<int> getPaymentCountByType(String type) async {
    final paymentList = await (select(payments)..where((tbl) => tbl.type.equals(type))).get();
    return paymentList.length;
  }

  // Get unique payment types
  Future<List<String>> getUniquePaymentTypes() async {
    final allPayments = await getAllPayments();
    final types = allPayments.map((payment) => payment.type).toSet().toList();
    types.sort();
    return types;
  }

  // Get unique payment modes
  Future<List<String>> getUniquePaymentModes() async {
    final allPayments = await getAllPayments();
    final modes = allPayments.map((payment) => payment.mode).toSet().toList();
    modes.sort();
    return modes;
  }

  // Get payment statistics
  Future<Map<String, int>> getPaymentStatistics() async {
    final allPayments = await getAllPayments();
    final types = <String, int>{};
    
    for (final payment in allPayments) {
      types[payment.type] = (types[payment.type] ?? 0) + 1;
    }
    
    types['TOTAL'] = allPayments.length;
    return types;
  }

  // Get total payments for trip
  Future<double> getTotalPaymentsForTrip(String tripId) async {
    final tripPayments = await getPaymentsByTrip(tripId);
    return tripPayments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
  }

  // Get total payments for party
  Future<double> getTotalPaymentsForParty(String partyId) async {
    final partyPayments = await getPaymentsByParty(partyId);
    return partyPayments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
  }

  // Get recent payments (last 7 days)
  Future<List<Payment>> getRecentPayments() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(payments)
          ..where((tbl) => tbl.date.isBiggerThanValue(sevenDaysAgo))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.date)]))
        .get();
  }

  // Get pending balance for trip
  Future<double> getPendingBalanceForTrip(String tripId) async {
    // Get trip details
    final trip = await (select(trips)..where((tbl) => tbl.id.equals(tripId))).getSingleOrNull();
    if (trip == null) return 0.0;
    
    // Calculate total payments for this trip
    final tripPayments = await getPaymentsByTrip(tripId);
    final totalPayments = tripPayments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
    
    // Calculate total expenses for this trip - use repository method
    final tripExpenses = await getExpensesByTrip(tripId);
    final totalExpenses = tripExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    
    // Pending balance = Freight Amount - Total Payments - Total Expenses
    return trip.freightAmount - totalPayments - totalExpenses;
  }

  // Get pending balance for party
  Future<double> getPendingBalanceForParty(String partyId) async {
    // Get all trips for this party
    final partyTrips = await (select(trips)..where((tbl) => tbl.partyId.equals(partyId))).get();
    
    double totalFreight = 0.0;
    double totalPayments = 0.0;
    double totalExpenses = 0.0;
    
    // Calculate totals across all trips
    for (final trip in partyTrips) {
      totalFreight += trip.freightAmount;
      
      // Add payments for this trip
      final tripPayments = await getPaymentsByTrip(trip.id);
      totalPayments += tripPayments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
      
      // Add expenses for this trip - use repository method
      final tripExpenses = await getExpensesByTrip(trip.id);
      totalExpenses += tripExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    }
    
    // Party balance = Total Freight - Total Payments - Total Expenses
    return totalFreight - totalPayments - totalExpenses;
  }

  // Validate payment data
  bool validatePaymentData({
    required String partyId,
    required double amount,
    required String type,
    required String mode,
  }) {
    // Basic validation
    if (partyId.isEmpty) return false;
    if (amount <= 0) return false;
    if (type.isEmpty) return false;
    if (mode.isEmpty) return false;

    return true;
  }

  // Get payments by party and date range
  Future<List<Payment>> getPaymentsByPartyAndDateRange(
    String partyId, 
    DateTime startDate, 
    DateTime endDate
  ) async {
    return (select(payments)
          ..where((tbl) => tbl.partyId.equals(partyId) & 
                   tbl.date.isBetweenValues(startDate, endDate)))
        .get();
  }

  // Get payment summary for party
  Future<Map<String, dynamic>> getPaymentSummaryForParty(String partyId) async {
    final payments = await getPaymentsByParty(partyId);
    final totalAmount = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
    
    // Group by payment type
    final typeBreakdown = <String, double>{};
    for (final payment in payments) {
      typeBreakdown[payment.type] = (typeBreakdown[payment.type] ?? 0) + payment.amount;
    }
    
    return {
      'totalAmount': totalAmount,
      'paymentCount': payments.length,
      'typeBreakdown': typeBreakdown,
      'lastPaymentDate': payments.isEmpty ? null : payments.last.date,
    };
  }
}
