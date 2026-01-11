import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/expense_repository.dart';
import '../repositories/trip_repository.dart';

class ExpenseService {
  final ExpenseRepository _repository;
  final TripRepository _tripRepository;
  final Uuid _uuid = const Uuid();

  ExpenseService(this._repository, this._tripRepository);

  // Get all expenses
  Future<List<Expense>> getAllExpenses() => _repository.getAllExpenses();

  // Get expense by ID
  Future<Expense?> getExpenseById(String id) => _repository.getExpenseById(id);

  // Create expense
  Future<void> createExpense({
    required String tripId,
    required String category,
    required double amount,
    required String paidMode,
    String? billImagePath,
    String? notes,
  }) async {
    // Safety check: tripId is required
    if (tripId.isEmpty) {
      throw Exception('Trip ID is required for expense');
    }

    // Safety check: verify trip exists and is not completed
    final trip = await _tripRepository.getTripById(tripId);
    if (trip == null) {
      throw Exception('Trip not found');
    }
    
    if (trip.status == 'COMPLETED') {
      throw Exception('Cannot add expense to completed trip');
    }

    // Validate expense data
    if (!_repository.validateExpenseData(
      tripId: tripId,
      category: category,
      amount: amount,
      paidMode: paidMode,
    )) {
      throw Exception('Invalid expense data');
    }

    final expense = ExpensesCompanion.insert(
      id: _uuid.v4(),
      tripId: tripId,
      category: category,
      amount: amount,
      paidMode: paidMode,
      billImagePath: Value(billImagePath),
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addExpense(expense);
  }

  // Update expense
  Future<void> updateExpense({
    required String id,
    String? tripId,
    String? category,
    double? amount,
    String? paidMode,
    String? billImagePath,
    String? notes,
  }) async {
    final existingExpense = await _repository.getExpenseById(id);
    if (existingExpense == null) {
      throw Exception('Expense not found');
    }

    // Validate expense data if provided
    if (tripId != null || category != null || amount != null || paidMode != null) {
      final tripIdToUse = tripId ?? existingExpense.tripId;
      final categoryToUse = category ?? existingExpense.category;
      final amountToUse = amount ?? existingExpense.amount;
      final paidModeToUse = paidMode ?? existingExpense.paidMode;

      if (!_repository.validateExpenseData(
        tripId: tripIdToUse,
        category: categoryToUse,
        amount: amountToUse,
        paidMode: paidModeToUse,
      )) {
        throw Exception('Invalid expense data');
      }
    }

    final updatedExpense = existingExpense.copyWith(
      tripId: tripId ?? existingExpense.tripId,
      category: category ?? existingExpense.category,
      amount: amount ?? existingExpense.amount,
      paidMode: paidMode ?? existingExpense.paidMode,
      billImagePath: Value(billImagePath ?? existingExpense.billImagePath),
      notes: Value(notes ?? existingExpense.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updateExpense(updatedExpense);
  }

  // Delete expense
  Future<void> deleteExpense(String id) async {
    final expense = await _repository.getExpenseById(id);
    if (expense == null) {
      throw Exception('Expense not found');
    }

    await _repository.deleteExpense(id);
  }

  // Get expenses by trip
  Future<List<Expense>> getExpensesByTrip(String tripId) => _repository.getExpensesByTrip(tripId);

  // Get expenses by category
  Future<List<Expense>> getExpensesByCategory(String category) => _repository.getExpensesByCategory(category);

  // Search expenses
  Future<List<Expense>> searchExpenses(String query) => _repository.searchExpenses(query);

  // Get unique categories
  Future<List<String>> getUniqueCategories() => _repository.getUniqueCategories();

  // Get expense statistics
  Future<Map<String, int>> getExpenseStatistics() => _repository.getExpenseStatistics();

  // Get expenses by payment mode
  Future<List<Expense>> getExpensesByPaymentMode(String paidMode) => _repository.getExpensesByPaymentMode(paidMode);

  // Get total expenses for trip
  Future<double> getTotalExpensesForTrip(String tripId) => _repository.getTotalExpensesForTrip(tripId);

  // Get recent expenses
  Future<List<Expense>> getRecentExpenses() => _repository.getRecentExpenses();

  // Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate) =>
      _repository.getExpensesByDateRange(startDate, endDate);

  // Update expense with bill image
  Future<void> updateExpenseBillImage(String id, String billImagePath) =>
      _repository.updateExpenseBillImage(id, billImagePath);

  // Get expense categories with predefined options
  List<String> getPredefinedCategories() {
    return [
      'FUEL',
      'TOLL',
      'MAINTENANCE',
      'DRIVER_SALARY',
      'PARKING',
      'FOOD',
      'ACCOMMODATION',
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
      'OTHER',
    ];
  }

  // Validate expense category
  bool isValidCategory(String category) {
    return getPredefinedCategories().contains(category);
  }

  // Validate payment mode
  bool isValidPaymentMode(String paidMode) {
    return getPredefinedPaymentModes().contains(paidMode);
  }

  // Get expense summary
  Map<String, dynamic> getExpenseSummary(Expense expense) {
    return {
      'id': expense.id,
      'tripId': expense.tripId,
      'category': expense.category,
      'amount': expense.amount,
      'paidMode': expense.paidMode,
      'hasBill': expense.billImagePath != null,
      'notes': expense.notes,
      'createdAt': expense.createdAt,
      'updatedAt': expense.updatedAt,
      'formattedAmount': '₹${expense.amount.toStringAsFixed(2)}',
    };
  }

  // Get expense category icon
  String getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'FUEL':
        return 'local_gas_station';
      case 'TOLL':
        return 'toll';
      case 'MAINTENANCE':
        return 'build';
      case 'DRIVER_SALARY':
        return 'payments';
      case 'PARKING':
        return 'local_parking';
      case 'FOOD':
        return 'restaurant';
      case 'ACCOMMODATION':
        return 'hotel';
      default:
        return 'receipt_long';
    }
  }

  // Get payment mode icon
  String getPaymentModeIcon(String paidMode) {
    switch (paidMode.toUpperCase()) {
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
      default:
        return 'help';
    }
  }

  // Format expense amount
  String formatAmount(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  // Calculate total expenses for multiple trips
  Future<Map<String, double>> calculateTotalExpensesForTrips(List<String> tripIds) async {
    final totals = <String, double>{};
    
    for (final tripId in tripIds) {
      final total = await getTotalExpensesForTrip(tripId);
      totals[tripId] = total;
    }
    
    return totals;
  }

  // Get expense performance metrics
  Future<Map<String, dynamic>> getExpensePerformance(String tripId) async {
    final expenses = await getExpensesByTrip(tripId);
    final totalExpenses = expenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
    
    // Group expenses by category
    final categoryBreakdown = <String, double>{};
    for (final expense in expenses) {
      categoryBreakdown[expense.category] = (categoryBreakdown[expense.category] ?? 0) + expense.amount;
    }
    
    // Get most expensive category
    String mostExpensiveCategory = '';
    double maxAmount = 0;
    categoryBreakdown.forEach((category, amount) {
      if (amount > maxAmount) {
        maxAmount = amount;
        mostExpensiveCategory = category;
      }
    });
    
    return {
      'totalExpenses': totalExpenses,
      'expenseCount': expenses.length,
      'categoryBreakdown': categoryBreakdown,
      'mostExpensiveCategory': mostExpensiveCategory,
      'averageExpense': expenses.isEmpty ? 0.0 : totalExpenses / expenses.length,
    };
  }
}
