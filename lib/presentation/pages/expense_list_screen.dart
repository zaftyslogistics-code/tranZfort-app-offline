import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/expense_provider.dart';
import 'expense_form_screen.dart';
import 'ai_entry_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  final _searchController = TextEditingController();
  String? _selectedFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Expense> _filterExpenses(List<Expense> expenses) {
    var filtered = expenses;

    // Apply category filter
    if (_selectedFilter != null) {
      filtered = filtered.where((expense) => expense.category == _selectedFilter).toList();
    }

    // Apply search query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((expense) {
        return expense.category.toLowerCase().contains(query) ||
            expense.notes?.toLowerCase().contains(query) == true ||
            expense.paidMode.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AiEntryScreen(),
                ),
              );
            },
            tooltip: 'AI Assistant',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          AppSearchBar(
            controller: _searchController,
            hintText: 'Search expenses by category, notes...',
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            onClear: () {
              setState(() {
                _searchQuery = '';
              });
            },
          ),
          // Filter chips
          FilterChipBar(
            filters: const [
              FilterChipData(
                label: 'Fuel',
                value: 'FUEL',
                color: AppTheme.warningColor,
              ),
              FilterChipData(
                label: 'Toll',
                value: 'TOLL',
                color: AppTheme.infoColor,
              ),
              FilterChipData(
                label: 'Maintenance',
                value: 'MAINTENANCE',
                color: AppTheme.dangerColor,
              ),
              FilterChipData(
                label: 'Other',
                value: 'OTHER',
                color: AppTheme.accentColor,
              ),
            ],
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          // Expense list
          Expanded(
            child: expensesAsync.when(
              data: (expenseList) {
                final filteredExpenses = _filterExpenses(expenseList);
                return filteredExpenses.isEmpty
                    ? _buildEmptyState(context)
                    : _buildExpenseList(context, filteredExpenses);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ExpenseFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.receipt_long,
      title: 'No expenses added yet',
      subtitle: 'Add your first expense to get started',
      primaryAction: AppPrimaryButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ExpenseFormScreen(),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Add Expense'),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context, List<Expense> expenses) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return _ExpenseCard(expense: expense);
      },
    );
  }
}

class _ExpenseCard extends ConsumerWidget {
  final Expense expense;

  const _ExpenseCard({required this.expense});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(expenseServiceProvider);
    final expenseSummary = service.getExpenseSummary(expense);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryColor = _getCategoryColor(expense.category);
    final hasBill = expenseSummary['hasBill'] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(expense.id),
        background: Container(
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Icon(Icons.edit, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Edit',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: colorScheme.error.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Delete',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.delete, color: colorScheme.error),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ExpenseFormScreen(expense: expense),
              ),
            );
            ref.invalidate(expenseListProvider);
            ref.invalidate(expenseStatsProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Expense'),
              content: const Text('Are you sure you want to delete this expense?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(foregroundColor: AppTheme.dangerColor),
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          return confirm ?? false;
        },
        onDismissed: (direction) async {
          try {
            await ref.read(expenseServiceProvider).deleteExpense(expense.id);
            ref.invalidate(expenseListProvider);
            ref.invalidate(expenseStatsProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Expense deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(expenseListProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        child: PanelCard(
          padding: const EdgeInsets.all(AppTheme.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: categoryColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: categoryColor.withOpacity(0.35)),
                ),
                child: Icon(
                  _getCategoryIcon(expense.category),
                  color: categoryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            expense.category,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusPill(label: expense.paidMode, color: AppTheme.infoColor),
                        if (hasBill) ...[
                          const SizedBox(width: 8),
                          StatusPill(label: 'Bill', color: AppTheme.successColor),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceSm),
                    if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                      const SizedBox(height: AppTheme.spaceXs),
                      _MetaRow(
                        icon: Icons.notes,
                        label: expense.notes!,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expenseSummary['formattedAmount'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FUEL':
        return AppTheme.warningColor;
      case 'TOLL':
        return Colors.blue;
      case 'MAINTENANCE':
        return Colors.orange;
      case 'DRIVER_SALARY':
        return Colors.purple;
      case 'PARKING':
        return Colors.brown;
      case 'FOOD':
        return Colors.green;
      case 'ACCOMMODATION':
        return Colors.teal;
      default:
        return Colors.grey;
    }
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

}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaRow({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: colorScheme.onSurface.withOpacity(0.75),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.75),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
