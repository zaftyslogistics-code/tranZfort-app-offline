import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../../data/repositories/party_repository.dart';
import '../../data/services/party_service.dart';
import 'database_provider.dart';

// Party repository provider
final partyRepositoryProvider = Provider<PartyRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return PartyRepository(database);
});

// Party service provider
final partyServiceProvider = Provider<PartyService>((ref) {
  final repository = ref.watch(partyRepositoryProvider);
  return PartyService(repository);
});

// Party list provider
final partyListProvider = FutureProvider<List<Party>>((ref) {
  final service = ref.watch(partyServiceProvider);
  return service.getAllParties();
});

// Party statistics provider
final partyStatsProvider = FutureProvider<Map<String, int>>((ref) {
  final service = ref.watch(partyServiceProvider);
  return service.getPartyStatistics();
});

// Cities list provider
final citiesListProvider = FutureProvider<List<String>>((ref) {
  final service = ref.watch(partyServiceProvider);
  return service.getUniqueCities();
});

// Parties with GST provider
final partiesWithGstProvider = FutureProvider<List<Party>>((ref) {
  final service = ref.watch(partyServiceProvider);
  return service.getPartiesWithGst();
});

// Parties without GST provider
final partiesWithoutGstProvider = FutureProvider<List<Party>>((ref) {
  final service = ref.watch(partyServiceProvider);
  return service.getPartiesWithoutGst();
});
