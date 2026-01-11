import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tranzfort_tms/domain/services/map_service.dart';

/// Map Service Provider
final mapServiceProvider = Provider<MapService>((ref) {
  return MapService();
});

/// Current Location Provider
final currentLocationProvider = FutureProvider<LatLng?>((ref) async {
  final service = ref.watch(mapServiceProvider);
  return await service.getCurrentLocation();
});

/// Location Permission Provider
final locationPermissionProvider = FutureProvider<LocationPermission>((ref) async {
  final service = ref.watch(mapServiceProvider);
  return await service.checkLocationPermission();
});

/// Location Service Status Provider
final locationServiceStatusProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(mapServiceProvider);
  return await service.isLocationServiceEnabled();
});

/// Route Calculation Provider
final routeCalculationProvider = FutureProvider.family<RouteCalculation?, RouteParams>((ref, params) async {
  final service = ref.watch(mapServiceProvider);
  
  if (params.start == null || params.end == null) {
    return null;
  }

  return service.calculateRoute(
    start: params.start!,
    end: params.end!,
    waypoints: params.waypoints,
    avgSpeedKmh: params.avgSpeedKmh,
    mileage: params.mileage,
    fuelPricePerLiter: params.fuelPricePerLiter,
    tollRatePerKm: params.tollRatePerKm,
  );
});

/// GPS Tracking State Provider
final gpsTrackingProvider = StateNotifierProvider<GpsTrackingNotifier, GpsTrackingState>((ref) {
  final service = ref.watch(mapServiceProvider);
  return GpsTrackingNotifier(service);
});

/// GPS Tracking State
class GpsTrackingState {
  final bool isTracking;
  final List<LatLng> breadcrumbs;
  final LatLng? currentPosition;
  final double totalDistanceKm;

  GpsTrackingState({
    this.isTracking = false,
    this.breadcrumbs = const [],
    this.currentPosition,
    this.totalDistanceKm = 0,
  });

  GpsTrackingState copyWith({
    bool? isTracking,
    List<LatLng>? breadcrumbs,
    LatLng? currentPosition,
    double? totalDistanceKm,
  }) {
    return GpsTrackingState(
      isTracking: isTracking ?? this.isTracking,
      breadcrumbs: breadcrumbs ?? this.breadcrumbs,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDistanceKm: totalDistanceKm ?? this.totalDistanceKm,
    );
  }
}

/// GPS Tracking Notifier
class GpsTrackingNotifier extends StateNotifier<GpsTrackingState> {
  final MapService _mapService;
  Stream<Position>? _positionStream;

  GpsTrackingNotifier(this._mapService) : super(GpsTrackingState());

  /// Start GPS tracking
  void startTracking() {
    if (state.isTracking) return;

    state = state.copyWith(isTracking: true);

    _positionStream = _mapService.trackLocation(intervalSeconds: 300);
    _positionStream!.listen((position) {
      final newPosition = LatLng(position.latitude, position.longitude);
      final newBreadcrumbs = [...state.breadcrumbs, newPosition];
      
      // Calculate distance from last position
      double additionalDistance = 0;
      if (state.currentPosition != null) {
        additionalDistance = _mapService.calculateDistance(
          state.currentPosition!,
          newPosition,
        );
      }

      state = state.copyWith(
        currentPosition: newPosition,
        breadcrumbs: newBreadcrumbs,
        totalDistanceKm: state.totalDistanceKm + additionalDistance,
      );
    });
  }

  /// Stop GPS tracking
  void stopTracking() {
    state = state.copyWith(isTracking: false);
  }

  /// Reset tracking data
  void resetTracking() {
    state = GpsTrackingState();
  }

  /// Get breadcrumbs for a specific trip
  List<LatLng> getBreadcrumbs() {
    return state.breadcrumbs;
  }
}

/// Route Parameters for family provider
class RouteParams {
  final LatLng? start;
  final LatLng? end;
  final List<LatLng>? waypoints;
  final double avgSpeedKmh;
  final double mileage;
  final double fuelPricePerLiter;
  final double tollRatePerKm;

  RouteParams({
    this.start,
    this.end,
    this.waypoints,
    this.avgSpeedKmh = 50.0,
    this.mileage = 5.0,
    this.fuelPricePerLiter = 100.0,
    this.tollRatePerKm = 2.0,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RouteParams &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end &&
          _listEquals(waypoints, other.waypoints) &&
          avgSpeedKmh == other.avgSpeedKmh &&
          mileage == other.mileage &&
          fuelPricePerLiter == other.fuelPricePerLiter &&
          tollRatePerKm == other.tollRatePerKm;

  @override
  int get hashCode =>
      start.hashCode ^
      end.hashCode ^
      (waypoints?.hashCode ?? 0) ^
      avgSpeedKmh.hashCode ^
      mileage.hashCode ^
      fuelPricePerLiter.hashCode ^
      tollRatePerKm.hashCode;

  bool _listEquals(List<LatLng>? a, List<LatLng>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
