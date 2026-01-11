import 'package:drift/drift.dart';
import '../database.dart';

part 'party_repository.g.dart';

@DriftAccessor(tables: [Parties])
class PartyRepository extends DatabaseAccessor<AppDatabase> with _$PartyRepositoryMixin {
  PartyRepository(AppDatabase db) : super(db);

  // Get all parties
  Future<List<Party>> getAllParties() => select(parties).get();

  // Get party by ID
  Future<Party?> getPartyById(String id) =>
      (select(parties)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Add new party
  Future<void> addParty(PartiesCompanion party) => into(parties).insert(party);

  // Update party
  Future<void> updateParty(Party party) => update(parties).replace(party);

  // Delete party
  Future<void> deleteParty(String id) =>
      (delete(parties)..where((tbl) => tbl.id.equals(id))).go();

  // Search parties by name or mobile
  Future<List<Party>> searchParties(String query) => (select(parties)
        ..where((tbl) => tbl.name.contains(query) | tbl.mobile.contains(query)))
      .get();

  // Get parties by city
  Future<List<Party>> getPartiesByCity(String city) =>
      (select(parties)..where((tbl) => tbl.city.equals(city))).get();

  // Get party count by city
  Future<int> getPartyCountByCity(String city) async {
    final partyList = await (select(parties)..where((tbl) => tbl.city.equals(city))).get();
    return partyList.length;
  }

  // Get unique cities list
  Future<List<String>> getUniqueCities() async {
    final allParties = await getAllParties();
    final cities = allParties.map((party) => party.city).toSet().toList();
    cities.sort();
    return cities;
  }

  // Check if mobile number is unique
  Future<bool> isMobileUnique(String mobile, {String? excludeId}) async {
    final parties = await getAllParties();
    return parties.every((party) =>
        party.mobile != mobile || (excludeId != null && party.id == excludeId));
  }

  // Check if GST number is unique
  Future<bool> isGstUnique(String gst, {String? excludeId}) async {
    final parties = await getAllParties();
    return parties.every((party) =>
        party.gst != gst || (excludeId != null && party.id == excludeId));
  }

  // Get party statistics
  Future<Map<String, int>> getPartyStatistics() async {
    final allParties = await getAllParties();
    final cities = <String, int>{};
    
    for (final party in allParties) {
      cities[party.city] = (cities[party.city] ?? 0) + 1;
    }
    
    cities['TOTAL'] = allParties.length;
    return cities;
  }

  // Get parties with GST
  Future<List<Party>> getPartiesWithGst() =>
      (select(parties)..where((tbl) => tbl.gst.isNotNull())).get();

  // Get parties without GST
  Future<List<Party>> getPartiesWithoutGst() =>
      (select(parties)..where((tbl) => tbl.gst.isNull())).get();
}
