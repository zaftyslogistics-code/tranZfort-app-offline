import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/suggestion_provider.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../domain/services/voice_input_service.dart';
import '../widgets/voice_input_button.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  final Expense? expense;

  const ExpenseFormScreen({super.key, this.expense});

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedTripId;
  String? _selectedCategory;
  String? _selectedPaymentMode;
  String? _billImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _populateFields(widget.expense!);
    }
  }

  void _populateFields(Expense expense) {
    _amountController.text = expense.amount.toString();
    _notesController.text = expense.notes ?? '';
    _selectedTripId = expense.tripId;
    _selectedCategory = expense.category;
    _selectedPaymentMode = expense.paidMode;
    _billImagePath = expense.billImagePath;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleVoiceInput(String text) {
    final voiceService = VoiceInputService();
    final command = voiceService.parseExpenseCommand(text);

    if (command != null) {
      setState(() {
        if (command.amount > 0) {
          _amountController.text = command.amount.toString();
        }
        if (command.category != null) {
          _selectedCategory = command.category;
        }
        if (command.notes.isNotEmpty) {
          _notesController.text = command.notes;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Voice input processed: ${command.notes}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not parse expense from voice input'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;
    final trips = ref.watch(tripListProvider);
    final categories = ref.watch(predefinedCategoriesProvider);
    final paymentModes = ref.watch(predefinedPaymentModesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Expense' : 'Add Expense'),
        actions: [
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Voice Expense Entry',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Say something like:\n"Add fuel expense 2000 rupees"\n"Toll expense 500"',
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trip Selection Section
              _buildSectionHeader('Trip Information'),
              const SizedBox(height: 16),
              
              trips.when(
                data: (tripList) => DropdownButtonFormField<String>(
                  value: _selectedTripId,
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
                      _selectedTripId = value;
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
              ),

              const SizedBox(height: 24),

              // Expense Information Section
              _buildSectionHeader('Expense Details'),
              const SizedBox(height: 16),

              // Notes field (moved up for auto-categorization)
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Fuel at Panipat toll, Lunch at dhaba',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
                onChanged: (value) {
                  // Auto-detect category from description
                  if (_selectedCategory == null && value.isNotEmpty) {
                    final suggestedCategory = ref.read(suggestionServiceProvider)
                        .suggestExpenseCategory(value);
                    if (suggestedCategory.isNotEmpty) {
                      setState(() {
                        _selectedCategory = suggestedCategory;
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 16),

              // Category suggestion chip
              if (_selectedCategory != null && _notesController.text.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Auto-detected category: $_selectedCategory',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Row(
                      children: [
                        Icon(_getCategoryIcon(category), size: 16),
                        const SizedBox(width: 8),
                        Text(category),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  hintText: 'e.g., 1500',
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

              // Bill Attachment Section
              _buildSectionHeader('Bill Attachment'),
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
                          Icons.receipt,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bill Image',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_billImagePath != null)
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
                            const Text('Bill attached'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                // TODO: View bill image
                              },
                              child: const Text('View'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _billImagePath = null;
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
                          const Text('No bill attached'),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Capture bill image
                              _captureBillImage();
                            },
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Capture'),
                          ),
                        ],
                      ),
                  ],
                ),
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
                  onPressed: _saveExpense,
                  child: Text(isEditing ? 'Update Expense' : 'Add Expense'),
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

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'FUEL':
        return Icons.local_gas_station;
      case 'TOLL':
        return Icons.toll;
      case 'MAINTENANCE':
        return Icons.build;
      case 'DRIVER_SALARY':
        return Icons.person;
      case 'PARKING':
        return Icons.local_parking;
      case 'FOOD':
        return Icons.restaurant;
      case 'ACCOMMODATION':
        return Icons.hotel;
      default:
        return Icons.receipt_long;
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
      default:
        return Icons.help;
    }
  }

  void _captureBillImage() {
    // TODO: Implement bill image capture
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bill capture feature coming soon')),
    );
  }

  Future<void> _saveExpense() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final service = ref.read(expenseServiceProvider);
      final amount = double.parse(_amountController.text);

      if (widget.expense != null) {
        // Update existing expense
        await service.updateExpense(
          id: widget.expense!.id,
          tripId: _selectedTripId!,
          category: _selectedCategory!,
          amount: amount,
          paidMode: _selectedPaymentMode!,
          billImagePath: _billImagePath,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      } else {
        // Create new expense
        await service.createExpense(
          tripId: _selectedTripId!,
          category: _selectedCategory!,
          amount: amount,
          paidMode: _selectedPaymentMode!,
          billImagePath: _billImagePath,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
        );
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.expense != null
                ? 'Expense updated successfully'
                : 'Expense added successfully'),
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
        title: const Text('Delete Expense'),
        content: Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              try {
                await ref.read(expenseServiceProvider).deleteExpense(widget.expense!.id);
                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Expense deleted successfully')),
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
