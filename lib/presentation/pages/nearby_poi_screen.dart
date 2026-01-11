import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tranzfort_tms/domain/services/poi_service.dart';
import 'package:tranzfort_tms/presentation/providers/location_tracking_provider.dart';

/// Nearby POI Screen
/// Shows nearby fuel pumps and service centers on a map
class NearbyPoiScreen extends ConsumerStatefulWidget {
  const NearbyPoiScreen({super.key});

  @override
  ConsumerState<NearbyPoiScreen> createState() => _NearbyPoiScreenState();
}

class _NearbyPoiScreenState extends ConsumerState<NearbyPoiScreen> {
  final MapController _mapController = MapController();
  PoiType _selectedType = PoiType.fuelPump;
  double _radiusKm = 10.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentLocationAsync = ref.watch(currentLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        actions: [
          PopupMenuButton<PoiType>(
            icon: const Icon(Icons.filter_list),
            onSelected: (type) {
              setState(() {
                _selectedType = type;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: PoiType.fuelPump,
                child: Row(
                  children: [
                    Icon(Icons.local_gas_station),
                    SizedBox(width: 8),
                    Text('Fuel Pumps'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: PoiType.serviceCenter,
                child: Row(
                  children: [
                    Icon(Icons.build),
                    SizedBox(width: 8),
                    Text('Service Centers'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: currentLocationAsync.when(
        data: (position) {
          if (position == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Location not available'),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.refresh(currentLocationProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final locationParams = LocationParams(
            latitude: position.latitude,
            longitude: position.longitude,
            radiusKm: _radiusKm,
          );

          final poisAsync = _selectedType == PoiType.fuelPump
              ? ref.watch(nearbyFuelPumpsProvider(locationParams))
              : ref.watch(nearbyServiceCentersProvider(locationParams));

          return Column(
            children: [
              // Filter Bar
              Container(
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
                          _selectedType == PoiType.fuelPump
                              ? Icons.local_gas_station
                              : Icons.build,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _selectedType == PoiType.fuelPump
                              ? 'Fuel Pumps'
                              : 'Service Centers',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        poisAsync.when(
                          data: (pois) => Chip(
                            label: Text('${pois.length} found'),
                            backgroundColor: theme.colorScheme.primaryContainer,
                          ),
                          loading: () => const SizedBox(),
                          error: (_, __) => const SizedBox(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text('Radius: '),
                        Expanded(
                          child: Slider(
                            value: _radiusKm,
                            min: 5.0,
                            max: 50.0,
                            divisions: 9,
                            label: '${_radiusKm.toInt()} km',
                            onChanged: (value) {
                              setState(() {
                                _radiusKm = value;
                              });
                            },
                          ),
                        ),
                        Text('${_radiusKm.toInt()} km'),
                      ],
                    ),
                  ],
                ),
              ),

              // Map
              Expanded(
                child: poisAsync.when(
                  data: (pois) {
                    final currentPos = LatLng(position.latitude, position.longitude);

                    return FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: currentPos,
                        initialZoom: 12.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.tranzfort.tms',
                        ),
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: currentPos,
                              radius: _radiusKm * 1000,
                              useRadiusInMeter: true,
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderColor: theme.colorScheme.primary,
                              borderStrokeWidth: 2,
                            ),
                          ],
                        ),
                        MarkerLayer(
                          markers: [
                            // Current location marker
                            Marker(
                              point: currentPos,
                              width: 40,
                              height: 40,
                              child: Icon(
                                Icons.my_location,
                                color: theme.colorScheme.primary,
                                size: 40,
                              ),
                            ),
                            // POI markers
                            ...pois.map((poi) {
                              return Marker(
                                point: LatLng(poi.latitude, poi.longitude),
                                width: 40,
                                height: 40,
                                child: GestureDetector(
                                  onTap: () => _showPoiDetails(context, poi),
                                  child: Icon(
                                    poi.type == PoiType.fuelPump
                                        ? Icons.local_gas_station
                                        : Icons.build,
                                    color: poi.type == PoiType.fuelPump
                                        ? Colors.orange
                                        : Colors.blue,
                                    size: 32,
                                  ),
                                ),
                              );
                            }),
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
                        Text('Error loading POIs: $error'),
                      ],
                    ),
                  ),
                ),
              ),

              // POI List
              poisAsync.when(
                data: (pois) {
                  if (pois.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      child: const Text('No places found in this area'),
                    );
                  }

                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(
                        top: BorderSide(
                          color: theme.colorScheme.outline.withOpacity(0.2),
                        ),
                      ),
                    ),
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: pois.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final poi = pois[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: poi.type == PoiType.fuelPump
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.blue.withOpacity(0.2),
                            child: Icon(
                              poi.type == PoiType.fuelPump
                                  ? Icons.local_gas_station
                                  : Icons.build,
                              color: poi.type == PoiType.fuelPump
                                  ? Colors.orange
                                  : Colors.blue,
                            ),
                          ),
                          title: Text(
                            poi.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(poi.address),
                              if (poi.distanceKm != null)
                                Text(
                                  '${poi.distanceKm!.toStringAsFixed(1)} km away',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.directions),
                            onPressed: () {
                              _mapController.move(
                                LatLng(poi.latitude, poi.longitude),
                                15.0,
                              );
                            },
                          ),
                          onTap: () => _showPoiDetails(context, poi),
                        );
                      },
                    ),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
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
              Text('Error getting location: $error'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.refresh(currentLocationProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          currentLocationAsync.whenData((pos) {
            if (pos != null) {
              _mapController.move(
                LatLng(pos.latitude, pos.longitude),
                12.0,
              );
            }
          });
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }

  void _showPoiDetails(BuildContext context, PointOfInterest poi) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: poi.type == PoiType.fuelPump
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.blue.withOpacity(0.2),
                  child: Icon(
                    poi.type == PoiType.fuelPump
                        ? Icons.local_gas_station
                        : Icons.build,
                    color: poi.type == PoiType.fuelPump
                        ? Colors.orange
                        : Colors.blue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poi.name,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        poi.typeLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow(
              context,
              icon: Icons.location_on,
              label: 'Address',
              value: poi.address,
            ),
            if (poi.phone != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.phone,
                label: 'Phone',
                value: poi.phone!,
              ),
            ],
            if (poi.distanceKm != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.directions,
                label: 'Distance',
                value: '${poi.distanceKm!.toStringAsFixed(1)} km away',
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _mapController.move(
                    LatLng(poi.latitude, poi.longitude),
                    15.0,
                  );
                },
                icon: const Icon(Icons.directions),
                label: const Text('Show on Map'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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
