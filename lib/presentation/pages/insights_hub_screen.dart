import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/insights_snapshot.dart';
import '../providers/insights_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';
import 'ai_entry_screen.dart';

class InsightsHubScreen extends ConsumerWidget {
  const InsightsHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final snapshotAsync = ref.watch(insightsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
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
      body: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Unable to load insights',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => ref.invalidate(insightsProvider),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        },
        data: (snapshot) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(insightsProvider);
              await ref.read(insightsProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(AppTheme.spaceLg),
              children: [
                const AppSectionHeader(title: 'Financial Overview'),
                _MonthSummaryCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.spaceXl),
                const AppSectionHeader(title: 'Performance Insights'),
                _ProfitTrendCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.spaceLg),
                _ExpenseBreakdownCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.spaceLg),
                _TopRoutesCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.spaceXl),
                const AppSectionHeader(title: 'Resource Utilization'),
                _VehicleUtilizationCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.spaceLg),
                _DriverPerformanceCard(snapshot: snapshot),
                const SizedBox(height: AppTheme.space2xl),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MonthSummaryCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _MonthSummaryCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final latest = snapshot.cashFlow.isNotEmpty ? snapshot.cashFlow.last : null;
    final income = latest?.income ?? 0;
    final expenses = latest?.expenses ?? 0;
    final net = latest?.netCashFlow ?? (income - expenses);

    return PanelCard(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Month summary',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppTheme.spaceMd),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Income',
                  value: _formatCurrency(income),
                  icon: Icons.trending_up,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: _MetricTile(
                  label: 'Expenses',
                  value: _formatCurrency(expenses),
                  icon: Icons.trending_down,
                ),
              ),
              const SizedBox(width: AppTheme.spaceMd),
              Expanded(
                child: _MetricTile(
                  label: 'Net',
                  value: _formatCurrency(net),
                  icon: Icons.account_balance,
                ),
              ),
            ],
          ),
          if (latest != null) ...[
            const SizedBox(height: AppTheme.spaceSm),
            Text(
              'Period: ${latest.month}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProfitTrendCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _ProfitTrendCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final data = snapshot.profitTrend;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profit trend',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (data.isEmpty)
              Text('No data', style: theme.textTheme.bodySmall)
            else
              Column(
                children: data
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.month)),
                            Text(_formatCurrency(e.profit)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseBreakdownCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _ExpenseBreakdownCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entries = snapshot.expenseBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Expense breakdown',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text('No expenses found', style: theme.textTheme.bodySmall)
            else
              Column(
                children: entries
                    .take(8)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.key)),
                            Text(_formatCurrency(e.value)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _TopRoutesCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _TopRoutesCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final routes = snapshot.routeProfitability;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top routes',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (routes.isEmpty)
              Text('No trips found', style: theme.textTheme.bodySmall)
            else
              Column(
                children: routes
                    .take(5)
                    .map(
                      (r) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(r.route)),
                            Text(_formatCurrency(r.totalProfit)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _VehicleUtilizationCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _VehicleUtilizationCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final entries = snapshot.vehicleUtilization.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vehicle utilization (30 days)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (entries.isEmpty)
              Text('No vehicles found', style: theme.textTheme.bodySmall)
            else
              Column(
                children: entries
                    .take(6)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(e.key)),
                            Text('${e.value.toStringAsFixed(0)}%'),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _DriverPerformanceCard extends StatelessWidget {
  final InsightsSnapshot snapshot;

  const _DriverPerformanceCard({
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final drivers = snapshot.driverPerformance;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver performance',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (drivers.isEmpty)
              Text('No drivers found', style: theme.textTheme.bodySmall)
            else
              Column(
                children: drivers
                    .take(6)
                    .map(
                      (d) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(d.driverName)),
                            Text('${d.tripCount} trips'),
                            const SizedBox(width: 12),
                            Text(_formatCurrency(d.totalProfit)),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

String _formatCurrency(double value) {
  final rounded = value.round();
  return '₹$rounded';
}
