import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'presentation/providers/database_provider.dart';
import 'presentation/providers/vehicle_provider.dart';
import 'presentation/providers/driver_provider.dart';
import 'presentation/providers/party_provider.dart';
import 'presentation/providers/trip_provider.dart';
import 'presentation/providers/expense_provider.dart';
import 'presentation/providers/payment_provider.dart';
import 'presentation/pages/vehicle_list_screen.dart';
import 'presentation/pages/driver_list_screen.dart';
import 'presentation/pages/party_list_screen.dart';
import 'presentation/pages/trip_list_screen.dart';
import 'presentation/pages/expense_list_screen.dart';
import 'presentation/pages/payment_list_screen.dart';
import 'presentation/pages/trip_form_screen.dart';
import 'presentation/pages/expense_form_screen.dart';
import 'presentation/pages/payment_form_screen.dart';
import 'presentation/pages/settings_screen.dart';
import 'presentation/pages/insights_hub_screen.dart';
import 'presentation/pages/ai_entry_screen.dart';
import 'presentation/widgets/quick_action_fab.dart';
import 'presentation/widgets/ai_assistant_fab.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/enhanced_widgets.dart';
import 'core/widgets/ui_components.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('pa'),
        Locale('ta'),
        Locale('te'),
        Locale('mr'),
        Locale('gu'),
        Locale('bn'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(
        child: TranzfortTMSApp(),
      ),
    ),
  );
}

class TranzfortTMSApp extends ConsumerWidget {
  const TranzfortTMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tranzfort TMS',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Simplified approach - just show the dashboard directly
    // Database will initialize when first accessed by providers
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_full.png',
          height: 40,
          width: 40,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.local_shipping, size: 40);
          },
        ),
        centerTitle: false,
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
          IconButton(
            icon: const Icon(Icons.insights),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const InsightsHubScreen(),
                ),
              );
            },
            tooltip: 'Insights',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const DashboardBody(),
      floatingActionButton: SizedBox(
        width: 160,
        height: 120,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0,
              bottom: 0,
              child: QuickActionFAB(
                onStartTrip: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const TripFormScreen(),
                    ),
                  );
                },
                onAddExpense: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ExpenseFormScreen(),
                    ),
                  );
                },
                onScanBill: () {
                  // TODO: Implement bill scanning
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bill scanning coming soon')),
                  );
                },
                onRecordPayment: () {
                  // TODO: Navigate to payment form
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment recording coming soon')),
                  );
                },
                onAddFuel: () {
                  // TODO: Navigate to fuel entry
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fuel entry coming soon')),
                  );
                },
              ),
            ),
            Positioned(
              right: 80,
              bottom: 16,
              child: AiAssistantMiniFab(),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardBody extends ConsumerWidget {
  const DashboardBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicleStats = ref.watch(vehicleStatsProvider);
    final driverStats = ref.watch(driverStatsProvider);
    final partyStats = ref.watch(partyStatsProvider);
    final tripStats = ref.watch(tripStatsProvider);
    final paymentStats = ref.watch(paymentStatsProvider);
    final expenseStats = ref.watch(expenseStatsProvider);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Tranzfort TMS',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your complete transport management solution',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppTheme.spaceXl),

          tripStats.when(
            data: (tStats) => paymentStats.when(
              data: (payStats) => expenseStats.when(
                data: (expStats) => PanelCard(
                  padding: const EdgeInsets.all(AppTheme.spaceLg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Today',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          StatusPill(
                            label: 'Active trips: ${tStats['ACTIVE'] ?? 0}',
                            color: AppTheme.primaryColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spaceMd),
                      Wrap(
                        spacing: AppTheme.spaceSm,
                        runSpacing: AppTheme.spaceSm,
                        children: [
                          StatusPill(
                            label: 'Payments: ${payStats['TOTAL'] ?? 0}',
                            color: AppTheme.successColor,
                          ),
                          StatusPill(
                            label: 'Expenses: ${expStats['TOTAL'] ?? 0}',
                            color: AppTheme.warningColor,
                          ),
                          StatusPill(
                            label: 'Completed trips: ${tStats['COMPLETED'] ?? 0}',
                            color: AppTheme.successColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stack) => const SizedBox.shrink(),
            ),
            loading: () => const SizedBox.shrink(),
            error: (error, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: AppTheme.spaceXl),
          
          // Quick Stats Cards
          vehicleStats.when(
            data: (vStats) => driverStats.when(
              data: (dStats) => partyStats.when(
                data: (pStats) => tripStats.when(
                  data: (tStats) => paymentStats.when(
                    data: (payStats) => expenseStats.when(
                      data: (expStats) => LayoutBuilder(
                        builder: (context, constraints) {
                          final isNarrow = constraints.maxWidth < 520;
                          final itemWidth = isNarrow
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 12) / 2;

                          return Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Active Trips',
                                  value: '${tStats['ACTIVE'] ?? 0}',
                                  icon: Icons.directions_car,
                                  accentColor: AppTheme.primaryColor,
                                  isHero: true,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const TripListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Total Vehicles',
                                  value: '${vStats['TOTAL'] ?? 0}',
                                  icon: Icons.local_shipping,
                                  accentColor: AppTheme.secondaryColor,
                                  isHero: true,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const VehicleListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Available',
                                  value: '${vStats['IDLE'] ?? 0}',
                                  icon: Icons.check_circle,
                                  accentColor: AppTheme.successColor,
                                  onTap: () {},
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Maintenance',
                                  value: '${vStats['MAINTENANCE'] ?? 0}',
                                  icon: Icons.build,
                                  accentColor: AppTheme.warningColor,
                                  onTap: () {},
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Active Drivers',
                                  value: '${dStats['ACTIVE'] ?? 0}',
                                  icon: Icons.people,
                                  accentColor: AppTheme.successColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const DriverListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Total Parties',
                                  value: '${pStats['TOTAL'] ?? 0}',
                                  icon: Icons.business,
                                  accentColor: AppTheme.accentColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PartyListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Completed Trips',
                                  value: '${tStats['COMPLETED'] ?? 0}',
                                  icon: Icons.check_circle,
                                  accentColor: AppTheme.successColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const TripListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Total Trips',
                                  value: '${tStats['TOTAL'] ?? 0}',
                                  icon: Icons.directions,
                                  accentColor: AppTheme.primaryColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const TripListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Total Payments',
                                  value: '${payStats['TOTAL'] ?? 0}',
                                  icon: Icons.account_balance_wallet,
                                  accentColor: AppTheme.successColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const PaymentListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                width: itemWidth,
                                child: GlassStatCard(
                                  title: 'Total Expenses',
                                  value: '${expStats['TOTAL'] ?? 0}',
                                  icon: Icons.receipt_long,
                                  accentColor: AppTheme.warningColor,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => const ExpenseListScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      loading: () => _buildLoadingStats(),
                      error: (error, stack) => Center(child: Text('Error: $error')),
                    ),
                    loading: () => _buildLoadingStats(),
                    error: (error, stack) => Center(child: Text('Error: $error')),
                  ),
                  loading: () => _buildLoadingStats(),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
                loading: () => _buildLoadingStats(),
                error: (error, stack) => Center(child: Text('Error: $error')),
              ),
              loading: () => _buildLoadingStats(),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
            loading: () => _buildLoadingStats(),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
          
          const SizedBox(height: AppTheme.spaceXl),
          
          // Quick Actions
          const AppSectionHeader(title: 'Quick Actions'),

          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth >= 840 ? 4 : 2;

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: AppTheme.spaceMd,
                crossAxisSpacing: AppTheme.spaceMd,
                childAspectRatio: 1.3,
                children: [
                  EnhancedActionButton(
                    title: 'Create Trip',
                    icon: Icons.add_location_alt,
                    gradientColors: AppTheme.primaryGradient,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TripFormScreen(),
                        ),
                      );
                    },
                  ),
                  EnhancedActionButton(
                    title: 'Add Payment',
                    icon: Icons.account_balance_wallet,
                    gradientColors: AppTheme.successGradient,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PaymentFormScreen(),
                        ),
                      );
                    },
                  ),
                  EnhancedActionButton(
                    title: 'Add Expense',
                    icon: Icons.receipt_long,
                    gradientColors: AppTheme.warningGradient,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ExpenseFormScreen(),
                        ),
                      );
                    },
                  ),
                  EnhancedActionButton(
                    title: 'Manage Vehicles',
                    icon: Icons.local_shipping,
                    gradientColors: AppTheme.infoGradient,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const VehicleListScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),

          const AppSectionHeader(title: 'Insights Overview'),
          
          PanelCard(
            padding: const EdgeInsets.all(AppTheme.spaceLg),
            child: Column(
              children: [
                _InsightShortcutTile(
                  title: 'Profit & Loss',
                  subtitle: 'Monthly trend analysis',
                  icon: Icons.analytics,
                  color: AppTheme.successColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InsightsHubScreen()),
                    );
                  },
                ),
                const Divider(height: AppTheme.spaceXl),
                _InsightShortcutTile(
                  title: 'Expense Breakdown',
                  subtitle: 'Top spending categories',
                  icon: Icons.pie_chart,
                  color: AppTheme.warningColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InsightsHubScreen()),
                    );
                  },
                ),
                const Divider(height: AppTheme.spaceXl),
                _InsightShortcutTile(
                  title: 'Route Performance',
                  subtitle: 'Most profitable routes',
                  icon: Icons.map,
                  color: AppTheme.primaryColor,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const InsightsHubScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppTheme.space2xl),
        ],
      ),
    );
  }
}

class _InsightShortcutTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _InsightShortcutTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppTheme.spaceSm),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppTheme.spaceLg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoadingStats() {
  return Column(
    children: [
      Row(
        children: [
          const Expanded(child: DashboardStatSkeleton()),
          const SizedBox(width: AppTheme.spaceMd),
          const Expanded(child: DashboardStatSkeleton()),
        ],
      ),
      const SizedBox(height: AppTheme.spaceMd),
      Row(
        children: [
          const Expanded(child: DashboardStatSkeleton()),
          const SizedBox(width: AppTheme.spaceMd),
          const Expanded(child: DashboardStatSkeleton()),
        ],
      ),
    ],
  );
}

class SimpleDashboardScreen extends StatelessWidget {
  const SimpleDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tranzfort TMS'),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_shipping,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Tranzfort TMS',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Transport Management System',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 30),
            Text(
              'App is running successfully!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
