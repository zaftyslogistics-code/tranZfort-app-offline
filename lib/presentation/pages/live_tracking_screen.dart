import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/presentation/providers/database_provider.dart';
import 'package:tranzfort_tms/presentation/providers/location_tracking_provider.dart';

// Provider for single trip
final tripProvider = FutureProvider.family<Trip, String>((ref, tripId) async {
  final database = ref.watch(databaseProvider);
  return await (database.select(database.trips)
        ..where((tbl) => tbl.id.equals(tripId)))
      .getSingle();
});

/// Live Tracking Screen
/// Shows real-time GPS tracking for an active trip
class LiveTrackingScreen extends ConsumerStatefulWidget {
  final String tripId;

  const LiveTrackingScreen({
    super.key,
    required this.tripId,
  });

  @override
  ConsumerState<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends ConsumerState<LiveTrackingScreen> {
  final MapController _mapController = MapController();
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _checkTrackingStatus();
  }

  void _checkTrackingStatus() {
    final service = ref.read(locationTrackingServiceProvider);
    setState(() {
      _isTracking = service.isTracking && service.activeTrackingTripId == widget.tripId;
    });
  }

  Future<void> _startTracking() async {
    final service = ref.read(locationTrackingServiceProvider);
    final success = await service.startTracking(widget.tripId);
    
    if (success) {
      setState(() {
        _isTracking = true;
      });
      
      ref.read(trackingStatusProvider.notifier).state = TrackingStatus(
        isTracking: true,
        tripId: widget.tripId,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GPS tracking started')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to start GPS tracking')),
        );
      }
    }
  }

  Future<void> _stopTracking() async {
    final service = ref.read(locationTrackingServiceProvider);
    await service.stopTracking();
    
    setState(() {
      _isTracking = false;
    });
    
    ref.read(trackingStatusProvider.notifier).state = TrackingStatus(
      isTracking: false,
      tripId: null,
    );
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GPS tracking stopped')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripAsync = ref.watch(tripProvider(widget.tripId));
    final breadcrumbsAsync = ref.watch(gpsBreadcrumbsProvider(widget.tripId));
    final distanceAsync = ref.watch(distanceTraveledProvider(widget.tripId));
    final currentLocationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Tracking'),
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
            onPressed: _isTracking ? _stopTracking : _startTracking,
            tooltip: _isTracking ? 'Stop Tracking' : 'Start Tracking',
          ),
        ],
      ),
      body: Column(
        children: [
          // Trip Info Card
          tripAsync.when(
            data: (trip) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.local_shipping,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${trip.fromLocation} → ${trip.toLocation}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isTracking
                              ? Colors.green.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _isTracking ? Icons.gps_fixed : Icons.gps_off,
                              size: 14,
                              color: _isTracking ? Colors.green : Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _isTracking ? 'Tracking' : 'Stopped',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _isTracking ? Colors.green : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  distanceAsync.when(
                    data: (distance) => Text(
                      'Distance Traveled: ${distance.toStringAsFixed(2)} km',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    loading: () => const Text('Calculating distance...'),
                    error: (_, __) => const Text('Distance: 0.0 km'),
                  ),
                ],
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),

          // Map
          Expanded(
            child: breadcrumbsAsync.when(
              data: (breadcrumbs) {
                final points = breadcrumbs
                    .map((b) => LatLng(b.latitude, b.longitude))
                    .toList();

                // Center map on latest position or current location
                LatLng? center;
                if (points.isNotEmpty) {
                  center = points.last;
                } else {
                  currentLocationAsync.whenData((pos) {
                    if (pos != null) {
                      center = LatLng(pos.latitude, pos.longitude);
                    }
                  });
                }

                return FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center ?? const LatLng(28.6139, 77.2090), // Delhi
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.tranzfort.tms',
                    ),
                    if (points.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: points,
                            strokeWidth: 4.0,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    if (points.isNotEmpty)
                      MarkerLayer(
                        markers: [
                          // Start marker
                          Marker(
                            point: points.first,
                            width: 40,
                            height: 40,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 40,
                            ),
                          ),
                          // Current position marker
                          Marker(
                            point: points.last,
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.navigation,
                              color: theme.colorScheme.primary,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading map: $error'),
                  ],
                ),
              ),
            ),
          ),

          // Stats Bar
          breadcrumbsAsync.when(
            data: (breadcrumbs) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outline.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    icon: Icons.location_on,
                    label: 'Points',
                    value: breadcrumbs.length.toString(),
                  ),
                  _buildStatItem(
                    context,
                    icon: Icons.speed,
                    label: 'Avg Speed',
                    value: breadcrumbs.isNotEmpty
                        ? '${(breadcrumbs.map((b) => b.speed).reduce((a, b) => a + b) / breadcrumbs.length * 3.6).toStringAsFixed(1)} km/h'
                        : '0 km/h',
                  ),
                  _buildStatItem(
                    context,
                    icon: Icons.access_time,
                    label: 'Duration',
                    value: breadcrumbs.length >= 2
                        ? _formatDuration(
                            breadcrumbs.last.timestamp.difference(breadcrumbs.first.timestamp),
                          )
                        : '0m',
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentLocationAsync.whenData((pos) {
            if (pos != null) {
              _mapController.move(
                LatLng(pos.latitude, pos.longitude),
                15.0,
              );
            }
          });
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
