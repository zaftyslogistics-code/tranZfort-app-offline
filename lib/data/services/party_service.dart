import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../database.dart';
import '../repositories/party_repository.dart';

class PartyService {
  final PartyRepository _repository;
  final Uuid _uuid = const Uuid();

  PartyService(this._repository);

  // Get all parties
  Future<List<Party>> getAllParties() => _repository.getAllParties();

  // Get party by ID
  Future<Party?> getPartyById(String id) => _repository.getPartyById(id);

  // Create new party
  Future<void> createParty({
    required String name,
    required String mobile,
    required String city,
    String? gst,
    String? notes,
  }) async {
    final party = PartiesCompanion.insert(
      id: _uuid.v4(),
      name: name,
      mobile: mobile,
      city: city,
      gst: Value(gst),
      notes: Value(notes),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _repository.addParty(party);
  }

  // Update party
  Future<void> updateParty({
    required String id,
    String? name,
    String? mobile,
    String? city,
    String? gst,
    String? notes,
  }) async {
    final existingParty = await _repository.getPartyById(id);
    if (existingParty == null) {
      throw Exception('Party not found');
    }

    final updatedParty = existingParty.copyWith(
      name: name ?? existingParty.name,
      mobile: mobile ?? existingParty.mobile,
      city: city ?? existingParty.city,
      gst: Value(gst ?? existingParty.gst),
      notes: Value(notes ?? existingParty.notes),
      updatedAt: DateTime.now(),
    );

    await _repository.updateParty(updatedParty);
  }

  // Delete party
  Future<void> deleteParty(String id) async {
    final party = await _repository.getPartyById(id);
    if (party == null) {
      throw Exception('Party not found');
    }

    // TODO: Check if party is linked to any trips or payments
    // For now, allow deletion

    await _repository.deleteParty(id);
  }

  // Search parties
  Future<List<Party>> searchParties(String query) => _repository.searchParties(query);

  // Get parties by city
  Future<List<Party>> getPartiesByCity(String city) => _repository.getPartiesByCity(city);

  // Get unique cities
  Future<List<String>> getUniqueCities() => _repository.getUniqueCities();

  // Get party statistics
  Future<Map<String, int>> getPartyStatistics() => _repository.getPartyStatistics();

  // Check if mobile number is unique
  Future<bool> isMobileUnique(String mobile, {String? excludeId}) async {
    return await _repository.isMobileUnique(mobile, excludeId: excludeId);
  }

  // Check if GST number is unique
  Future<bool> isGstUnique(String gst, {String? excludeId}) async {
    return await _repository.isGstUnique(gst, excludeId: excludeId);
  }

  // Get parties with GST
  Future<List<Party>> getPartiesWithGst() => _repository.getPartiesWithGst();

  // Get parties without GST
  Future<List<Party>> getPartiesWithoutGst() => _repository.getPartiesWithoutGst();

  // Validate GST number format
  bool isValidGst(String gst) {
    // Basic GST validation (Indian GST format: 2 digits + 1 letter + 3 digits + 1 letter + 4 digits + 1 letter + 1 digit + 1 letter + 1 digit)
    final gstRegex = RegExp(r'^[0-9]{2}[A-Z]{3}[0-9]{5}[A-Z]{1}[0-9]{1}[A-Z]{1}[0-9]{1}$');
    return gstRegex.hasMatch(gst);
  }

  // Validate mobile number
  bool isValidMobile(String mobile) {
    // Basic mobile validation (10 digits, optional country code)
    final mobileRegex = RegExp(r'^(\+91[-\s]?)?[0-9]{10}$');
    return mobileRegex.hasMatch(mobile);
  }

  // Format mobile number
  String formatMobileNumber(String mobile) {
    // Remove all non-digit characters
    final digits = mobile.replaceAll(RegExp(r'[^\d]'), '');
    
    // If 10 digits, add +91 prefix
    if (digits.length == 10) {
      return '+91-$digits';
    }
    
    // If 11 digits and starts with 0, remove 0 and add +91
    if (digits.length == 11 && digits.startsWith('0')) {
      return '+91-${digits.substring(1)}';
    }
    
    // If 12 digits and starts with 91, format as +91
    if (digits.length == 12 && digits.startsWith('91')) {
      return '+91-${digits.substring(2)}';
    }
    
    return mobile;
  }

  // Get party performance metrics
  Future<Map<String, dynamic>> getPartyPerformance(String partyId) async {
    // TODO: Implement when trips and payments modules are ready
    // This will include metrics like:
    // - Number of trips completed
    // - Total revenue
    // - Average payment time
    // - Outstanding payments
    
    return {
      'totalTrips': 0,
      'totalRevenue': 0.0,
      'avgPaymentTime': 0.0,
      'outstandingPayments': 0.0,
    };
  }

  // Get party contact information summary
  Map<String, String> getPartyContactSummary(Party party) {
    return {
      'name': party.name,
      'mobile': formatMobileNumber(party.mobile),
      'city': party.city,
      'gst': party.gst ?? 'Not Available',
      'hasGst': party.gst != null ? 'Yes' : 'No',
    };
  }
}
