import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/document_repository.dart';
import '../../data/services/document_service.dart';
import 'database_provider.dart';
import 'vehicle_provider.dart';
import 'driver_provider.dart';
import 'party_provider.dart';
import 'trip_provider.dart';
import 'expense_provider.dart';
import 'payment_provider.dart';

// Document repository provider
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return DocumentRepository(database);
});

// Document service provider
final documentServiceProvider = Provider<DocumentService>((ref) {
  final repository = ref.watch(documentRepositoryProvider);
  return DocumentService(repository);
});

// Document list provider
final documentListProvider = FutureProvider<List<Document>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getAllDocuments();
});

// Documents by entity provider
final documentsByEntityProvider = FutureProvider.family<List<Document>, Map<String, String>>((ref, params) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity(params['entityType']!, params['entityId']!);
});

// Documents by type provider
final documentsByTypeProvider = FutureProvider.family<List<Document>, String>((ref, type) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByType(type);
});

// Document statistics provider
final documentStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentStatistics();
});

// Recent documents provider
final recentDocumentsProvider = FutureProvider<List<Document>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getRecentDocuments();
});

// Unique document types provider
final uniqueDocumentTypesProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getUniqueDocumentTypes();
});

// Predefined document types provider
final predefinedDocumentTypesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getPredefinedDocumentTypes();
});

// Predefined entity types provider
final predefinedEntityTypesProvider = Provider<List<String>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getPredefinedEntityTypes();
});

// Documents by entity type provider
final documentsByEntityTypeProvider = FutureProvider.family<List<Document>, String>((ref, entityType) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntityType(entityType);
});

// Document count by entity type provider
final documentCountByEntityTypeProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentCountByEntityType();
});

// Vehicle documents provider
final vehicleDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, vehicleId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('VEHICLE', vehicleId);
});

// Driver documents provider
final driverDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, driverId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('DRIVER', driverId);
});

// Party documents provider
final partyDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, partyId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('PARTY', partyId);
});

// Trip documents provider
final tripDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, tripId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('TRIP', tripId);
});

// Expense documents provider
final expenseDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, expenseId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('EXPENSE', expenseId);
});

// Payment documents provider
final paymentDocumentsProvider = FutureProvider.family<List<Document>, String>((ref, paymentId) {
  final service = ref.watch(documentServiceProvider);
  return service.getDocumentsByEntity('PAYMENT', paymentId);
});
