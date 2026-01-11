import 'package:drift/drift.dart';
import '../database.dart';

part 'expense_repository.g.dart';

@DriftAccessor(tables: [Expenses])
class ExpenseRepository extends DatabaseAccessor<AppDatabase> with _$ExpenseRepositoryMixin {
  ExpenseRepository(AppDatabase db) : super(db);

  // Get all expenses
  Future<List<Expense>> getAllExpenses() => select(expenses).get();

  // Get expense by ID
  Future<Expense?> getExpenseById(String id) =>
      (select(expenses)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Get expenses by trip
  Future<List<Expense>> getExpensesByTrip(String tripId) =>
      (select(expenses)..where((tbl) => tbl.tripId.equals(tripId))).get();

  // Add new expense
  Future<void> addExpense(ExpensesCompanion expense) => into(expenses).insert(expense);

  // Update expense
  Future<void> updateExpense(Expense expense) => update(expenses).replace(expense);

  // Delete expense
  Future<void> deleteExpense(String id) =>
      (delete(expenses)..where((tbl) => tbl.id.equals(id))).go();

  // Get expenses by category
  Future<List<Expense>> getExpensesByCategory(String category) =>
      (select(expenses)..where((tbl) => tbl.category.equals(category))).get();

  // Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(DateTime startDate, DateTime endDate) =>
      (select(expenses)
            ..where((tbl) => tbl.createdAt.isBetweenValues(startDate, endDate)))
          .get();

  // Search expenses by description
  Future<List<Expense>> searchExpenses(String query) => (select(expenses)
        ..where((tbl) => tbl.notes.contains(query)))
      .get();

  // Get expense count by category
  Future<int> getExpenseCountByCategory(String category) async {
    final expenseList = await (select(expenses)..where((tbl) => tbl.category.equals(category))).get();
    return expenseList.length;
  }

  // Get unique categories
  Future<List<String>> getUniqueCategories() async {
    final allExpenses = await getAllExpenses();
    final categories = allExpenses.map((expense) => expense.category).toSet().toList();
    categories.sort();
    return categories;
  }

  // Get expense statistics
  Future<Map<String, int>> getExpenseStatistics() async {
    final allExpenses = await getAllExpenses();
    final categories = <String, int>{};
    
    for (final expense in allExpenses) {
      categories[expense.category] = (categories[expense.category] ?? 0) + 1;
    }
    
    categories['TOTAL'] = allExpenses.length;
    return categories;
  }

  // Get expenses by payment mode
  Future<List<Expense>> getExpensesByPaymentMode(String paidMode) =>
      (select(expenses)..where((tbl) => tbl.paidMode.equals(paidMode))).get();

  // Get total expenses for trip
  Future<double> getTotalExpensesForTrip(String tripId) async {
    final tripExpenses = await getExpensesByTrip(tripId);
    return tripExpenses.fold<double>(0.0, (sum, expense) => sum + expense.amount);
  }

  // Get recent expenses (last 7 days)
  Future<List<Expense>> getRecentExpenses() async {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return (select(expenses)
          ..where((tbl) => tbl.createdAt.isBiggerThanValue(sevenDaysAgo))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.createdAt)]))
        .get();
  }

  // Update expense with bill image
  Future<void> updateExpenseBillImage(String id, String billImagePath) async {
    final expense = await getExpenseById(id);
    if (expense != null) {
      await updateExpense(expense.copyWith(
        billImagePath: Value(billImagePath),
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Validate expense data
  bool validateExpenseData({
    required String tripId,
    required String category,
    required double amount,
    required String paidMode,
  }) {
    // Basic validation
    if (tripId.isEmpty) return false;
    if (category.isEmpty) return false;
    if (amount <= 0) return false;
    if (paidMode.isEmpty) return false;

    return true;
  }
}
