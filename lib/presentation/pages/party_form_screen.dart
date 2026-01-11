import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/party_provider.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';

class PartyFormScreen extends ConsumerStatefulWidget {
  final Party? party;

  const PartyFormScreen({super.key, this.party});

  @override
  ConsumerState<PartyFormScreen> createState() => _PartyFormScreenState();
}

class _PartyFormScreenState extends ConsumerState<PartyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cityController = TextEditingController();
  final _gstController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.party != null) {
      _populateFields(widget.party!);
    }
  }

  void _populateFields(Party party) {
    _nameController.text = party.name;
    _mobileController.text = party.mobile;
    _cityController.text = party.city;
    _gstController.text = party.gst ?? '';
    _notesController.text = party.notes ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    _gstController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.party != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Party' : 'Add Party'),
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
                  labelText: 'Party Name',
                  hintText: 'e.g., ABC Transport Company',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter party name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  hintText: 'e.g., +91 9876543210',
                  border: OutlineInputBorder(),
                  helperText: '10 digits with optional country code',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  final service = ref.read(partyServiceProvider);
                  if (!service.isValidMobile(value)) {
                    return 'Please enter a valid mobile number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  hintText: 'e.g., Mumbai',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // GST Information Section
              _buildSectionHeader('GST Information'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _gstController,
                decoration: const InputDecoration(
                  labelText: 'GST Number (Optional)',
                  hintText: 'e.g., 27AAAPL1234C1ZV',
                  border: OutlineInputBorder(),
                  helperText: 'Format: 27AAAPL1234C1ZV',
                  suffixIcon: Icon(Icons.verified),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final service = ref.read(partyServiceProvider);
                    if (!service.isValidGst(value)) {
                      return 'Please enter a valid GST number';
                    }
                  }
                  return null;
                },
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
                  onPressed: _saveParty,
                  child: Text(isEditing ? 'Update Party' : 'Add Party'),
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

  Future<void> _saveParty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(partyServiceProvider);

      // Check for unique mobile number
      final isMobileUnique = await service.isMobileUnique(
        _mobileController.text,
        excludeId: widget.party?.id,
      );
      
      // Check for unique GST number (if provided)
      String? gstValue = _gstController.text.isEmpty ? null : _gstController.text;
      bool isGstUnique = true;
      if (gstValue != null) {
        isGstUnique = await service.isGstUnique(gstValue, excludeId: widget.party?.id);
      }

      if (!isMobileUnique) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mobile number already exists')),
          );
        }
        return;
      }

      if (!isGstUnique) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('GST number already exists')),
          );
        }
        return;
      }

      if (widget.party != null) {
        // Update existing party
        await service.updateParty(
          id: widget.party!.id,
          name: _nameController.text,
          mobile: service.formatMobileNumber(_mobileController.text),
          city: _cityController.text,
          gst: gstValue,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      } else {
        // Create new party
        await service.createParty(
          name: _nameController.text,
          mobile: service.formatMobileNumber(_mobileController.text),
          city: _cityController.text,
          gst: gstValue,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.party != null
                ? 'Party updated successfully'
                : 'Party added successfully'),
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
        title: const Text('Delete Party'),
        content: Text('Are you sure you want to delete ${widget.party!.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(partyServiceProvider).deleteParty(widget.party!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Party deleted successfully')),
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
