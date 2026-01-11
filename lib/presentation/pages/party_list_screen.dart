import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/party_provider.dart';
import 'party_form_screen.dart';
import '../../data/database.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

class PartyListScreen extends ConsumerWidget {
  const PartyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parties = ref.watch(partyListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parties'),
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
                  // TODO: Show all parties
                  break;
                case 'with_gst':
                  // TODO: Show parties with GST
                  break;
                case 'without_gst':
                  // TODO: Show parties without GST
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
                    Text('All Parties'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'with_gst',
                child: Row(
                  children: [
                    Icon(Icons.verified, size: 16),
                    SizedBox(width: 8),
                    Text('With GST'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'without_gst',
                child: Row(
                  children: [
                    Icon(Icons.gpp_bad, size: 16),
                    SizedBox(width: 8),
                    Text('Without GST'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: parties.when(
        data: (partyList) => partyList.isEmpty
            ? _buildEmptyState(context)
            : _buildPartyList(context, partyList),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
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
                colors: AppTheme.infoGradient,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.business,
              size: 64,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No parties added yet',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first party to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PartyFormScreen(),
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text('Add Party'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartyList(BuildContext context, List<Party> parties) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
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
          padding: const EdgeInsets.all(14),
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
                        if (hasGst) StatusPill(label: 'GST', color: AppTheme.successColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _MetaRow(
                      icon: Icons.phone,
                      label: service.formatMobileNumber(party.mobile),
                    ),
                    const SizedBox(height: 6),
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
