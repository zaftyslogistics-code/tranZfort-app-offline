import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// Map Service for route planning, distance calculation, and GPS tracking
class MapService {
  final Distance _distance = const Distance();

  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(LatLng start, LatLng end) {
    return _distance.as(LengthUnit.Kilometer, start, end);
  }

  /// Calculate estimated travel time based on distance
  /// Assumes average speed of 50 km/h for trucks
  Duration estimateTravelTime(double distanceKm, {double avgSpeedKmh = 50.0}) {
    final hours = distanceKm / avgSpeedKmh;
    return Duration(minutes: (hours * 60).round());
  }

  /// Estimate fuel consumption based on distance
  /// Default: 5 km/liter for trucks
  double estimateFuelConsumption(double distanceKm, {double mileage = 5.0}) {
    return distanceKm / mileage;
  }

  /// Estimate fuel cost
  double estimateFuelCost(double distanceKm, {double mileage = 5.0, double fuelPricePerLiter = 100.0}) {
    final fuelLiters = estimateFuelConsumption(distanceKm, mileage: mileage);
    return fuelLiters * fuelPricePerLiter;
  }

  /// Estimate toll cost based on distance
  /// Rough estimate: ₹2 per km for highways
  double estimateTollCost(double distanceKm, {double tollRatePerKm = 2.0}) {
    return distanceKm * tollRatePerKm;
  }

  /// Get current GPS location
  Future<LatLng?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();
        if (requested == LocationPermission.denied || requested == LocationPermission.deniedForever) {
          return null;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Calculate route with waypoints
  RouteCalculation calculateRoute({
    required LatLng start,
    required LatLng end,
    List<LatLng>? waypoints,
    double avgSpeedKmh = 50.0,
    double mileage = 5.0,
    double fuelPricePerLiter = 100.0,
    double tollRatePerKm = 2.0,
  }) {
    double totalDistance = 0;
    final List<LatLng> allPoints = [start, ...?waypoints, end];

    // Calculate total distance through all waypoints
    for (int i = 0; i < allPoints.length - 1; i++) {
      totalDistance += calculateDistance(allPoints[i], allPoints[i + 1]);
    }

    final duration = estimateTravelTime(totalDistance, avgSpeedKmh: avgSpeedKmh);
    final fuelLiters = estimateFuelConsumption(totalDistance, mileage: mileage);
    final fuelCost = estimateFuelCost(totalDistance, mileage: mileage, fuelPricePerLiter: fuelPricePerLiter);
    final tollCost = estimateTollCost(totalDistance, tollRatePerKm: tollRatePerKm);

    return RouteCalculation(
      distanceKm: totalDistance,
      duration: duration,
      fuelLiters: fuelLiters,
      fuelCost: fuelCost,
      tollCost: tollCost,
      totalCost: fuelCost + tollCost,
      waypoints: allPoints,
    );
  }

  /// Parse location string to coordinates (placeholder for geocoding)
  /// In a real implementation, this would use a geocoding service
  /// For now, returns null - will be enhanced with offline geocoding data
  Future<LatLng?> geocodeLocation(String locationName) async {
    // TODO: Implement offline geocoding with local database of cities/towns
    // For Phase 1, users will manually select locations on map or use GPS
    return null;
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Start tracking location in background
  /// Returns a stream of position updates
  Stream<Position> trackLocation({
    int intervalSeconds = 300, // 5 minutes default
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update every 100 meters
        timeLimit: Duration(seconds: intervalSeconds),
      ),
    );
  }

  /// Calculate route deviation
  /// Returns distance in meters from planned route
  double calculateRouteDeviation(LatLng currentPosition, List<LatLng> plannedRoute) {
    if (plannedRoute.isEmpty) return 0;

    // Find closest point on route
    double minDistance = double.infinity;
    
    for (final point in plannedRoute) {
      final distance = _distance.as(LengthUnit.Meter, currentPosition, point);
      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  /// Check if vehicle is within geofence
  bool isWithinGeofence(LatLng position, LatLng center, double radiusMeters) {
    final distance = _distance.as(LengthUnit.Meter, position, center);
    return distance <= radiusMeters;
  }
}

/// Route calculation result
class RouteCalculation {
  final double distanceKm;
  final Duration duration;
  final double fuelLiters;
  final double fuelCost;
  final double tollCost;
  final double totalCost;
  final List<LatLng> waypoints;

  RouteCalculation({
    required this.distanceKm,
    required this.duration,
    required this.fuelLiters,
    required this.fuelCost,
    required this.tollCost,
    required this.totalCost,
    required this.waypoints,
  });

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';
  
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get formattedFuelCost => '₹${fuelCost.toStringAsFixed(0)}';
  String get formattedTollCost => '₹${tollCost.toStringAsFixed(0)}';
  String get formattedTotalCost => '₹${totalCost.toStringAsFixed(0)}';
}
