import 'package:flutter/material.dart';
import '../pages/ai_entry_screen.dart';

/// AI Assistant Floating Action Button
/// Provides quick access to the AI chat assistant from anywhere in the app
class AiAssistantFab extends StatelessWidget {
  final String? heroTag;

  const AiAssistantFab({
    super.key,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      heroTag: heroTag ?? 'ai_assistant_fab',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AiEntryScreen(),
          ),
        );
      },
      backgroundColor: theme.colorScheme.primary,
      child: Icon(
        Icons.smart_toy,
        color: theme.colorScheme.onPrimary,
      ),
      tooltip: 'AI Assistant',
    );
  }
}

/// AI Assistant Mini FAB
/// Smaller version for screens with multiple FABs
class AiAssistantMiniFab extends StatelessWidget {
  const AiAssistantMiniFab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton.small(
      heroTag: 'ai_assistant_mini_fab',
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AiEntryScreen(),
          ),
        );
      },
      backgroundColor: theme.colorScheme.secondary,
      child: Icon(
        Icons.smart_toy,
        size: 20,
        color: theme.colorScheme.onSecondary,
      ),
      tooltip: 'AI Assistant',
    );
  }
}

/// AI Quick Query Button
/// Shows a bottom sheet with quick query options
class AiQuickQueryButton extends StatelessWidget {
  const AiQuickQueryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: const Icon(Icons.smart_toy),
      onPressed: () {
        _showQuickQuerySheet(context);
      },
      tooltip: 'Quick AI Query',
    );
  }

  void _showQuickQuerySheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.smart_toy,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick AI Queries',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildQuickQueryTile(
              context,
              icon: Icons.local_shipping,
              title: 'Show trips today',
              query: 'Show trips today',
            ),
            _buildQuickQueryTile(
              context,
              icon: Icons.receipt_long,
              title: 'Fuel expenses',
              query: 'How much did I spend on fuel?',
            ),
            _buildQuickQueryTile(
              context,
              icon: Icons.payment,
              title: 'Pending payments',
              query: 'Show pending payments',
            ),
            _buildQuickQueryTile(
              context,
              icon: Icons.analytics,
              title: 'This month summary',
              query: 'Show summary for this month',
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AiEntryScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text('Open AI Chat'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickQueryTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String query,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.pop(context);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const AiEntryScreen(),
          ),
        );
        // TODO: Auto-send query when chat opens
      },
    );
  }
}
