import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/expense_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/services/expense_service.dart';
import 'database_provider.dart';
import 'trip_provider.dart';

// Expense repository provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return ExpenseRepository(database);
});

// Expense service provider
final expenseServiceProvider = Provider<ExpenseService>((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  final tripRepository = ref.watch(tripRepositoryProvider);
  return ExpenseService(expenseRepository, tripRepository);
});

// Expense list provider
final expenseListProvider = FutureProvider<List<Expense>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getAllExpenses();
});

// Expenses by trip provider
final expensesByTripProvider = FutureProvider.family<List<Expense>, String>((ref, tripId) {
  final service = ref.watch(expenseServiceProvider);
  return service.getExpensesByTrip(tripId);
});

// Expenses by category provider
final expensesByCategoryProvider = FutureProvider.family<List<Expense>, String>((ref, category) {
  final service = ref.watch(expenseServiceProvider);
  return service.getExpensesByCategory(category);
});

// Expense statistics provider
final expenseStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getExpenseStatistics();
});

// Recent expenses provider
final recentExpensesProvider = FutureProvider<List<Expense>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getRecentExpenses();
});

// Unique categories provider
final uniqueCategoriesProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getUniqueCategories();
});

// Predefined categories provider
final predefinedCategoriesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getPredefinedCategories();
});

// Predefined payment modes provider
final predefinedPaymentModesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(expenseServiceProvider);
  return service.getPredefinedPaymentModes();
});
