import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/trip_provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/driver_provider.dart';
import '../providers/party_provider.dart';
import '../providers/suggestion_provider.dart';
import '../providers/database_provider.dart';
import '../widgets/smart_location_field.dart';
import 'vehicle_form_screen.dart';
import 'driver_form_screen.dart';
import 'party_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/voice_input_service.dart';
import '../widgets/voice_input_button.dart';

class TripFormScreen extends ConsumerStatefulWidget {
  final Trip? trip;

  const TripFormScreen({super.key, this.trip});

  @override
  ConsumerState<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends ConsumerState<TripFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fromLocationController = TextEditingController();
  final _toLocationController = TextEditingController();
  final _freightAmountController = TextEditingController();
  final _advanceAmountController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedVehicleId;
  String? _selectedDriverId;
  String? _selectedPartyId;
  DateTime? _startDate;
  DateTime? _expectedEndDate;

  @override
  void initState() {
    super.initState();
    if (widget.trip != null) {
      _populateFields(widget.trip!);
    }
  }

  void _populateFields(Trip trip) {
    _fromLocationController.text = trip.fromLocation;
    _toLocationController.text = trip.toLocation;
    _freightAmountController.text = trip.freightAmount.toString();
    _advanceAmountController.text = trip.advanceAmount?.toString() ?? '';
    _notesController.text = trip.notes ?? '';
    _selectedVehicleId = trip.vehicleId;
    _selectedDriverId = trip.driverId;
    _selectedPartyId = trip.partyId;
    _startDate = trip.startDate;
    _expectedEndDate = trip.expectedEndDate;
  }

  @override
  void dispose() {
    _fromLocationController.dispose();
    _toLocationController.dispose();
    _freightAmountController.dispose();
    _advanceAmountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleVoiceInput(String text) {
    final voiceService = VoiceInputService();
    final command = voiceService.parseTripCommand(text);

    if (command != null) {
      if (command.action == TripAction.complete && widget.trip != null) {
        _updateTripStatus('COMPLETED');
      } else if (command.action == TripAction.start && widget.trip != null) {
        _updateTripStatus('IN_PROGRESS');
      } else if (command.action == TripAction.cancel && widget.trip != null) {
        _updateTripStatus('CANCELLED');
      } else if (command.action == TripAction.updateLocation && command.location != null) {
        _notesController.text = 'Reached ${command.location}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice command processed: $text'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not parse trip command from voice input'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _updateTripStatus(String status) async {
    if (widget.trip == null) return;

    try {
      // Update trip status via database
      final database = ref.read(databaseProvider);
      final trip = widget.trip!;
      await database.into(database.trips).insertOnConflictUpdate(
        trip.copyWith(status: status),
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip status updated to $status')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating trip: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.trip != null;
    final vehicles = ref.watch(vehicleListProvider);
    final drivers = ref.watch(driverListProvider);
    final parties = ref.watch(partyListProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Trip' : 'Create Trip'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      floatingActionButton: isEditing ? FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voice Trip Update',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Say something like:\n"Complete trip"\n"Start trip"\n"Reached Delhi"',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  VoiceInputButton(
                    onResult: (text) {
                      Navigator.pop(context);
                      _handleVoiceInput(text);
                    },
                    tooltip: 'Tap to speak',
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.mic),
      ) : null,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Route Information Section
              _buildSectionHeader('Route Information'),
              const SizedBox(height: 16),
              
              SmartLocationField(
                label: 'From Location',
                controller: _fromLocationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter from location';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              const SizedBox(height: 16),

              SmartLocationField(
                label: 'To Location',
                controller: _toLocationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter to location';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),

              const SizedBox(height: 24),

              // Assignment Section
              _buildSectionHeader('Assignment'),
              const SizedBox(height: 16),

              vehicles.when(
                data: (vehicleList) => vehicleList.isEmpty
                    ? _buildEmptyAssignmentCard(
                        title: 'No vehicles found',
                        subtitle: 'Add a vehicle to assign this trip',
                        buttonText: 'Add Vehicle',
                        icon: Icons.local_shipping,
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const VehicleFormScreen(),
                            ),
                          );
                          ref.invalidate(vehicleListProvider);
                        },
                      )
                    : DropdownButtonFormField<String>(
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
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 8),
                      Text('Error loading vehicles', style: TextStyle(color: colorScheme.error)),
                      if (error.toString().contains('Null'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Database not initialized. Please restart the app.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(vehicleListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Driver Suggestion Chip
              if (_fromLocationController.text.isNotEmpty && 
                  _toLocationController.text.isNotEmpty &&
                  _selectedVehicleId == null)
                FutureBuilder<String?>(
                  future: ref.read(suggestionServiceProvider).suggestDriver(
                    fromLocation: _fromLocationController.text,
                    toLocation: _toLocationController.text,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
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
                              Icons.lightbulb_outline,
                              color: theme.colorScheme.secondary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Suggested driver based on route experience',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

              drivers.when(
                data: (driverList) => driverList.isEmpty
                    ? _buildEmptyAssignmentCard(
                        title: 'No drivers found',
                        subtitle: 'Add a driver to assign this trip',
                        buttonText: 'Add Driver',
                        icon: Icons.people,
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const DriverFormScreen(),
                            ),
                          );
                          ref.invalidate(driverListProvider);
                        },
                      )
                    : DropdownButtonFormField<String>(
                        value: _selectedDriverId,
                        decoration: const InputDecoration(
                          labelText: 'Select Driver',
                          prefixIcon: Icon(Icons.people),
                        ),
                        items: driverList.map((driver) {
                          return DropdownMenuItem(
                            value: driver.id,
                            child: Text('${driver.name} - ${driver.licenseType}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDriverId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a driver';
                          }
                          return null;
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 8),
                      Text('Error loading drivers', style: TextStyle(color: colorScheme.error)),
                      if (error.toString().contains('Null'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Database not initialized. Please restart the app.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(driverListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              parties.when(
                data: (partyList) => partyList.isEmpty
                    ? _buildEmptyAssignmentCard(
                        title: 'No parties found',
                        subtitle: 'Add a party to assign this trip',
                        buttonText: 'Add Party',
                        icon: Icons.business,
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const PartyFormScreen(),
                            ),
                          );
                          ref.invalidate(partyListProvider);
                        },
                      )
                    : DropdownButtonFormField<String>(
                        value: _selectedPartyId,
                        decoration: const InputDecoration(
                          labelText: 'Select Party',
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: partyList.map((party) {
                          return DropdownMenuItem(
                            value: party.id,
                            child: Text('${party.name} - ${party.city}'),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPartyId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a party';
                          }
                          return null;
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                      const SizedBox(height: 8),
                      Text('Error loading parties', style: TextStyle(color: colorScheme.error)),
                      if (error.toString().contains('Null'))
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Database not initialized. Please restart the app.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ElevatedButton(
                        onPressed: () => ref.refresh(partyListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Financial Information Section
              _buildSectionHeader('Financial Information'),
              const SizedBox(height: 16),

              // Freight Suggestion Chip
              if (_fromLocationController.text.isNotEmpty && 
                  _toLocationController.text.isNotEmpty &&
                  _selectedVehicleId != null &&
                  _freightAmountController.text.isEmpty)
                FutureBuilder<double?>(
                  future: ref.read(suggestionServiceProvider).suggestFreightAmount(
                    fromLocation: _fromLocationController.text,
                    toLocation: _toLocationController.text,
                    vehicleId: _selectedVehicleId!,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Suggested freight: ₹${snapshot.data!.toStringAsFixed(0)} (based on similar trips)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _freightAmountController.text = snapshot.data!.toStringAsFixed(0);
                                });
                              },
                              child: const Text('Use'),
                            ),
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              
              TextFormField(
                controller: _freightAmountController,
                decoration: const InputDecoration(
                  labelText: 'Freight Amount (₹)',
                  hintText: 'e.g., 50000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter freight amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _advanceAmountController,
                decoration: const InputDecoration(
                  labelText: 'Advance Amount (₹)',
                  hintText: 'e.g., 20000',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null || double.parse(value) < 0) {
                      return 'Please enter a valid amount';
                    }
                    final freight = double.tryParse(_freightAmountController.text) ?? 0;
                    final advance = double.parse(value);
                    if (advance > freight) {
                      return 'Advance cannot exceed freight amount';
                    }
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Schedule Section
              _buildSectionHeader('Schedule'),
              const SizedBox(height: 16),

              _buildDateSelector(
                'Start Date',
                _startDate,
                (date) => setState(() => _startDate = date),
              ),
              const SizedBox(height: 16),

              _buildDateSelector(
                'Expected End Date',
                _expectedEndDate,
                (date) => setState(() => _expectedEndDate = date),
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
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveTrip,
                  child: Text(isEditing ? 'Update Trip' : 'Create Trip'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyAssignmentCard({
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.add),
                      label: Text(buttonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
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
          firstDate: DateTime.now().subtract(const Duration(days: 30)),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          selectedDate != null
              ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
              : 'Select date',
          style: TextStyle(
            color: selectedDate != null
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ),
    );
  }

  Future<void> _saveTrip() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(tripServiceProvider);
      final freightAmount = double.parse(_freightAmountController.text);
      final advanceAmount = _advanceAmountController.text.isEmpty 
          ? null 
          : double.parse(_advanceAmountController.text);

      // Validate trip data
      if (_selectedVehicleId == null || _selectedDriverId == null || _selectedPartyId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select vehicle, driver, and party')),
          );
        }
        return;
      }

      if (!service.validateTripData(
        fromLocation: _fromLocationController.text,
        toLocation: _toLocationController.text,
        vehicleId: _selectedVehicleId!,
        driverId: _selectedDriverId!,
        partyId: _selectedPartyId!,
        freightAmount: freightAmount,
        advanceAmount: advanceAmount,
      )) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please check all fields')),
          );
        }
        return;
      }

      if (widget.trip != null) {
        // Update existing trip
        await service.updateTrip(
          id: widget.trip!.id,
          fromLocation: _fromLocationController.text,
          toLocation: _toLocationController.text,
          vehicleId: _selectedVehicleId!,
          driverId: _selectedDriverId!,
          partyId: _selectedPartyId!,
          freightAmount: freightAmount,
          advanceAmount: advanceAmount,
          startDate: _startDate,
          expectedEndDate: _expectedEndDate,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      } else {
        // Create new trip
        await service.createTrip(
          fromLocation: _fromLocationController.text,
          toLocation: _toLocationController.text,
          vehicleId: _selectedVehicleId!,
          driverId: _selectedDriverId!,
          partyId: _selectedPartyId!,
          freightAmount: freightAmount,
          advanceAmount: advanceAmount,
          startDate: _startDate,
          expectedEndDate: _expectedEndDate,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      ref.invalidate(tripListProvider);
      ref.invalidate(tripStatsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.trip != null
                ? 'Trip updated successfully'
                : 'Trip created successfully'),
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
        title: const Text('Delete Trip'),
        content: Text('Are you sure you want to delete this trip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(tripServiceProvider).deleteTrip(widget.trip!.id);
                ref.invalidate(tripListProvider);
                ref.invalidate(tripStatsProvider);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Trip deleted successfully')),
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
            style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
