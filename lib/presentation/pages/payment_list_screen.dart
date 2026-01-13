import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/payment_provider.dart';
import 'payment_form_screen.dart';
import 'ai_entry_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class PaymentListScreen extends ConsumerStatefulWidget {
  const PaymentListScreen({super.key});

  @override
  ConsumerState<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends ConsumerState<PaymentListScreen> {
  final _searchController = TextEditingController();
  String? _selectedFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Payment> _filterPayments(List<Payment> payments) {
    var filtered = payments;

    if (_selectedFilter != null) {
      filtered = filtered.where((payment) => payment.type == _selectedFilter).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((payment) {
        return payment.type.toLowerCase().contains(query) ||
            payment.mode.toLowerCase().contains(query) ||
            payment.notes?.toLowerCase().contains(query) == true;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final paymentsAsync = ref.watch(paymentListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
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
          AppSearchBar(
            controller: _searchController,
            hintText: 'Search payments by type, mode, notes...',
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
          FilterChipBar(
            filters: const [
              FilterChipData(
                label: 'Advance',
                value: 'ADVANCE',
                color: AppTheme.infoColor,
              ),
              FilterChipData(
                label: 'Balance',
                value: 'BALANCE',
                color: AppTheme.warningColor,
              ),
              FilterChipData(
                label: 'Full',
                value: 'FULL',
                color: AppTheme.successColor,
              ),
            ],
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
            },
          ),
          Expanded(
            child: paymentsAsync.when(
              data: (paymentList) {
                final filteredPayments = _filterPayments(paymentList);
                return filteredPayments.isEmpty
                    ? _buildEmptyState(context)
                    : _buildPaymentList(context, filteredPayments);
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
              builder: (context) => const PaymentFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.payment,
      title: 'No payments added yet',
      subtitle: 'Add your first payment to get started',
      primaryAction: AppPrimaryButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PaymentFormScreen(),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Add Payment'),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentList(BuildContext context, List<Payment> payments) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: PanelCard(
        padding: const EdgeInsets.all(AppTheme.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    payment.type,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                StatusPill(
                  label: payment.mode,
                  color: AppTheme.infoColor,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceSm),
            Text(
              '₹${payment.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.successColor,
              ),
            ),
            if (payment.notes != null && payment.notes!.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spaceSm),
              Text(
                payment.notes!,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
