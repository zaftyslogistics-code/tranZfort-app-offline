import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payment_provider.dart';
import 'payment_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class PaymentListScreen extends ConsumerWidget {
  const PaymentListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final payments = ref.watch(paymentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'all':
                  // TODO: Show all payments
                  break;
                case 'by_type':
                  // TODO: Show type filter
                  break;
                case 'by_mode':
                  // TODO: Show mode filter
                  break;
                case 'by_party':
                  // TODO: Show party filter
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',
                child: Row(
                  children: [
                    Icon(Icons.list, size: 16),
                    SizedBox(width: 8),
                    Text('All Payments'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'by_type',
                child: Row(
                  children: [
                    Icon(Icons.category, size: 16),
                    SizedBox(width: 8),
                    Text('By Type'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'by_mode',
                child: Row(
                  children: [
                    Icon(Icons.payment, size: 16),
                    SizedBox(width: 8),
                    Text('By Mode'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'by_party',
                child: Row(
                  children: [
                    Icon(Icons.business, size: 16),
                    SizedBox(width: 8),
                    Text('By Party'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: payments.when(
        data: (paymentList) => paymentList.isEmpty
            ? _buildEmptyState(context)
            : _buildPaymentList(context, paymentList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PaymentFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: AppTheme.successGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No payments added yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first payment to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PaymentFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Payment'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentList(BuildContext context, List<Payment> payments) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _PaymentCard(payment: payment);
      },
    );
  }
}

class _PaymentCard extends ConsumerWidget {
  final Payment payment;

  const _PaymentCard({required this.payment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(paymentServiceProvider);
    final paymentSummary = service.getPaymentSummary(payment);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final typeColor = _getPaymentTypeColor(payment.type);
    final modeColor = _getPaymentModeColor(payment.mode);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(payment.id),
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
                builder: (context) => PaymentFormScreen(payment: payment),
              ),
            );
            ref.invalidate(paymentListProvider);
            ref.invalidate(paymentStatsProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Payment'),
              content: const Text('Are you sure you want to delete this payment?'),
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
            await ref.read(paymentServiceProvider).deletePayment(payment.id);
            ref.invalidate(paymentListProvider);
            ref.invalidate(paymentStatsProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(paymentListProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: $e')),
              );
            }
          }
        },
        child: PanelCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: typeColor.withOpacity(0.35)),
                ),
                child: Icon(
                  _getPaymentTypeIcon(payment.type),
                  color: typeColor,
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
                            payment.type,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusPill(label: payment.mode, color: modeColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _MetaRow(
                      icon: Icons.calendar_today,
                      label: paymentSummary['formattedDate'],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    paymentSummary['formattedAmount'],
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

  Color _getPaymentTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'ADVANCE':
        return AppTheme.infoColor;
      case 'BALANCE':
        return AppTheme.successColor;
      case 'EXPENSE_REIMBURSEMENT':
        return AppTheme.warningColor;
      case 'PENALTY':
        return AppTheme.dangerColor;
      case 'BONUS':
        return Colors.purple;
      default:
        return Colors.grey;
    }
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

  Color _getPaymentModeColor(String mode) {
    switch (mode.toUpperCase()) {
      case 'CASH':
        return Colors.green;
      case 'BANK_TRANSFER':
        return Colors.blue;
      case 'CHEQUE':
        return Colors.orange;
      case 'ONLINE':
        return Colors.purple;
      case 'CREDIT_CARD':
        return Colors.red;
      case 'UPI':
        return Colors.teal;
      case 'NET_BANKING':
        return Colors.indigo;
      default:
        return Colors.grey;
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
