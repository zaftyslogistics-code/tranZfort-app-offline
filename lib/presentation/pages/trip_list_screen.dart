import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_provider.dart';
import 'trip_form_screen.dart';
import 'ai_entry_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class TripListScreen extends ConsumerStatefulWidget {
  const TripListScreen({super.key});

  @override
  ConsumerState<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends ConsumerState<TripListScreen> {
  final _searchController = TextEditingController();
  String? _selectedFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Trip> _filterTrips(List<Trip> trips) {
    var filtered = trips;

    // Apply status filter
    if (_selectedFilter != null) {
      filtered = filtered.where((trip) => trip.status == _selectedFilter).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((trip) {
        return trip.fromLocation.toLowerCase().contains(query) ||
            trip.toLocation.toLowerCase().contains(query) ||
            trip.vehicleId.toLowerCase().contains(query) ||
            trip.driverId.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AiEntryScreen(),
                ),
              );
            },
            tooltip: 'AI Assistant',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          AppSearchBar(
            controller: _searchController,
            hintText: 'Search trips by route, vehicle, driver...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          // Filter chips
          FilterChipBar(
            filters: const [
              FilterChipData(
                label: 'Active',
                value: 'ACTIVE',
                color: AppTheme.infoColor,
              ),
              FilterChipData(
                label: 'Completed',
                value: 'COMPLETED',
                color: AppTheme.successColor,
              ),
              FilterChipData(
                label: 'Cancelled',
                value: 'CANCELLED',
                color: AppTheme.dangerColor,
              ),
            ],
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          // Trip list
          Expanded(
            child: tripsAsync.when(
              data: (tripList) {
                final filteredTrips = _filterTrips(tripList);
                return filteredTrips.isEmpty
                    ? _buildEmptyState(context)
                    : _buildTripList(context, filteredTrips);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TripFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.directions,
      title: 'No trips added yet',
      subtitle: 'Create your first trip to get started',
      primaryAction: AppPrimaryButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const TripFormScreen(),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Create Trip'),
          ],
        ),
      ),
    );
  }

  Widget _buildTripList(BuildContext context, List<Trip> trips) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return _TripCard(trip: trip);
      },
    );
  }
}

class _TripCard extends ConsumerWidget {
  final Trip trip;

  const _TripCard({required this.trip});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(tripServiceProvider);
    final tripSummary = service.getTripSummary(trip);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(trip.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(trip.id),
        background: Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.edit, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.delete, color: colorScheme.error),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TripFormScreen(trip: trip),
              ),
            );
            ref.invalidate(tripListProvider);
            ref.invalidate(tripStatsProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Trip'),
              content: const Text('Are you sure you want to delete this trip?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          return confirm ?? false;
        },
        onDismissed: (direction) async {
          try {
            await ref.read(tripServiceProvider).deleteTrip(trip.id);
            ref.invalidate(tripListProvider);
            ref.invalidate(tripStatsProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Trip deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(tripListProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        child: PanelCard(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withOpacity(0.35)),
                ),
                child: Icon(
                  _getStatusIcon(trip.status),
                  color: statusColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tripSummary['route'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusPill(label: trip.status, color: statusColor),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceSm),
                    _MetaRow(
                      icon: Icons.local_shipping,
                      label: 'Vehicle: ${trip.vehicleId}',
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    _MetaRow(
                      icon: Icons.people,
                      label: 'Driver: ${trip.driverId}',
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    _MetaRow(
                      icon: Icons.business,
                      label: 'Party: ${trip.partyId}',
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    _MetaRow(
                      icon: Icons.calendar_today,
                      label:
                          'Start: ${trip.startDate.day}/${trip.startDate.month}/${trip.startDate.year} • ${tripSummary['duration']}',
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${trip.freightAmount.toStringAsFixed(0)}',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceXs),
                  Text(
                    'Bal ₹${(tripSummary['balance'] as double).toStringAsFixed(0)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppTheme.infoColor;
      case 'COMPLETED':
        return AppTheme.successColor;
      case 'CANCELLED':
        return AppTheme.dangerColor;
      default:
        return Colors.grey;
    }
  }

  List<Color> _getStatusGradient(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return AppTheme.infoGradient;
      case 'COMPLETED':
        return AppTheme.successGradient;
      case 'CANCELLED':
        return [AppTheme.dangerColor, AppTheme.dangerColor.withOpacity(0.7)];
      default:
        return [Colors.grey.shade400, Colors.grey.shade300];
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toUpperCase()) {
      case 'ACTIVE':
        return Icons.play_arrow;
      case 'COMPLETED':
        return Icons.check_circle;
      case 'CANCELLED':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurface.withOpacity(0.75),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
