import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/payment_repository.dart';
import '../../data/repositories/trip_repository.dart';
import '../../data/services/payment_service.dart';
import 'database_provider.dart';
import 'trip_provider.dart';

// Payment repository provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return PaymentRepository(database);
});

// Payment service provider
final paymentServiceProvider = Provider<PaymentService>((ref) {
  final paymentRepository = ref.watch(paymentRepositoryProvider);
  final tripRepository = ref.watch(tripRepositoryProvider);
  return PaymentService(paymentRepository, tripRepository);
});

// Payment list provider
final paymentListProvider = FutureProvider<List<Payment>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getAllPayments();
});

// Payments by trip provider
final paymentsByTripProvider = FutureProvider.family<List<Payment>, String>((ref, tripId) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentsByTrip(tripId);
});

// Payments by party provider
final paymentsByPartyProvider = FutureProvider.family<List<Payment>, String>((ref, partyId) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentsByParty(partyId);
});

// Payments by type provider
final paymentsByTypeProvider = FutureProvider.family<List<Payment>, String>((ref, type) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentsByType(type);
});

// Payment statistics provider
final paymentStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPaymentStatistics();
});

// Recent payments provider
final recentPaymentsProvider = FutureProvider<List<Payment>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getRecentPayments();
});

// Unique payment types provider
final uniquePaymentTypesProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getUniquePaymentTypes();
});

// Unique payment modes provider
final uniquePaymentModesProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getUniquePaymentModes();
});

// Predefined payment types provider
final predefinedPaymentTypesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPredefinedPaymentTypes();
});

// Predefined payment modes provider
final predefinedPaymentModesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(paymentServiceProvider);
  return service.getPredefinedPaymentModes();
});

// Party balance provider
final partyBalanceProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, partyId) {
  final service = ref.watch(paymentServiceProvider);
  return service.calculatePartyBalance(partyId);
});
