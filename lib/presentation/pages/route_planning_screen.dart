import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' show Marker;
import '../providers/map_provider.dart';
import '../widgets/map_view_widget.dart';
import '../../domain/services/map_service.dart';

/// Route Planning Screen
/// Allows users to plan routes, calculate distance, and estimate costs
class RoutePlanningScreen extends ConsumerStatefulWidget {
  final String? fromLocation;
  final String? toLocation;

  const RoutePlanningScreen({
    super.key,
    this.fromLocation,
    this.toLocation,
  });

  @override
  ConsumerState<RoutePlanningScreen> createState() => _RoutePlanningScreenState();
}

class _RoutePlanningScreenState extends ConsumerState<RoutePlanningScreen> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final List<LatLng> _waypoints = [];
  
  LatLng? _startPoint;
  LatLng? _endPoint;
  RouteCalculation? _routeCalculation;

  @override
  void initState() {
    super.initState();
    if (widget.fromLocation != null) {
      _fromController.text = widget.fromLocation!;
    }
    if (widget.toLocation != null) {
      _toController.text = widget.toLocation!;
    }
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _calculateRoute() {
    if (_startPoint == null || _endPoint == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end locations on the map'),
        ),
      );
      return;
    }

    final mapService = ref.read(mapServiceProvider);
    final calculation = mapService.calculateRoute(
      start: _startPoint!,
      end: _endPoint!,
      waypoints: _waypoints.isNotEmpty ? _waypoints : null,
    );

    setState(() {
      _routeCalculation = calculation;
    });
  }

  void _addWaypoint(LatLng point) {
    setState(() {
      _waypoints.add(point);
    });
  }

  void _removeWaypoint(int index) {
    setState(() {
      _waypoints.removeAt(index);
    });
  }

  void _clearRoute() {
    setState(() {
      _startPoint = null;
      _endPoint = null;
      _waypoints.clear();
      _routeCalculation = null;
    });
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];
    
    if (_startPoint != null) {
      markers.add(createStartMarker(_startPoint!));
    }
    
    if (_endPoint != null) {
      markers.add(createEndMarker(_endPoint!));
    }
    
    for (int i = 0; i < _waypoints.length; i++) {
      markers.add(createWaypointMarker(_waypoints[i], i));
    }
    
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocation = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Planning'),
        actions: [
          if (_routeCalculation != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearRoute,
              tooltip: 'Clear Route',
            ),
        ],
      ),
      body: Column(
        children: [
          // Route Calculation Summary
          if (_routeCalculation != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.route,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Route Summary',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildSummaryChip(
                        icon: Icons.straighten,
                        label: 'Distance',
                        value: _routeCalculation!.formattedDistance,
                        color: theme.colorScheme.primary,
                      ),
                      _buildSummaryChip(
                        icon: Icons.access_time,
                        label: 'Duration',
                        value: _routeCalculation!.formattedDuration,
                        color: theme.colorScheme.secondary,
                      ),
                      _buildSummaryChip(
                        icon: Icons.local_gas_station,
                        label: 'Fuel Cost',
                        value: _routeCalculation!.formattedFuelCost,
                        color: Colors.orange,
                      ),
                      _buildSummaryChip(
                        icon: Icons.toll,
                        label: 'Toll Cost',
                        value: _routeCalculation!.formattedTollCost,
                        color: Colors.purple,
                      ),
                      _buildSummaryChip(
                        icon: Icons.attach_money,
                        label: 'Total Cost',
                        value: _routeCalculation!.formattedTotalCost,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Map View
          Expanded(
            child: currentLocation.when(
              data: (location) => MapViewWidget(
                center: location ?? LatLng(28.6139, 77.2090),
                zoom: 6.0,
                routePoints: _routeCalculation?.waypoints,
                markers: _buildMarkers(),
                onTap: (point) {
                  if (_startPoint == null) {
                    setState(() {
                      _startPoint = point;
                    });
                  } else if (_endPoint == null) {
                    setState(() {
                      _endPoint = point;
                    });
                    _calculateRoute();
                  }
                },
                onLongPress: (point) {
                  if (_startPoint != null && _endPoint != null) {
                    _addWaypoint(point);
                    _calculateRoute();
                  }
                },
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unable to load map',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Instructions Panel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Instructions:',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInstruction('1. Tap on map to set start location (green marker)'),
                _buildInstruction('2. Tap again to set end location (red marker)'),
                _buildInstruction('3. Long press to add waypoints (blue markers)'),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _startPoint != null && _endPoint != null
                            ? _calculateRoute
                            : null,
                        icon: const Icon(Icons.calculate),
                        label: const Text('Recalculate'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearRoute,
                        icon: const Icon(Icons.clear_all),
                        label: const Text('Clear All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 6,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
