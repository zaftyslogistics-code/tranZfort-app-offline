import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:drift/drift.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Location Tracking Service
/// Handles GPS tracking for active trips with background support
class LocationTrackingService {
  final AppDatabase _database;
  StreamSubscription<Position>? _positionStream;
  String? _activeTrackingTripId;
  bool _isTracking = false;

  LocationTrackingService(this._database);

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location
  Future<Position?> getCurrentLocation() async {
    try {
      final permission = await checkPermission();
      
      if (permission == LocationPermission.denied) {
        final newPermission = await requestPermission();
        if (newPermission == LocationPermission.denied ||
            newPermission == LocationPermission.deniedForever) {
          return null;
        }
      }

      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Start tracking for a trip
  Future<bool> startTracking(String tripId) async {
    if (_isTracking) {
      print('Already tracking trip: $_activeTrackingTripId');
      return false;
    }

    try {
      final permission = await checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print('Location permission denied');
        return false;
      }

      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location service not enabled');
        return false;
      }

      _activeTrackingTripId = tripId;
      _isTracking = true;

      // Configure location settings
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // Update every 50 meters
      );

      // Start listening to position updates
      _positionStream = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          _onLocationUpdate(position);
        },
        onError: (error) {
          print('Error in location stream: $error');
        },
      );

      print('Started tracking for trip: $tripId');
      return true;
    } catch (e) {
      print('Error starting tracking: $e');
      _isTracking = false;
      _activeTrackingTripId = null;
      return false;
    }
  }

  /// Stop tracking
  Future<void> stopTracking() async {
    if (!_isTracking) {
      return;
    }

    await _positionStream?.cancel();
    _positionStream = null;
    _isTracking = false;
    
    print('Stopped tracking for trip: $_activeTrackingTripId');
    _activeTrackingTripId = null;
  }

  /// Handle location update
  Future<void> _onLocationUpdate(Position position) async {
    if (!_isTracking || _activeTrackingTripId == null) {
      return;
    }

    try {
      // Store breadcrumb in database
      await _database.into(_database.gpsBreadcrumbs).insert(
        GpsBreadcrumbsCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          tripId: _activeTrackingTripId!,
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: DateTime.now(),
          speed: position.speed,
          accuracy: position.accuracy,
        ),
      );

      print('Stored breadcrumb: ${position.latitude}, ${position.longitude}');
    } catch (e) {
      print('Error storing breadcrumb: $e');
    }
  }

  /// Get breadcrumbs for a trip
  Future<List<GpsBreadcrumb>> getBreadcrumbs(String tripId) async {
    return await (_database.select(_database.gpsBreadcrumbs)
          ..where((tbl) => tbl.tripId.equals(tripId))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.timestamp)]))
        .get();
  }

  /// Calculate total distance traveled for a trip
  Future<double> calculateDistanceTraveled(String tripId) async {
    final breadcrumbs = await getBreadcrumbs(tripId);
    
    if (breadcrumbs.length < 2) {
      return 0.0;
    }

    double totalDistance = 0.0;
    
    for (int i = 0; i < breadcrumbs.length - 1; i++) {
      final current = breadcrumbs[i];
      final next = breadcrumbs[i + 1];
      
      final distance = Geolocator.distanceBetween(
        current.latitude,
        current.longitude,
        next.latitude,
        next.longitude,
      );
      
      totalDistance += distance;
    }

    return totalDistance / 1000; // Convert to kilometers
  }

  /// Calculate route deviation
  Future<RouteDeviation> calculateRouteDeviation(
    String tripId,
    List<Position> plannedRoute,
  ) async {
    final breadcrumbs = await getBreadcrumbs(tripId);
    
    if (breadcrumbs.isEmpty || plannedRoute.isEmpty) {
      return RouteDeviation(
        maxDeviation: 0.0,
        averageDeviation: 0.0,
        deviationPoints: [],
      );
    }

    final deviationPoints = <DeviationPoint>[];
    double totalDeviation = 0.0;
    double maxDeviation = 0.0;

    for (final breadcrumb in breadcrumbs) {
      // Find nearest point on planned route
      double minDistance = double.infinity;
      
      for (final plannedPoint in plannedRoute) {
        final distance = Geolocator.distanceBetween(
          breadcrumb.latitude,
          breadcrumb.longitude,
          plannedPoint.latitude,
          plannedPoint.longitude,
        );
        
        if (distance < minDistance) {
          minDistance = distance;
        }
      }

      final deviationKm = minDistance / 1000;
      totalDeviation += deviationKm;
      
      if (deviationKm > maxDeviation) {
        maxDeviation = deviationKm;
      }

      if (deviationKm > 5.0) { // Deviation > 5km
        deviationPoints.add(DeviationPoint(
          latitude: breadcrumb.latitude,
          longitude: breadcrumb.longitude,
          deviationKm: deviationKm,
          timestamp: breadcrumb.timestamp,
        ));
      }
    }

    return RouteDeviation(
      maxDeviation: maxDeviation,
      averageDeviation: breadcrumbs.isNotEmpty ? totalDeviation / breadcrumbs.length : 0.0,
      deviationPoints: deviationPoints,
    );
  }

  /// Get current tracking status
  bool get isTracking => _isTracking;
  
  /// Get active tracking trip ID
  String? get activeTrackingTripId => _activeTrackingTripId;

  /// Dispose resources
  void dispose() {
    _positionStream?.cancel();
  }
}

/// Route Deviation Model
class RouteDeviation {
  final double maxDeviation;
  final double averageDeviation;
  final List<DeviationPoint> deviationPoints;

  RouteDeviation({
    required this.maxDeviation,
    required this.averageDeviation,
    required this.deviationPoints,
  });
}

/// Deviation Point Model
class DeviationPoint {
  final double latitude;
  final double longitude;
  final double deviationKm;
  final DateTime timestamp;

  DeviationPoint({
    required this.latitude,
    required this.longitude,
    required this.deviationKm,
    required this.timestamp,
  });
}
