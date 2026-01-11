import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/driver_provider.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';

class DriverFormScreen extends ConsumerStatefulWidget {
  final Driver? driver;

  const DriverFormScreen({super.key, this.driver});

  @override
  ConsumerState<DriverFormScreen> createState() => _DriverFormScreenState();
}

class _DriverFormScreenState extends ConsumerState<DriverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _licenseNumberController = TextEditingController();
  final _addressController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedLicenseType = 'LIGHT';
  String _selectedStatus = 'ACTIVE';
  DateTime? _licenseExpiry;

  final List<String> _licenseTypes = [
    'LIGHT',
    'HEAVY',
    'TRANSPORT',
    'HAZMAT',
  ];

  final List<String> _statusTypes = [
    'ACTIVE',
    'INACTIVE',
    'ON_LEAVE',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.driver != null) {
      _populateFields(widget.driver!);
    }
  }

  void _populateFields(Driver driver) {
    _nameController.text = driver.name;
    _phoneController.text = driver.phone;
    _licenseNumberController.text = driver.licenseNumber;
    _addressController.text = driver.address ?? '';
    _emergencyContactController.text = driver.emergencyContact ?? '';
    _notesController.text = driver.notes ?? '';
    _selectedLicenseType = driver.licenseType;
    _selectedStatus = driver.status;
    _licenseExpiry = driver.licenseExpiry;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _licenseNumberController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.driver != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Driver' : 'Add Driver'),
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
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'e.g., John Doe',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'e.g., +91 9876543210',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: _statusTypes.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Icon(_getStatusIcon(status), size: 16),
                        const SizedBox(width: 8),
                        Text(status),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),

              const SizedBox(height: 24),

              // License Information Section
              _buildSectionHeader('License Information'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _licenseNumberController,
                decoration: const InputDecoration(
                  labelText: 'License Number',
                  hintText: 'e.g., DL-1234567890',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter license number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedLicenseType,
                decoration: const InputDecoration(
                  labelText: 'License Type',
                  border: OutlineInputBorder(),
                ),
                items: _licenseTypes.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLicenseType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildDateSelector(
                'License Expiry Date',
                _licenseExpiry,
                (date) => setState(() => _licenseExpiry = date),
              ),

              const SizedBox(height: 24),

              // Additional Information Section
              _buildSectionHeader('Additional Information'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Driver address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emergencyContactController,
                decoration: const InputDecoration(
                  labelText: 'Emergency Contact',
                  hintText: 'Emergency contact number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
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
                  onPressed: _saveDriver,
                  child: Text(isEditing ? 'Update Driver' : 'Add Driver'),
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
    final service = ref.read(driverServiceProvider);
    final licenseStatus = service.getLicenseStatus(selectedDate);
    final isExpiring = service.isLicenseExpiring(selectedDate);

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
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isExpiring)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getLicenseStatusColor(licenseStatus),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getLicenseStatusText(licenseStatus),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.calendar_today),
            ],
          ),
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

  Future<void> _saveDriver() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(driverServiceProvider);

      // Check for unique phone and license number
      final isPhoneUnique = await service.isPhoneUnique(
        _phoneController.text,
        excludeId: widget.driver?.id,
      );
      
      final isLicenseUnique = await service.isLicenseNumberUnique(
        _licenseNumberController.text,
        excludeId: widget.driver?.id,
      );

      if (!isPhoneUnique) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number already exists')),
          );
        }
        return;
      }

      if (!isLicenseUnique) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('License number already exists')),
          );
        }
        return;
      }

      if (widget.driver != null) {
        // Update existing driver
        await service.updateDriver(
          id: widget.driver!.id,
          name: _nameController.text,
          phone: _phoneController.text,
          licenseNumber: _licenseNumberController.text,
          licenseType: _selectedLicenseType,
          licenseExpiry: _licenseExpiry,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          emergencyContact: _emergencyContactController.text.isEmpty ? null : _emergencyContactController.text,
          status: _selectedStatus,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      } else {
        // Create new driver
        await service.createDriver(
          name: _nameController.text,
          phone: _phoneController.text,
          licenseNumber: _licenseNumberController.text,
          licenseType: _selectedLicenseType,
          licenseExpiry: _licenseExpiry,
          address: _addressController.text.isEmpty ? null : _addressController.text,
          emergencyContact: _emergencyContactController.text.isEmpty ? null : _emergencyContactController.text,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.driver != null
                ? 'Driver updated successfully'
                : 'Driver added successfully'),
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

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Driver'),
        content: Text('Are you sure you want to delete ${widget.driver!.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(driverServiceProvider).deleteDriver(widget.driver!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Driver deleted successfully')),
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
