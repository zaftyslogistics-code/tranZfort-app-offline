import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/payment_repository.dart';
import '../repositories/trip_repository.dart';

class PaymentService {
  final PaymentRepository _repository;
  final TripRepository _tripRepository;
  final Uuid _uuid = const Uuid();

  PaymentService(this._repository, this._tripRepository);

  // Get all payments
  Future<List<Payment>> getAllPayments() => _repository.getAllPayments();

  // Get payment by ID
  Future<Payment?> getPaymentById(String id) => _repository.getPaymentById(id);

  // Create payment
  Future<void> createPayment({
    required String partyId,
    required double amount,
    required String type,
    required String mode,
    String? tripId,
    String? notes,
    DateTime? date,
  }) async {
    // Validate payment data
    if (!_repository.validatePaymentData(
      partyId: partyId,
      amount: amount,
      type: type,
      mode: mode,
    )) {
      throw Exception('Invalid payment data');
    }

    // Safety check: prevent payment against closed trip
    if (tripId != null) {
      final trip = await _tripRepository.getTripById(tripId);
      if (trip != null && trip.status == 'COMPLETED') {
        throw Exception('Cannot add payment to completed trip');
      }
    }

    final payment = PaymentsCompanion.insert(
      id: _uuid.v4(),
      tripId: Value(tripId),
      partyId: partyId,
      amount: amount,
      type: type,
      mode: mode,
      date: date ?? DateTime.now(),
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addPayment(payment);
  }

  // Update payment
  Future<void> updatePayment({
    required String id,
    String? partyId,
    double? amount,
    String? type,
    String? mode,
    String? tripId,
    String? notes,
    DateTime? date,
  }) async {
    final existingPayment = await _repository.getPaymentById(id);
    if (existingPayment == null) {
      throw Exception('Payment not found');
    }

    // Validate payment data if provided
    if (partyId != null || amount != null || type != null || mode != null) {
      final partyIdToUse = partyId ?? existingPayment.partyId;
      final amountToUse = amount ?? existingPayment.amount;
      final typeToUse = type ?? existingPayment.type;
      final modeToUse = mode ?? existingPayment.mode;

      if (!_repository.validatePaymentData(
        partyId: partyIdToUse,
        amount: amountToUse,
        type: typeToUse,
        mode: modeToUse,
      )) {
        throw Exception('Invalid payment data');
      }
    }

    final updatedPayment = existingPayment.copyWith(
      tripId: Value(tripId ?? existingPayment.tripId),
      partyId: partyId ?? existingPayment.partyId,
      amount: amount ?? existingPayment.amount,
      type: type ?? existingPayment.type,
      mode: mode ?? existingPayment.mode,
      date: date ?? existingPayment.date,
      notes: Value(notes ?? existingPayment.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updatePayment(updatedPayment);
  }

  // Delete payment
  Future<void> deletePayment(String id) async {
    final payment = await _repository.getPaymentById(id);
    if (payment == null) {
      throw Exception('Payment not found');
    }

    await _repository.deletePayment(id);
  }

  // Get payments by trip
  Future<List<Payment>> getPaymentsByTrip(String tripId) => _repository.getPaymentsByTrip(tripId);

  // Get payments by party
  Future<List<Payment>> getPaymentsByParty(String partyId) => _repository.getPaymentsByParty(partyId);

  // Get payments by type
  Future<List<Payment>> getPaymentsByType(String type) => _repository.getPaymentsByType(type);

  // Get payments by mode
  Future<List<Payment>> getPaymentsByMode(String mode) => _repository.getPaymentsByMode(mode);

  // Search payments
  Future<List<Payment>> searchPayments(String query) => _repository.searchPayments(query);

  // Get unique payment types
  Future<List<String>> getUniquePaymentTypes() => _repository.getUniquePaymentTypes();

  // Get unique payment modes
  Future<List<String>> getUniquePaymentModes() => _repository.getUniquePaymentModes();

  // Get payment statistics
  Future<Map<String, int>> getPaymentStatistics() => _repository.getPaymentStatistics();

  // Get total payments for trip
  Future<double> getTotalPaymentsForTrip(String tripId) => _repository.getTotalPaymentsForTrip(tripId);

  // Get total payments for party
  Future<double> getTotalPaymentsForParty(String partyId) => _repository.getTotalPaymentsForParty(partyId);

  // Get recent payments
  Future<List<Payment>> getRecentPayments() => _repository.getRecentPayments();

  // Get payments by date range
  Future<List<Payment>> getPaymentsByDateRange(DateTime startDate, DateTime endDate) =>
      _repository.getPaymentsByDateRange(startDate, endDate);

  // Get pending balance for trip
  Future<double> getPendingBalanceForTrip(String tripId) => _repository.getPendingBalanceForTrip(tripId);

  // Get pending balance for party
  Future<double> getPendingBalanceForParty(String partyId) => _repository.getPendingBalanceForParty(partyId);

  // Get payment types with predefined options
  List<String> getPredefinedPaymentTypes() {
    return [
      'ADVANCE',
      'BALANCE',
      'EXPENSE_REIMBURSEMENT',
      'PENALTY',
      'BONUS',
      'OTHER',
    ];
  }

  // Get payment modes with predefined options
  List<String> getPredefinedPaymentModes() {
    return [
      'CASH',
      'BANK_TRANSFER',
      'CHEQUE',
      'ONLINE',
      'CREDIT_CARD',
      'UPI',
      'NET_BANKING',
      'OTHER',
    ];
  }

  // Validate payment type
  bool isValidPaymentType(String type) {
    return getPredefinedPaymentTypes().contains(type);
  }

  // Validate payment mode
  bool isValidPaymentMode(String mode) {
    return getPredefinedPaymentModes().contains(mode);
  }

  // Get payment summary
  Map<String, dynamic> getPaymentSummary(Payment payment) {
    return {
      'id': payment.id,
      'tripId': payment.tripId,
      'partyId': payment.partyId,
      'amount': payment.amount,
      'type': payment.type,
      'mode': payment.mode,
      'date': payment.date,
      'notes': payment.notes,
      'formattedAmount': '₹${payment.amount.toStringAsFixed(2)}',
      'formattedDate': '${payment.date.day}/${payment.date.month}/${payment.date.year}',
    };
  }

  // Get payment type icon
  String getPaymentTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'ADVANCE':
        return 'payments';
      case 'BALANCE':
        return 'account_balance_wallet';
      case 'EXPENSE_REIMBURSEMENT':
        return 'receipt_long';
      case 'PENALTY':
        return 'warning';
      case 'BONUS':
        return 'stars';
      default:
        return 'help';
    }
  }

  // Get payment mode icon
  String getPaymentModeIcon(String mode) {
    switch (mode.toUpperCase()) {
      case 'CASH':
        return 'payments';
      case 'BANK_TRANSFER':
        return 'account_balance';
      case 'CHEQUE':
        return 'description';
      case 'ONLINE':
        return 'language';
      case 'CREDIT_CARD':
        return 'credit_card';
      case 'UPI':
        return 'qr_code_scanner';
      case 'NET_BANKING':
        return 'account_balance';
      default:
        return 'help';
    }
  }

  // Format payment amount
  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Calculate total payments for multiple trips
  Future<Map<String, double>> calculateTotalPaymentsForTrips(List<String> tripIds) async {
    final totals = <String, double>{};
    
    for (final tripId in tripIds) {
      final total = await getTotalPaymentsForTrip(tripId);
      totals[tripId] = total;
    }
    
    return totals;
  }

  // Calculate party balance
  Future<Map<String, dynamic>> calculatePartyBalance(String partyId) async {
    final summary = await _repository.getPaymentSummaryForParty(partyId);
    final pendingBalance = await getPendingBalanceForParty(partyId);
    
    return {
      ...summary,
      'pendingBalance': pendingBalance,
      'netBalance': summary['totalAmount'] - pendingBalance,
    };
  }

  // Get payment performance metrics
  Future<Map<String, dynamic>> getPaymentPerformance(String partyId) async {
    final payments = await getPaymentsByParty(partyId);
    final totalAmount = payments.fold<double>(0.0, (sum, payment) => sum + payment.amount);
    
    // Group payments by type
    final typeBreakdown = <String, double>{};
    for (final payment in payments) {
      typeBreakdown[payment.type] = (typeBreakdown[payment.type] ?? 0) + payment.amount;
    }
    
    // Get most used payment mode
    String mostUsedMode = '';
    int maxCount = 0;
    final modeCount = <String, int>{};
    for (final payment in payments) {
      modeCount[payment.mode] = (modeCount[payment.mode] ?? 0) + 1;
      if (modeCount[payment.mode]! > maxCount) {
        maxCount = modeCount[payment.mode]!;
        mostUsedMode = payment.mode;
      }
    }
    
    return {
      'totalAmount': totalAmount,
      'paymentCount': payments.length,
      'typeBreakdown': typeBreakdown,
      'mostUsedMode': mostUsedMode,
      'averagePayment': payments.isEmpty ? 0.0 : totalAmount / payments.length,
      'lastPaymentDate': payments.isEmpty ? null : payments.last.date,
    };
  }

  // Get payments by party and date range
  Future<List<Payment>> getPaymentsByPartyAndDateRange(
    String partyId, 
    DateTime startDate, 
    DateTime endDate
  ) => _repository.getPaymentsByPartyAndDateRange(partyId, startDate, endDate);

  // Generate payment receipt text
  String generatePaymentReceipt(Payment payment) {
    final summary = getPaymentSummary(payment);
    return '''
PAYMENT RECEIPT
================
Receipt ID: ${summary['id']}
Date: ${summary['formattedDate']}
Party ID: ${summary['partyId']}
Trip ID: ${summary['tripId'] ?? 'N/A'}
Amount: ${summary['formattedAmount']}
Type: ${summary['type']}
Mode: ${summary['mode']}
${summary['notes'] != null ? 'Notes: ${summary['notes']}' : ''}
================
Thank you for your business!
    ''';
  }
}
