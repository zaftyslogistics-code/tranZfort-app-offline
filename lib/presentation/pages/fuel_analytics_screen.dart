import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/database_provider.dart';
import '../providers/fuel_analytics_provider.dart';

/// Fuel Analytics Dashboard
/// Shows fuel consumption trends, mileage, and cost analysis
class FuelAnalyticsScreen extends ConsumerStatefulWidget {
  const FuelAnalyticsScreen({super.key});

  @override
  ConsumerState<FuelAnalyticsScreen> createState() => _FuelAnalyticsScreenState();
}

class _FuelAnalyticsScreenState extends ConsumerState<FuelAnalyticsScreen> {
  String _selectedPeriod = 'MONTH';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summaryAsync = ref.watch(fuelAnalyticsSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Analytics'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _selectedPeriod,
            onSelected: (value) {
              setState(() {
                _selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'WEEK', child: Text('This Week')),
              const PopupMenuItem(value: 'MONTH', child: Text('This Month')),
              const PopupMenuItem(value: 'YEAR', child: Text('This Year')),
            ],
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading fuel analytics: $error'),
        ),
        data: (summary) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCards(theme, summary),
              const SizedBox(height: 24),
              _buildSectionHeader('Fuel Cost Trend', theme),
              const SizedBox(height: 16),
              _buildFuelCostChart(theme),
              const SizedBox(height: 24),
              _buildSectionHeader('Vehicle Mileage Comparison', theme),
              const SizedBox(height: 16),
              _buildMileageChart(theme),
              const SizedBox(height: 24),
              _buildSectionHeader('Efficiency Metrics', theme),
              const SizedBox(height: 16),
              _buildEfficiencyMetrics(theme, summary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards(ThemeData theme, FuelAnalyticsSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Fuel',
            '${summary.totalLiters.toStringAsFixed(0)} L',
            Icons.local_gas_station,
            theme.colorScheme.primary,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total Cost',
            '₹${summary.totalCost.toStringAsFixed(0)}',
            Icons.currency_rupee,
            Colors.orange,
            theme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Avg Mileage',
            '${summary.avgMileage.toStringAsFixed(1)} km/l',
            Icons.speed,
            Colors.green,
            theme,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildFuelCostChart(ThemeData theme) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '₹${(value / 1000).toStringAsFixed(0)}k',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                  if (value.toInt() >= 0 && value.toInt() < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: theme.textTheme.bodySmall,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                const FlSpot(0, 18000),
                const FlSpot(1, 22000),
                const FlSpot(2, 19000),
                const FlSpot(3, 25000),
                const FlSpot(4, 21000),
                const FlSpot(5, 23000),
              ],
              isCurved: true,
              color: theme.colorScheme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.colorScheme.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMileageChart(ThemeData theme) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.secondary.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 8,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()} km/l',
                    style: theme.textTheme.bodySmall,
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  const vehicles = ['DL01', 'DL02', 'DL03', 'DL04'];
                  if (value.toInt() >= 0 && value.toInt() < vehicles.length) {
                    return Text(
                      vehicles[value.toInt()],
                      style: theme.textTheme.bodySmall,
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 2,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 5.2, color: Colors.green)]),
            BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 4.8, color: Colors.orange)]),
            BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5.5, color: Colors.green)]),
            BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4.5, color: Colors.red)]),
          ],
        ),
      ),
    );
  }

  Widget _buildEfficiencyMetrics(ThemeData theme, FuelAnalyticsSummary summary) {
    return Column(
      children: [
        _buildMetricRow(
          'Average Cost per KM',
          '₹${summary.avgCostPerKm.toStringAsFixed(2)}',
          Icons.attach_money,
          Colors.orange,
          theme,
        ),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Total Distance Covered',
          '${summary.totalDistance.toStringAsFixed(0)} km',
          Icons.straighten,
          theme.colorScheme.primary,
          theme,
        ),
        const SizedBox(height: 12),
        _buildMetricRow(
          'Average Mileage',
          '${summary.avgMileage.toStringAsFixed(1)} km/l',
          Icons.speed,
          Colors.green,
          theme,
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
