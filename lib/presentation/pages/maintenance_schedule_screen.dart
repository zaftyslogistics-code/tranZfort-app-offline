import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../data/database.dart';
import '../providers/database_provider.dart';
import '../providers/vehicle_provider.dart';

/// Maintenance Schedule Screen
/// Allows users to schedule preventive maintenance and track service history
class MaintenanceScheduleScreen extends ConsumerStatefulWidget {
  final String? vehicleId;

  const MaintenanceScheduleScreen({super.key, this.vehicleId});

  @override
  ConsumerState<MaintenanceScheduleScreen> createState() => _MaintenanceScheduleScreenState();
}

class _MaintenanceScheduleScreenState extends ConsumerState<MaintenanceScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _estimatedCostController = TextEditingController();
  final _dueKmController = TextEditingController();

  String? _selectedVehicleId;
  String _maintenanceType = 'SERVICE';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _selectedVehicleId = widget.vehicleId;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _estimatedCostController.dispose();
    _dueKmController.dispose();
    super.dispose();
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle')),
      );
      return;
    }

    try {
      final database = ref.read(databaseProvider);
      final schedule = MaintenanceSchedulesCompanion.insert(
        id: const Uuid().v4(),
        vehicleId: _selectedVehicleId!,
        maintenanceType: _maintenanceType,
        scheduleDate: DateTime.now(),
        dueDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
        status: 'PENDING',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await database.into(database.maintenanceSchedules).insert(schedule);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Maintenance scheduled successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error scheduling maintenance: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vehicles = ref.watch(vehicleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Maintenance'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle Selection
              Text(
                'Vehicle Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              vehicles.when(
                data: (vehicleList) => DropdownButtonFormField<String>(
                  value: _selectedVehicleId,
                  decoration: const InputDecoration(
                    labelText: 'Select Vehicle',
                    prefixIcon: Icon(Icons.local_shipping),
                  ),
                  items: vehicleList.map((vehicle) {
                    return DropdownMenuItem(
                      value: vehicle.id,
                      child: Text('${vehicle.truckNumber} - ${vehicle.truckType}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedVehicleId = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a vehicle';
                    }
                    return null;
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Text('Error loading vehicles: $error'),
              ),
              const SizedBox(height: 24),

              // Maintenance Details
              Text(
                'Maintenance Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _maintenanceType,
                decoration: const InputDecoration(
                  labelText: 'Maintenance Type',
                  prefixIcon: Icon(Icons.build),
                ),
                items: const [
                  DropdownMenuItem(value: 'SERVICE', child: Text('Regular Service')),
                  DropdownMenuItem(value: 'OIL_CHANGE', child: Text('Oil Change')),
                  DropdownMenuItem(value: 'TIRE_ROTATION', child: Text('Tire Rotation')),
                  DropdownMenuItem(value: 'BRAKE_CHECK', child: Text('Brake Check')),
                  DropdownMenuItem(value: 'INSPECTION', child: Text('Inspection')),
                  DropdownMenuItem(value: 'REPAIR', child: Text('Repair')),
                  DropdownMenuItem(value: 'OTHER', child: Text('Other')),
                ],
                onChanged: (value) {
                  setState(() {
                    _maintenanceType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Engine oil change and filter replacement',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Schedule Information
              Text(
                'Schedule Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: Text(
                  _dueDate != null
                      ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                      : 'Not set',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 30)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() {
                        _dueDate = date;
                      });
                    }
                  },
                  child: const Text('Set Date'),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dueKmController,
                decoration: const InputDecoration(
                  labelText: 'Due at Kilometers (Optional)',
                  hintText: 'e.g., 50000',
                  prefixIcon: Icon(Icons.speed),
                  helperText: 'Set reminder based on odometer reading',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _estimatedCostController,
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost (₹)',
                  hintText: 'e.g., 5000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: theme.colorScheme.secondary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You will receive notifications 7 days before the due date',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveSchedule,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Schedule Maintenance'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
