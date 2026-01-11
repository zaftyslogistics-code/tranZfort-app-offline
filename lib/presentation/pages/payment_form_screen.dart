import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payment_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/party_provider.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';

class PaymentFormScreen extends ConsumerStatefulWidget {
  final Payment? payment;

  const PaymentFormScreen({super.key, this.payment});

  @override
  ConsumerState<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends ConsumerState<PaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedPartyId;
  String? _selectedTripId;
  String? _selectedPaymentType;
  String? _selectedPaymentMode;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    if (widget.payment != null) {
      _populateFields(widget.payment!);
    }
  }

  void _populateFields(Payment payment) {
    _amountController.text = payment.amount.toString();
    _notesController.text = payment.notes ?? '';
    _selectedPartyId = payment.partyId;
    _selectedTripId = payment.tripId;
    _selectedPaymentType = payment.type;
    _selectedPaymentMode = payment.mode;
    _selectedDate = payment.date;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.payment != null;
    final parties = ref.watch(partyListProvider);
    final trips = ref.watch(tripListProvider);
    final paymentTypes = ref.watch(predefinedPaymentTypesProvider);
    final paymentModes = ref.watch(predefinedPaymentModesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Payment' : 'Add Payment'),
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
              // Payment Information Section
              _buildSectionHeader('Payment Information'),
              const SizedBox(height: 16),
              
              parties.when(
                data: (partyList) => DropdownButtonFormField<String>(
                  value: _selectedPartyId,
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
                error: (error, stack) => Center(child: Text('Error loading parties')),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: 'e.g., 50000',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPaymentType,
                decoration: const InputDecoration(
                  labelText: 'Payment Type',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: paymentTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getPaymentTypeIcon(type), size: 16),
                        const SizedBox(width: 8),
                        Text(type),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentType = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select payment type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedPaymentMode,
                decoration: const InputDecoration(
                  labelText: 'Payment Mode',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.payment),
                ),
                items: paymentModes.map((mode) {
                  return DropdownMenuItem(
                    value: mode,
                    child: Row(
                      children: [
                        Icon(_getPaymentModeIcon(mode), size: 16),
                        const SizedBox(width: 8),
                        Text(mode),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMode = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select payment mode';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // Trip Selection Section
              _buildSectionHeader('Trip Information'),
              const SizedBox(height: 16),
              
              trips.when(
                data: (tripList) => DropdownButtonFormField<String>(
                  value: _selectedTripId,
                  decoration: const InputDecoration(
                    labelText: 'Select Trip (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.directions),
                    helperText: 'Leave empty if not linked to a trip',
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: '',
                      child: Text('No Trip'),
                    ),
                    ...tripList.map((trip) {
                      return DropdownMenuItem(
                        value: trip.id,
                        child: Text('${trip.fromLocation} → ${trip.toLocation}'),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedTripId = value?.isEmpty == true ? null : value;
                    });
                  },
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(child: Text('Error loading trips')),
              ),

              const SizedBox(height: 24),

              // Date Selection Section
              _buildSectionHeader('Date Information'),
              const SizedBox(height: 16),

              _buildDateSelector(
                'Payment Date',
                _selectedDate,
                (date) => setState(() => _selectedDate = date),
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
                  onPressed: _savePayment,
                  child: Text(isEditing ? 'Update Payment' : 'Add Payment'),
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
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
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

  IconData _getPaymentTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'ADVANCE':
        return Icons.payments;
      case 'BALANCE':
        return Icons.account_balance_wallet;
      case 'EXPENSE_REIMBURSEMENT':
        return Icons.receipt_long;
      case 'PENALTY':
        return Icons.warning;
      case 'BONUS':
        return Icons.stars;
      default:
        return Icons.help;
    }
  }

  IconData _getPaymentModeIcon(String mode) {
    switch (mode.toUpperCase()) {
      case 'CASH':
        return Icons.payments;
      case 'BANK_TRANSFER':
        return Icons.account_balance;
      case 'CHEQUE':
        return Icons.description;
      case 'ONLINE':
        return Icons.language;
      case 'CREDIT_CARD':
        return Icons.credit_card;
      case 'UPI':
        return Icons.qr_code_scanner;
      case 'NET_BANKING':
        return Icons.account_balance;
      default:
        return Icons.help;
    }
  }

  Future<void> _savePayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(paymentServiceProvider);
      final amount = double.parse(_amountController.text);

      if (widget.payment != null) {
        // Update existing payment
        await service.updatePayment(
          id: widget.payment!.id,
          partyId: _selectedPartyId!,
          amount: amount,
          type: _selectedPaymentType!,
          mode: _selectedPaymentMode!,
          tripId: _selectedTripId,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          date: _selectedDate,
        );
      } else {
        // Create new payment
        await service.createPayment(
          partyId: _selectedPartyId!,
          amount: amount,
          type: _selectedPaymentType!,
          mode: _selectedPaymentMode!,
          tripId: _selectedTripId,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          date: _selectedDate,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.payment != null
                ? 'Payment updated successfully'
                : 'Payment added successfully'),
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
        title: const Text('Delete Payment'),
        content: Text('Are you sure you want to delete this payment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(paymentServiceProvider).deletePayment(widget.payment!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment deleted successfully')),
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
