import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/domain/services/location_tracking_service.dart';
import 'package:tranzfort_tms/domain/services/poi_service.dart';
import 'package:tranzfort_tms/presentation/providers/database_provider.dart';

/// Location Tracking Service Provider
final locationTrackingServiceProvider = Provider<LocationTrackingService>((ref) {
  final database = ref.watch(databaseProvider);
  return LocationTrackingService(database);
});

/// POI Service Provider
final poiServiceProvider = Provider<PoiService>((ref) {
  return PoiService();
});

/// Current Location Provider
final currentLocationProvider = FutureProvider<Position?>((ref) async {
  final service = ref.watch(locationTrackingServiceProvider);
  return await service.getCurrentLocation();
});

/// Tracking Status Provider
final trackingStatusProvider = StateProvider<TrackingStatus>((ref) {
  return TrackingStatus(
    isTracking: false,
    tripId: null,
  );
});

/// GPS Breadcrumbs Provider for a specific trip
final gpsBreadcrumbsProvider = FutureProvider.family<List<GpsBreadcrumb>, String>((ref, tripId) async {
  final service = ref.watch(locationTrackingServiceProvider);
  return await service.getBreadcrumbs(tripId);
});

/// Distance Traveled Provider for a specific trip
final distanceTraveledProvider = FutureProvider.family<double, String>((ref, tripId) async {
  final service = ref.watch(locationTrackingServiceProvider);
  return await service.calculateDistanceTraveled(tripId);
});

/// Nearby Fuel Pumps Provider
final nearbyFuelPumpsProvider = FutureProvider.family<List<PointOfInterest>, LocationParams>((ref, params) async {
  final service = ref.watch(poiServiceProvider);
  return await service.getNearbyFuelPumps(
    latitude: params.latitude,
    longitude: params.longitude,
    radiusKm: params.radiusKm,
  );
});

/// Nearby Service Centers Provider
final nearbyServiceCentersProvider = FutureProvider.family<List<PointOfInterest>, LocationParams>((ref, params) async {
  final service = ref.watch(poiServiceProvider);
  return await service.getNearbyServiceCenters(
    latitude: params.latitude,
    longitude: params.longitude,
    radiusKm: params.radiusKm,
  );
});

/// All Nearby POIs Provider
final allNearbyPoisProvider = FutureProvider.family<List<PointOfInterest>, LocationParams>((ref, params) async {
  final service = ref.watch(poiServiceProvider);
  return await service.getAllNearbyPois(
    latitude: params.latitude,
    longitude: params.longitude,
    radiusKm: params.radiusKm,
  );
});

/// Tracking Status Model
class TrackingStatus {
  final bool isTracking;
  final String? tripId;

  TrackingStatus({
    required this.isTracking,
    this.tripId,
  });

  TrackingStatus copyWith({
    bool? isTracking,
    String? tripId,
  }) {
    return TrackingStatus(
      isTracking: isTracking ?? this.isTracking,
      tripId: tripId ?? this.tripId,
    );
  }
}

/// Location Parameters Model
class LocationParams {
  final double latitude;
  final double longitude;
  final double radiusKm;

  LocationParams({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 10.0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationParams &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.radiusKm == radiusKm;
  }

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ radiusKm.hashCode;
}
