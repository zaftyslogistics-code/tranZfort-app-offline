import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// Reusable Map View Widget
class MapViewWidget extends StatefulWidget {
  final LatLng? center;
  final double zoom;
  final List<LatLng>? routePoints;
  final List<Marker>? markers;
  final bool showCurrentLocation;
  final Function(LatLng)? onTap;
  final Function(LatLng)? onLongPress;

  const MapViewWidget({
    super.key,
    this.center,
    this.zoom = 13.0,
    this.routePoints,
    this.markers,
    this.showCurrentLocation = true,
    this.onTap,
    this.onLongPress,
  });

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: widget.center ?? LatLng(28.6139, 77.2090), // Default: New Delhi
        zoom: widget.zoom,
        minZoom: 3.0,
        maxZoom: 18.0,
        onTap: (tapPosition, point) {
          if (widget.onTap != null) {
            widget.onTap!(point);
          }
        },
        onLongPress: (tapPosition, point) {
          if (widget.onLongPress != null) {
            widget.onLongPress!(point);
          }
        },
      ),
      children: [
        // Tile Layer (OpenStreetMap)
        TileLayer(
          urlTemplate: isDark
              ? 'https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png'
              : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.tranzfort.tms',
          maxZoom: 19,
          // TODO: Add offline tile caching
        ),

        // Route Polyline
        if (widget.routePoints != null && widget.routePoints!.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.routePoints!,
                color: theme.colorScheme.primary,
                strokeWidth: 4.0,
                borderColor: Colors.white.withOpacity(0.3),
                borderStrokeWidth: 2.0,
              ),
            ],
          ),

        // Markers
        if (widget.markers != null && widget.markers!.isNotEmpty)
          MarkerLayer(
            markers: widget.markers!,
          ),

        // Attribution
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}

/// Create a marker for start location
Marker createStartMarker(LatLng position, {String? label}) {
  return Marker(
    point: position,
    width: 40,
    height: 40,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}

/// Create a marker for end location
Marker createEndMarker(LatLng position, {String? label}) {
  return Marker(
    point: position,
    width: 40,
    height: 40,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.flag,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}

/// Create a marker for waypoint
Marker createWaypointMarker(LatLng position, int index) {
  return Marker(
    point: position,
    width: 30,
    height: 30,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

/// Create a marker for current vehicle location
Marker createVehicleMarker(LatLng position) {
  return Marker(
    point: position,
    width: 40,
    height: 40,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.local_shipping,
        color: Colors.white,
        size: 24,
      ),
    ),
  );
}
