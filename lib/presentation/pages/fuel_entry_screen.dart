import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../data/database.dart';
import '../providers/database_provider.dart';
import '../providers/vehicle_provider.dart';

/// Fuel Entry Screen
/// Allows users to log fuel fills with odometer readings for mileage tracking
class FuelEntryScreen extends ConsumerStatefulWidget {
  final String? vehicleId;

  const FuelEntryScreen({super.key, this.vehicleId});

  @override
  ConsumerState<FuelEntryScreen> createState() => _FuelEntryScreenState();
}

class _FuelEntryScreenState extends ConsumerState<FuelEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _odometerController = TextEditingController();
  final _quantityController = TextEditingController();
  final _costPerLiterController = TextEditingController();
  final _pumpNameController = TextEditingController();

  String? _selectedVehicleId;
  String _selectedFuelType = 'DIESEL';
  DateTime _entryDate = DateTime.now();
  double _totalCost = 0;

  @override
  void initState() {
    super.initState();
    _selectedVehicleId = widget.vehicleId;
    _quantityController.addListener(_calculateTotalCost);
    _costPerLiterController.addListener(_calculateTotalCost);
  }

  @override
  void dispose() {
    _odometerController.dispose();
    _quantityController.dispose();
    _costPerLiterController.dispose();
    _pumpNameController.dispose();
    super.dispose();
  }

  void _calculateTotalCost() {
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final costPerLiter = double.tryParse(_costPerLiterController.text) ?? 0;
    setState(() {
      _totalCost = quantity * costPerLiter;
    });
  }

  Future<void> _saveFuelEntry() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVehicleId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle')),
      );
      return;
    }

    try {
      final database = ref.read(databaseProvider);
      final quantity = double.parse(_quantityController.text);
      final costPerLiter = double.parse(_costPerLiterController.text);
      final totalCost = quantity * costPerLiter;

      final entry = FuelEntriesCompanion.insert(
        id: const Uuid().v4(),
        vehicleId: _selectedVehicleId!,
        fuelType: _selectedFuelType,
        quantityLiters: quantity,
        costPerLiter: costPerLiter,
        totalCost: totalCost,
        odometerReading: double.parse(_odometerController.text),
        fuelPumpName: Value(_pumpNameController.text.isEmpty ? null : _pumpNameController.text),
        entryDate: _entryDate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await database.into(database.fuelEntries).insert(entry);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fuel entry saved successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving fuel entry: $e')),
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
        title: const Text('Add Fuel Entry'),
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

              // Fuel Information
              Text(
                'Fuel Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                decoration: const InputDecoration(
                  labelText: 'Fuel Type',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                items: const [
                  DropdownMenuItem(value: 'DIESEL', child: Text('Diesel')),
                  DropdownMenuItem(value: 'PETROL', child: Text('Petrol')),
                  DropdownMenuItem(value: 'CNG', child: Text('CNG')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedFuelType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _odometerController,
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading (km)',
                  hintText: 'e.g., 45000',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter odometer reading';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(
                  labelText: 'Fuel Quantity (liters)',
                  hintText: 'e.g., 50',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fuel quantity';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _costPerLiterController,
                decoration: const InputDecoration(
                  labelText: 'Cost per Liter (₹)',
                  hintText: 'e.g., 95',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cost per liter';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid cost';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Total Cost Display
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Cost:',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${_totalCost.toStringAsFixed(2)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Additional Information
              Text(
                'Additional Information',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pumpNameController,
                decoration: const InputDecoration(
                  labelText: 'Fuel Pump Name (Optional)',
                  hintText: 'e.g., Indian Oil, Panipat',
                  prefixIcon: Icon(Icons.store),
                ),
              ),
              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Entry Date'),
                subtitle: Text(
                  '${_entryDate.day}/${_entryDate.month}/${_entryDate.year}',
                ),
                trailing: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _entryDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      setState(() {
                        _entryDate = date;
                      });
                    }
                  },
                  child: const Text('Change'),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveFuelEntry,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Fuel Entry'),
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
