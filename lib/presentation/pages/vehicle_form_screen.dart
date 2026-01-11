import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/vehicle_provider.dart';
import '../../data/database.dart';

class VehicleFormScreen extends ConsumerStatefulWidget {
  final Vehicle? vehicle;

  const VehicleFormScreen({super.key, this.vehicle});

  @override
  ConsumerState<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends ConsumerState<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _truckNumberController = TextEditingController();
  final _capacityController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedTruckType = 'TRUCK';
  String _selectedFuelType = 'diesel';
  DateTime? _insuranceExpiry;
  DateTime? _fitnessExpiry;
  String? _assignedDriverId;

  final List<String> _truckTypes = [
    'TRUCK',
    'TRAILER',
    'TANKER',
    'CONTAINER',
  ];

  final List<String> _fuelTypes = [
    'diesel',
    'petrol',
    'cng',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.vehicle != null) {
      _populateFields(widget.vehicle!);
    }
  }

  void _populateFields(Vehicle vehicle) {
    _truckNumberController.text = vehicle.truckNumber;
    _capacityController.text = vehicle.capacity.toString();
    _registrationNumberController.text = vehicle.registrationNumber;
    _notesController.text = vehicle.notes ?? '';
    _selectedTruckType = vehicle.truckType;
    _selectedFuelType = vehicle.fuelType;
    _insuranceExpiry = vehicle.insuranceExpiry;
    _fitnessExpiry = vehicle.fitnessExpiry;
    _assignedDriverId = vehicle.assignedDriverId;
  }

  @override
  void dispose() {
    _truckNumberController.dispose();
    _capacityController.dispose();
    _registrationNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.vehicle != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Vehicle' : 'Add Vehicle'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Basic Information Section
              _buildSectionHeader('Basic Information'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _truckNumberController,
                decoration: const InputDecoration(
                  labelText: 'Truck Number',
                  hintText: 'e.g., MH-12-AB-1234',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter truck number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedTruckType,
                decoration: const InputDecoration(
                  labelText: 'Truck Type',
                  border: OutlineInputBorder(),
                ),
                items: _truckTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTruckType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity (tons)',
                  hintText: 'e.g., 5.5',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter capacity';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                decoration: const InputDecoration(
                  labelText: 'Fuel Type',
                  border: OutlineInputBorder(),
                ),
                items: _fuelTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.toUpperCase()));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _registrationNumberController,
                decoration: const InputDecoration(
                  labelText: 'Registration Number',
                  hintText: 'e.g., MH01AB1234',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter registration number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Expiry Dates Section
              _buildSectionHeader('Expiry Dates'),
              const SizedBox(height: 16),

              _buildDateSelector(
                'Insurance Expiry',
                _insuranceExpiry,
                (date) => setState(() => _insuranceExpiry = date),
              ),
              const SizedBox(height: 16),

              _buildDateSelector(
                'Fitness Expiry',
                _fitnessExpiry,
                (date) => setState(() => _fitnessExpiry = date),
              ),

              const SizedBox(height: 24),

              // Additional Information Section
              _buildSectionHeader('Additional Information'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  hintText: 'Any additional information...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveVehicle,
                  child: Text(isEditing ? 'Update Vehicle' : 'Add Vehicle'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildDateSelector(
    String label,
    DateTime? selectedDate,
    Function(DateTime?) onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null ? null : Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _saveVehicle() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(vehicleServiceProvider);

      if (widget.vehicle != null) {
        // Update existing vehicle
        await service.updateVehicle(
          id: widget.vehicle!.id,
          truckNumber: _truckNumberController.text,
          truckType: _selectedTruckType,
          capacity: double.parse(_capacityController.text),
          fuelType: _selectedFuelType,
          registrationNumber: _registrationNumberController.text,
          insuranceExpiry: _insuranceExpiry,
          fitnessExpiry: _fitnessExpiry,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      } else {
        // Create new vehicle
        await service.createVehicle(
          truckNumber: _truckNumberController.text,
          truckType: _selectedTruckType,
          capacity: double.parse(_capacityController.text),
          fuelType: _selectedFuelType,
          registrationNumber: _registrationNumberController.text,
          insuranceExpiry: _insuranceExpiry,
          fitnessExpiry: _fitnessExpiry,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.vehicle != null
                ? 'Vehicle updated successfully'
                : 'Vehicle added successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: Text('Are you sure you want to delete ${widget.vehicle!.truckNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(vehicleServiceProvider).deleteVehicle(widget.vehicle!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vehicle deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
