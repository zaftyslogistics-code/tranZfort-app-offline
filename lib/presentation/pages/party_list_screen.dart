import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/party_provider.dart';
import 'party_form_screen.dart';
import 'ai_entry_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class PartyListScreen extends ConsumerStatefulWidget {
  const PartyListScreen({super.key});

  @override
  ConsumerState<PartyListScreen> createState() => _PartyListScreenState();
}

class _PartyListScreenState extends ConsumerState<PartyListScreen> {
  final _searchController = TextEditingController();
  String? _selectedFilter;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Party> _filterParties(List<Party> parties) {
    var filtered = parties;

    if (_selectedFilter != null) {
      if (_selectedFilter == 'WITH_GST') {
        filtered = filtered.where((party) => party.gst != null && party.gst!.isNotEmpty).toList();
      } else if (_selectedFilter == 'WITHOUT_GST') {
        filtered = filtered.where((party) => party.gst == null || party.gst!.isEmpty).toList();
      }
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((party) {
        return party.name.toLowerCase().contains(query) ||
            party.mobile.toLowerCase().contains(query) ||
            party.city.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final partiesAsync = ref.watch(partyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
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
            hintText: 'Search parties by name, phone, city...',
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
                label: 'With GST',
                value: 'WITH_GST',
                color: AppTheme.successColor,
              ),
              FilterChipData(
                label: 'Without GST',
                value: 'WITHOUT_GST',
                color: AppTheme.infoColor,
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
            child: partiesAsync.when(
              data: (partyList) {
                final filteredParties = _filterParties(partyList);
                return filteredParties.isEmpty
                    ? _buildEmptyState(context)
                    : _buildPartyList(context, filteredParties);
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
              builder: (context) => const PartyFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      icon: Icons.business,
      title: 'No parties added yet',
      subtitle: 'Add your first party to get started',
      primaryAction: AppPrimaryButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const PartyFormScreen(),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            SizedBox(width: 8),
            Text('Add Party'),
          ],
        ),
      ),
    );
  }

  Widget _buildPartyList(BuildContext context, List<Party> parties) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceLg),
      itemCount: parties.length,
      itemBuilder: (context, index) {
        final party = parties[index];
        return _PartyCard(party: party);
      },
    );
  }
}

class _PartyCard extends ConsumerWidget {
  final Party party;

  const _PartyCard({required this.party});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(partyServiceProvider);
    final hasGst = party.gst != null && party.gst!.isNotEmpty;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = hasGst ? AppTheme.successColor : colorScheme.onSurface.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Dismissible(
        key: ValueKey(party.id),
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
                builder: (context) => PartyFormScreen(party: party),
              ),
            );
            ref.invalidate(partyListProvider);
            ref.invalidate(partyStatsProvider);
            return false;
          }

          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Party'),
              content: Text('Are you sure you want to delete ${party.name}?'),
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
            await ref.read(partyServiceProvider).deleteParty(party.id);
            ref.invalidate(partyListProvider);
            ref.invalidate(partyStatsProvider);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Party deleted successfully')),
              );
            }
          } catch (e) {
            ref.invalidate(partyListProvider);
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
                  color: accentColor.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withOpacity(0.35)),
                ),
                child: Icon(
                  hasGst ? Icons.verified : Icons.business,
                  color: accentColor,
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
                            party.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        if (hasGst)
                          StatusPill(label: 'GST', color: AppTheme.successColor),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spaceSm),
                    _MetaRow(
                      icon: Icons.phone,
                      label: service.formatMobileNumber(party.mobile),
                    ),
                    const SizedBox(height: AppTheme.spaceXs),
                    _MetaRow(
                      icon: Icons.location_city,
                      label: party.city,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
