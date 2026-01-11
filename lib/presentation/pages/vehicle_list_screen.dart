import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicle_provider.dart';
import 'vehicle_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class VehicleListScreen extends ConsumerWidget {
  const VehicleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: vehicles.when(
        data: (vehicleList) => vehicleList.isEmpty
            ? _buildEmptyState(context)
            : _buildVehicleList(context, vehicleList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VehicleFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppTheme.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.local_shipping,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No vehicles added yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first vehicle to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const VehicleFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Vehicle'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleList(BuildContext context, List<Vehicle> vehicles) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: vehicles.length,
      itemBuilder: (context, index) {
        final vehicle = vehicles[index];
        return _VehicleCard(vehicle: vehicle);
      },
    );
  }
}

class _VehicleCard extends ConsumerWidget {
  final Vehicle vehicle;

  const _VehicleCard({required this.vehicle});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = AppTheme.getStatusColor(vehicle.status);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(vehicle.id),
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
                builder: (context) => VehicleFormScreen(vehicle: vehicle),
              ),
            );
            ref.invalidate(vehicleListProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Vehicle'),
              content: Text('Are you sure you want to delete ${vehicle.truckNumber}?'),
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
            await ref.read(vehicleServiceProvider).deleteVehicle(vehicle.id);
            ref.invalidate(vehicleListProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehicle deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(vehicleListProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        child: PanelCard(
          padding: const EdgeInsets.all(14),
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
                  AppTheme.getStatusIcon(vehicle.status),
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
                            vehicle.truckNumber,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusPill(label: vehicle.status, color: statusColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _MetaRow(
                      icon: AppTheme.getVehicleTypeIcon(vehicle.truckType),
                      label: '${vehicle.truckType} • ${vehicle.capacity} tons',
                    ),
                    const SizedBox(height: 6),
                    _MetaRow(
                      icon: Icons.local_gas_station,
                      label: 'Fuel: ${vehicle.fuelType.toUpperCase()} • ${vehicle.registrationNumber}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${vehicle.truckNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(vehicleServiceProvider).deleteVehicle(vehicle.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
