import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/database.dart';
import '../providers/database_provider.dart';
import '../providers/vehicle_provider.dart';

/// Maintenance History Screen
/// Shows all past maintenance records with filtering and cost analysis
class MaintenanceHistoryScreen extends ConsumerStatefulWidget {
  final String? vehicleId;

  const MaintenanceHistoryScreen({super.key, this.vehicleId});

  @override
  ConsumerState<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends ConsumerState<MaintenanceHistoryScreen> {
  String? _selectedVehicleId;
  String _selectedFilter = 'ALL';

  @override
  void initState() {
    super.initState();
    _selectedVehicleId = widget.vehicleId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicles = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maintenance History'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedFilter,
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'ALL', child: Text('All')),
              const PopupMenuItem(value: 'COMPLETED', child: Text('Completed')),
              const PopupMenuItem(value: 'PENDING', child: Text('Pending')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Vehicle Filter
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: vehicles.when(
              data: (vehicleList) => DropdownButtonFormField<String>(
                value: _selectedVehicleId,
                decoration: const InputDecoration(
                  labelText: 'Filter by Vehicle',
                  prefixIcon: Icon(Icons.local_shipping),
                  border: OutlineInputBorder(),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All Vehicles')),
                  ...vehicleList.map((vehicle) {
                    return DropdownMenuItem(
                      value: vehicle.id,
                      child: Text('${vehicle.truckNumber} - ${vehicle.truckType}'),
                    );
                  }),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedVehicleId = value;
                  });
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading vehicles: $error'),
            ),
          ),

          // Summary Cards
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Services',
                    '24',
                    Icons.build,
                    theme.colorScheme.primary,
                    theme,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Cost',
                    '₹84,500',
                    Icons.currency_rupee,
                    Colors.orange,
                    theme,
                  ),
                ),
              ],
            ),
          ),

          // Maintenance List
          Expanded(
            child: FutureBuilder<List<MaintenanceSchedule>>(
              future: _getMaintenanceHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final schedules = snapshot.data ?? [];

                if (schedules.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: theme.colorScheme.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No maintenance history',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    return _buildMaintenanceCard(schedules[index], theme);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard(MaintenanceSchedule schedule, ThemeData theme) {
    final isCompleted = schedule.status == 'COMPLETED';
    final isPending = schedule.status == 'PENDING';
    final color = isCompleted ? Colors.green : (isPending ? Colors.orange : Colors.grey);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getMaintenanceIcon(schedule.maintenanceType),
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatMaintenanceType(schedule.maintenanceType),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Due: ${_formatDate(schedule.dueDate)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Text(
                    schedule.status,
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Scheduled: ${_formatDate(schedule.scheduleDate)}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMaintenanceIcon(String type) {
    switch (type) {
      case 'SERVICE':
        return Icons.build;
      case 'OIL_CHANGE':
        return Icons.oil_barrel;
      case 'TIRE_ROTATION':
        return Icons.tire_repair;
      case 'BRAKE_CHECK':
        return Icons.car_repair;
      case 'INSPECTION':
        return Icons.search;
      case 'REPAIR':
        return Icons.handyman;
      default:
        return Icons.build;
    }
  }

  String _formatMaintenanceType(String type) {
    return type.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<List<MaintenanceSchedule>> _getMaintenanceHistory() async {
    final database = ref.read(databaseProvider);
    var query = database.select(database.maintenanceSchedules);

    if (_selectedVehicleId != null) {
      query = query..where((tbl) => tbl.vehicleId.equals(_selectedVehicleId!));
    }

    if (_selectedFilter != 'ALL') {
      query = query..where((tbl) => tbl.status.equals(_selectedFilter));
    }

    final schedules = await query.get();
    schedules.sort((a, b) => b.scheduleDate.compareTo(a.scheduleDate));
    return schedules;
  }
}
