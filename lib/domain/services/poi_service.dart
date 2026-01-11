import 'package:geolocator/geolocator.dart';

/// Point of Interest Service
/// Manages offline POI data for fuel pumps, service centers, etc.
class PoiService {
  // Offline POI data - In production, this would be loaded from a local database
  // For now, using sample data for major Indian highways
  
  static final List<PointOfInterest> _fuelPumps = [
    // NH1 (Delhi-Amritsar)
    PointOfInterest(
      id: 'fp_001',
      name: 'Indian Oil Petrol Pump',
      type: PoiType.fuelPump,
      latitude: 28.7041,
      longitude: 77.1025,
      address: 'GT Karnal Road, Delhi',
      phone: '+91-11-27654321',
    ),
    PointOfInterest(
      id: 'fp_002',
      name: 'HP Petrol Pump',
      type: PoiType.fuelPump,
      latitude: 29.9457,
      longitude: 76.8178,
      address: 'Panipat, Haryana',
      phone: '+91-180-2654321',
    ),
    PointOfInterest(
      id: 'fp_003',
      name: 'Bharat Petroleum',
      type: PoiType.fuelPump,
      latitude: 30.3398,
      longitude: 76.3869,
      address: 'Ambala, Haryana',
      phone: '+91-171-2654321',
    ),
    
    // NH2 (Delhi-Kolkata)
    PointOfInterest(
      id: 'fp_004',
      name: 'Reliance Petrol Pump',
      type: PoiType.fuelPump,
      latitude: 27.1767,
      longitude: 78.0081,
      address: 'Agra, Uttar Pradesh',
      phone: '+91-562-2654321',
    ),
    PointOfInterest(
      id: 'fp_005',
      name: 'Shell Petrol Pump',
      type: PoiType.fuelPump,
      latitude: 25.4358,
      longitude: 81.8463,
      address: 'Prayagraj, Uttar Pradesh',
      phone: '+91-532-2654321',
    ),
  ];

  static final List<PointOfInterest> _serviceCenters = [
    PointOfInterest(
      id: 'sc_001',
      name: 'Tata Motors Service Center',
      type: PoiType.serviceCenter,
      latitude: 28.6139,
      longitude: 77.2090,
      address: 'Mayur Vihar, Delhi',
      phone: '+91-11-22654321',
    ),
    PointOfInterest(
      id: 'sc_002',
      name: 'Ashok Leyland Service',
      type: PoiType.serviceCenter,
      latitude: 29.9457,
      longitude: 76.8378,
      address: 'Panipat, Haryana',
      phone: '+91-180-2754321',
    ),
    PointOfInterest(
      id: 'sc_003',
      name: 'Mahindra Service Center',
      type: PoiType.serviceCenter,
      latitude: 27.1767,
      longitude: 78.0281,
      address: 'Agra, Uttar Pradesh',
      phone: '+91-562-2754321',
    ),
  ];

  /// Get nearby fuel pumps within specified radius
  Future<List<PointOfInterest>> getNearbyFuelPumps({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    return _getPoiWithinRadius(
      pois: _fuelPumps,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  /// Get nearby service centers within specified radius
  Future<List<PointOfInterest>> getNearbyServiceCenters({
    required double latitude,
    required double longitude,
    double radiusKm = 20.0,
  }) async {
    return _getPoiWithinRadius(
      pois: _serviceCenters,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  /// Get all POIs within radius
  Future<List<PointOfInterest>> getAllNearbyPois({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
  }) async {
    final allPois = [..._fuelPumps, ..._serviceCenters];
    return _getPoiWithinRadius(
      pois: allPois,
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
    );
  }

  /// Filter POIs within radius
  List<PointOfInterest> _getPoiWithinRadius({
    required List<PointOfInterest> pois,
    required double latitude,
    required double longitude,
    required double radiusKm,
  }) {
    final nearbyPois = <PointOfInterest>[];

    for (final poi in pois) {
      final distance = Geolocator.distanceBetween(
        latitude,
        longitude,
        poi.latitude,
        poi.longitude,
      );

      final distanceKm = distance / 1000;

      if (distanceKm <= radiusKm) {
        nearbyPois.add(poi.copyWith(distanceKm: distanceKm));
      }
    }

    // Sort by distance
    nearbyPois.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));

    return nearbyPois;
  }

  /// Get POI by ID
  PointOfInterest? getPoiById(String id) {
    final allPois = [..._fuelPumps, ..._serviceCenters];
    try {
      return allPois.firstWhere((poi) => poi.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get all fuel pumps
  List<PointOfInterest> getAllFuelPumps() => _fuelPumps;

  /// Get all service centers
  List<PointOfInterest> getAllServiceCenters() => _serviceCenters;
}

/// POI Type Enum
enum PoiType {
  fuelPump,
  serviceCenter,
  restaurant,
  hotel,
  parking,
  tollBooth,
}

/// Point of Interest Model
class PointOfInterest {
  final String id;
  final String name;
  final PoiType type;
  final double latitude;
  final double longitude;
  final String address;
  final String? phone;
  final double? distanceKm;

  PointOfInterest({
    required this.id,
    required this.name,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phone,
    this.distanceKm,
  });

  PointOfInterest copyWith({
    String? id,
    String? name,
    PoiType? type,
    double? latitude,
    double? longitude,
    String? address,
    String? phone,
    double? distanceKm,
  }) {
    return PointOfInterest(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      distanceKm: distanceKm ?? this.distanceKm,
    );
  }

  String get typeLabel {
    switch (type) {
      case PoiType.fuelPump:
        return 'Fuel Pump';
      case PoiType.serviceCenter:
        return 'Service Center';
      case PoiType.restaurant:
        return 'Restaurant';
      case PoiType.hotel:
        return 'Hotel';
      case PoiType.parking:
        return 'Parking';
      case PoiType.tollBooth:
        return 'Toll Booth';
    }
  }
}
