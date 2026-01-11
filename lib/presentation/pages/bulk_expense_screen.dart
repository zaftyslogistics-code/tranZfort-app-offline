import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' hide Column;
import '../../data/database.dart';
import '../providers/database_provider.dart';
import '../providers/trip_provider.dart';
import '../providers/expense_provider.dart';
import '../providers/suggestion_provider.dart';

/// Bulk Expense Entry Screen
/// Allows users to add multiple expenses at once for efficiency
class BulkExpenseScreen extends ConsumerStatefulWidget {
  final String? tripId;

  const BulkExpenseScreen({super.key, this.tripId});

  @override
  ConsumerState<BulkExpenseScreen> createState() => _BulkExpenseScreenState();
}

class _BulkExpenseScreenState extends ConsumerState<BulkExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedTripId;
  final List<ExpenseEntry> _expenses = [];

  @override
  void initState() {
    super.initState();
    _selectedTripId = widget.tripId;
    _addExpenseRow();
  }

  void _addExpenseRow() {
    setState(() {
      _expenses.add(ExpenseEntry());
    });
  }

  void _removeExpenseRow(int index) {
    setState(() {
      _expenses.removeAt(index);
    });
  }

  Future<void> _saveAllExpenses() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTripId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a trip')),
      );
      return;
    }

    // Validate all expenses
    for (final expense in _expenses) {
      if (expense.category == null || expense.amount == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all expense details')),
        );
        return;
      }
    }

    try {
      final database = ref.read(databaseProvider);
      
      // Save all expenses in a batch
      for (final expense in _expenses) {
        final entry = ExpensesCompanion.insert(
          id: const Uuid().v4(),
          tripId: _selectedTripId!,
          category: expense.category!,
          amount: expense.amount!,
          paidMode: expense.paymentMode ?? 'CASH',
          notes: Value(expense.notes),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await database.into(database.expenses).insert(entry);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${_expenses.length} expenses saved successfully')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving expenses: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trips = ref.watch(tripListProvider);
    final categories = ref.watch(predefinedCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Expense Entry'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addExpenseRow,
            tooltip: 'Add Row',
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Trip Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: trips.when(
                data: (tripList) => DropdownButtonFormField<String>(
                  value: _selectedTripId,
                  decoration: const InputDecoration(
                    labelText: 'Select Trip',
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
                error: (error, stack) => Text('Error loading trips: $error'),
              ),
            ),

            // Expense List Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.receipt_long,
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_expenses.length} Expenses',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Total: ₹${_calculateTotal().toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Expense Rows
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _expenses.length,
                itemBuilder: (context, index) {
                  return _buildExpenseRow(index, categories);
                },
              ),
            ),

            // Save Button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addExpenseRow,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Row'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _saveAllExpenses,
                      icon: const Icon(Icons.save),
                      label: Text('Save ${_expenses.length} Expenses'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
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

  Widget _buildExpenseRow(int index, List<String> categories) {
    final theme = Theme.of(context);
    final expense = _expenses[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                if (_expenses.length > 1)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _removeExpenseRow(index),
                    color: theme.colorScheme.error,
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Fuel at toll plaza',
                prefixIcon: Icon(Icons.description),
                isDense: true,
              ),
              onChanged: (value) {
                expense.notes = value;
                // Auto-detect category
                if (expense.category == null && value.isNotEmpty) {
                  final suggested = ref.read(suggestionServiceProvider)
                      .suggestExpenseCategory(value);
                  setState(() {
                    expense.category = suggested;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // Category
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: expense.category,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      prefixIcon: Icon(Icons.category),
                      isDense: true,
                    ),
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category, style: const TextStyle(fontSize: 14)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        expense.category = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Amount
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixText: '₹',
                      isDense: true,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      expense.amount = double.tryParse(value);
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  double _calculateTotal() {
    double total = 0;
    for (final expense in _expenses) {
      total += expense.amount ?? 0;
    }
    return total;
  }
}

/// Expense Entry Model
class ExpenseEntry {
  String? category;
  double? amount;
  String? paymentMode;
  String? notes;

  ExpenseEntry({
    this.category,
    this.amount,
    this.paymentMode = 'CASH',
    this.notes,
  });
}
