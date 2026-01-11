import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/document_provider.dart';
import '../providers/vehicle_provider.dart';
import '../providers/driver_provider.dart';
import '../providers/party_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/payment_provider.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';

class DocumentFormScreen extends ConsumerStatefulWidget {
  final Document? document;

  const DocumentFormScreen({super.key, this.document});

  @override
  ConsumerState<DocumentFormScreen> createState() => _DocumentFormScreenState();
}

class _DocumentFormScreenState extends ConsumerState<DocumentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _filePathController = TextEditingController();

  String? _selectedDocumentType;
  String? _selectedEntityType;
  String? _selectedEntityId;
  String? _capturedFilePath;

  @override
  void initState() {
    super.initState();
    if (widget.document != null) {
      _populateFields(widget.document!);
    }
  }

  void _populateFields(Document document) {
    _nameController.text = document.name;
    _descriptionController.text = document.description;
    _filePathController.text = document.filePath;
    _selectedDocumentType = document.type;
    _selectedEntityType = document.entityType;
    _selectedEntityId = document.entityId;
    _capturedFilePath = document.filePath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _filePathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.document != null;
    final documentTypes = ref.watch(predefinedDocumentTypesProvider);
    final entityTypes = ref.watch(predefinedEntityTypesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Document' : 'Add Document'),
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
              // Document Information Section
              _buildSectionHeader('Document Information'),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Document Name',
                  hintText: 'e.g., Vehicle Registration Certificate',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter document name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedDocumentType,
                decoration: const InputDecoration(
                  labelText: 'Document Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: documentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getDocumentTypeIcon(type), size: 16),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDocumentType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select document type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Document description or notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Entity Selection Section
              _buildSectionHeader('Entity Association'),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedEntityType,
                decoration: const InputDecoration(
                  labelText: 'Entity Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.folder),
                ),
                items: entityTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getEntityTypeIcon(type), size: 16),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEntityType = value;
                    _selectedEntityId = null; // Reset entity ID when type changes
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select entity type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildEntitySelection(),

              const SizedBox(height: 24),

              // File Selection Section
              _buildSectionHeader('File Selection'),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Document File',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_capturedFilePath != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppTheme.successColor, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _capturedFilePath!.split('/').last,
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: View file
                              },
                              child: const Text('View'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _capturedFilePath = null;
                                  _filePathController.clear();
                                });
                              },
                              child: const Text('Remove'),
                            ),
                          ],
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Text('No file selected'),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              _captureDocument();
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              _selectDocument();
                            },
                            icon: const Icon(Icons.file_upload),
                            label: const Text('Browse'),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveDocument,
                  child: Text(isEditing ? 'Update Document' : 'Add Document'),
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

  Widget _buildEntitySelection() {
    if (_selectedEntityType == null) {
      return const SizedBox.shrink();
    }

    switch (_selectedEntityType) {
      case 'VEHICLE':
        return Consumer(
          builder: (context, ref, child) {
            final vehicles = ref.watch(vehicleListProvider);
            return vehicles.when(
              data: (vehicleList) => DropdownButtonFormField<String>(
                value: _selectedEntityId,
                decoration: const InputDecoration(
                  labelText: 'Select Vehicle',
                  border: OutlineInputBorder(),
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
                    _selectedEntityId = value;
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
              error: (error, stack) => Center(child: Text('Error loading vehicles')),
            );
          },
        );
      case 'DRIVER':
        return Consumer(
          builder: (context, ref, child) {
            final drivers = ref.watch(driverListProvider);
            return drivers.when(
              data: (driverList) => DropdownButtonFormField<String>(
                value: _selectedEntityId,
                decoration: const InputDecoration(
                  labelText: 'Select Driver',
                  border: OutlineInputBorder(),
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
                    _selectedEntityId = value;
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
              error: (error, stack) => Center(child: Text('Error loading drivers')),
            );
          },
        );
      case 'PARTY':
        return Consumer(
          builder: (context, ref, child) {
            final parties = ref.watch(partyListProvider);
            return parties.when(
              data: (partyList) => DropdownButtonFormField<String>(
                value: _selectedEntityId,
                decoration: const InputDecoration(
                  labelText: 'Select Party',
                  border: OutlineInputBorder(),
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
                    _selectedEntityId = value;
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
              error: (error, stack) => Center(child: Text('Error loading parties')),
            );
          },
        );
      case 'TRIP':
        return Consumer(
          builder: (context, ref, child) {
            final trips = ref.watch(tripListProvider);
            return trips.when(
              data: (tripList) => DropdownButtonFormField<String>(
                value: _selectedEntityId,
                decoration: const InputDecoration(
                  labelText: 'Select Trip',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions),
                ),
                items: tripList.map((trip) {
                  return DropdownMenuItem(
                    value: trip.id,
                    child: Text('${trip.fromLocation} → ${trip.toLocation}'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedEntityId = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a trip';
                  }
                  return null;
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error loading trips')),
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  IconData _getDocumentTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'VEHICLE_REGISTRATION':
        return Icons.directions_car;
      case 'VEHICLE_INSURANCE':
        return Icons.security;
      case 'DRIVER_LICENSE':
        return Icons.badge;
      case 'DRIVER_ID_PROOF':
        return Icons.person;
      case 'PARTY_GST_CERTIFICATE':
        return Icons.receipt;
      case 'PARTY_PAN_CARD':
        return Icons.credit_card;
      case 'PARTY_AADHAR_CARD':
        return Icons.fingerprint;
      case 'TRIP_DOCUMENT':
        return Icons.map;
      case 'EXPENSE_BILL':
        return Icons.receipt_long;
      case 'PAYMENT_RECEIPT':
        return Icons.account_balance_wallet;
      case 'AGREEMENT':
        return Icons.description;
      case 'PERMIT':
        return Icons.verified;
      default:
        return Icons.insert_drive_file;
    }
  }

  IconData _getEntityTypeIcon(String entityType) {
    switch (entityType.toUpperCase()) {
      case 'VEHICLE':
        return Icons.local_shipping;
      case 'DRIVER':
        return Icons.people;
      case 'PARTY':
        return Icons.business;
      case 'TRIP':
        return Icons.directions;
      case 'EXPENSE':
        return Icons.receipt_long;
      case 'PAYMENT':
        return Icons.account_balance_wallet;
      default:
        return Icons.folder;
    }
  }

  void _captureDocument() {
    // TODO: Implement document capture
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Document capture feature coming soon')),
    );
  }

  void _selectDocument() {
    // TODO: Implement file selection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File selection feature coming soon')),
    );
  }

  Future<void> _saveDocument() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_capturedFilePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a document file')),
      );
      return;
    }

    try {
      final service = ref.read(documentServiceProvider);

      if (widget.document != null) {
        // Update existing document
        await service.updateDocument(
          id: widget.document!.id,
          name: _nameController.text,
          type: _selectedDocumentType!,
          entityType: _selectedEntityType!,
          entityId: _selectedEntityId!,
          filePath: _capturedFilePath!,
          description: _descriptionController.text.isEmpty ? '' : _descriptionController.text,
        );
      } else {
        // Create new document
        await service.createDocument(
          name: _nameController.text,
          type: _selectedDocumentType!,
          entityType: _selectedEntityType!,
          entityId: _selectedEntityId!,
          filePath: _capturedFilePath!,
          description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.document != null
                ? 'Document updated successfully'
                : 'Document added successfully'),
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
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete this document?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(documentServiceProvider).deleteDocument(widget.document!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Document deleted successfully')),
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
