import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/driver_provider.dart';
import 'driver_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class DriverListScreen extends ConsumerWidget {
  const DriverListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driverListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.warning),
            onPressed: () {
              // TODO: Navigate to expiring licenses
            },
          ),
        ],
      ),
      body: drivers.when(
        data: (driverList) => driverList.isEmpty
            ? _buildEmptyState(context)
            : _buildDriverList(context, driverList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DriverFormScreen(),
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
                colors: AppTheme.successGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.people,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No drivers added yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first driver to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DriverFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Driver'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverList(BuildContext context, List<Driver> drivers) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: drivers.length,
      itemBuilder: (context, index) {
        final driver = drivers[index];
        return _DriverCard(driver: driver);
      },
    );
  }
}

class _DriverCard extends ConsumerWidget {
  final Driver driver;

  const _DriverCard({required this.driver});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(driverServiceProvider);
    final licenseStatus = service.getLicenseStatus(driver.licenseExpiry);
    final isExpiring = service.isLicenseExpiring(driver.licenseExpiry);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(driver.status);
    final licenseColor = _getLicenseStatusColor(licenseStatus);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(driver.id),
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
                builder: (context) => DriverFormScreen(driver: driver),
              ),
            );
            ref.invalidate(driverListProvider);
            ref.invalidate(driverStatsProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Driver'),
              content: Text('Are you sure you want to delete ${driver.name}?'),
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
            await ref.read(driverServiceProvider).deleteDriver(driver.id);
            ref.invalidate(driverListProvider);
            ref.invalidate(driverStatsProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Driver deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(driverListProvider);
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
                  _getStatusIcon(driver.status),
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
                            driver.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusPill(label: driver.status, color: statusColor),
                        if (isExpiring) ...[
                          const SizedBox(width: 8),
                          StatusPill(label: _getLicenseStatusText(licenseStatus), color: licenseColor),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    _MetaRow(
                      icon: Icons.phone,
                      label: driver.phone,
                    ),
                    const SizedBox(height: 6),
                    _MetaRow(
                      icon: Icons.badge,
                      label: '${driver.licenseType} • ${driver.licenseNumber}',
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'ACTIVE':
        return AppTheme.successColor;
      case 'INACTIVE':
        return Colors.grey;
      case 'ON_LEAVE':
        return AppTheme.warningColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'ACTIVE':
        return Icons.check_circle;
      case 'INACTIVE':
        return Icons.person_off;
      case 'ON_LEAVE':
        return Icons.beach_access;
      default:
        return Icons.help;
    }
  }

  Color _getLicenseStatusColor(String status) {
    switch (status) {
      case 'VALID':
        return AppTheme.successColor;
      case 'EXPIRING_SOON':
        return AppTheme.warningColor;
      case 'EXPIRED':
        return AppTheme.dangerColor;
      default:
        return Colors.grey;
    }
  }

  String _getLicenseStatusText(String status) {
    switch (status) {
      case 'VALID':
        return 'Valid';
      case 'EXPIRING_SOON':
        return 'Expiring';
      case 'EXPIRED':
        return 'Expired';
      default:
        return 'Not Set';
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
