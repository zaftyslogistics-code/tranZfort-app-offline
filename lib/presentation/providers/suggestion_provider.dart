import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tranzfort_tms/domain/services/suggestion_service.dart';
import 'package:tranzfort_tms/presentation/providers/database_provider.dart';

/// Suggestion Service Provider
final suggestionServiceProvider = Provider<SuggestionService>((ref) {
  final database = ref.watch(databaseProvider);
  return SuggestionService(database);
});

/// Location Suggestions Provider
final locationSuggestionsProvider = FutureProvider.family<List<String>, String>((ref, query) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.suggestLocations(query);
});

/// Freight Amount Suggestion Provider
final freightSuggestionProvider = FutureProvider.family<double?, FreightSuggestionParams>((ref, params) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.suggestFreightAmount(
    fromLocation: params.fromLocation,
    toLocation: params.toLocation,
    vehicleId: params.vehicleId,
  );
});

/// Expense Category Suggestion Provider
final expenseCategorySuggestionProvider = Provider.family<String, String>((ref, description) {
  final service = ref.watch(suggestionServiceProvider);
  return service.suggestExpenseCategory(description);
});

/// Expense Warning Provider
final expenseWarningProvider = FutureProvider.family<ExpenseWarning?, ExpenseWarningParams>((ref, params) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.checkExpenseAmount(
    category: params.category,
    amount: params.amount,
    tripId: params.tripId,
  );
});

/// Driver Suggestion Provider
final driverSuggestionProvider = FutureProvider.family<String?, DriverSuggestionParams>((ref, params) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.suggestDriver(
    fromLocation: params.fromLocation,
    toLocation: params.toLocation,
  );
});

/// Recent Trips Provider
final recentTripsProvider = FutureProvider((ref) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.getRecentTrips(limit: 5);
});

/// Frequent Parties Provider
final frequentPartiesProvider = FutureProvider((ref) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.getFrequentParties(limit: 10);
});

/// Party Credit Warning Provider
final partyCreditWarningProvider = FutureProvider.family<CreditWarning?, String>((ref, partyId) async {
  final service = ref.watch(suggestionServiceProvider);
  return await service.checkPartyCreditLimit(partyId);
});

/// Parameter classes for family providers
class FreightSuggestionParams {
  final String fromLocation;
  final String toLocation;
  final String vehicleId;

  FreightSuggestionParams({
    required this.fromLocation,
    required this.toLocation,
    required this.vehicleId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FreightSuggestionParams &&
          runtimeType == other.runtimeType &&
          fromLocation == other.fromLocation &&
          toLocation == other.toLocation &&
          vehicleId == other.vehicleId;

  @override
  int get hashCode => fromLocation.hashCode ^ toLocation.hashCode ^ vehicleId.hashCode;
}

class ExpenseWarningParams {
  final String category;
  final double amount;
  final String tripId;

  ExpenseWarningParams({
    required this.category,
    required this.amount,
    required this.tripId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseWarningParams &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          amount == other.amount &&
          tripId == other.tripId;

  @override
  int get hashCode => category.hashCode ^ amount.hashCode ^ tripId.hashCode;
}

class DriverSuggestionParams {
  final String fromLocation;
  final String toLocation;

  DriverSuggestionParams({
    required this.fromLocation,
    required this.toLocation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverSuggestionParams &&
          runtimeType == other.runtimeType &&
          fromLocation == other.fromLocation &&
          toLocation == other.toLocation;

  @override
  int get hashCode => fromLocation.hashCode ^ toLocation.hashCode;
}
