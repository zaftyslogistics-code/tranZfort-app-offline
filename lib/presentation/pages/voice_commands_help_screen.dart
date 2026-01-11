import 'package:flutter/material.dart';

/// Voice Commands Help Screen
/// Shows users how to use voice input with examples
class VoiceCommandsHelpScreen extends StatelessWidget {
  const VoiceCommandsHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Commands Help'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Introduction
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.mic,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Voice Input Guide',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Use voice commands to quickly add expenses, update trips, and search data hands-free.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Expense Commands
          _buildCommandSection(
            context,
            icon: Icons.receipt_long,
            title: 'Expense Commands',
            color: Colors.green,
            commands: [
              VoiceCommand(
                example: 'Add fuel expense 2000 rupees',
                description: 'Creates a fuel expense of ₹2000',
              ),
              VoiceCommand(
                example: 'Toll expense 500',
                description: 'Creates a toll expense of ₹500',
              ),
              VoiceCommand(
                example: 'Food expense 300 rupees',
                description: 'Creates a food expense of ₹300',
              ),
              VoiceCommand(
                example: 'Maintenance 5000',
                description: 'Creates a maintenance expense of ₹5000',
              ),
              VoiceCommand(
                example: 'Parking 50 rupees',
                description: 'Creates a parking expense of ₹50',
              ),
            ],
          ),

          // Trip Commands
          _buildCommandSection(
            context,
            icon: Icons.local_shipping,
            title: 'Trip Commands',
            color: Colors.blue,
            commands: [
              VoiceCommand(
                example: 'Complete trip',
                description: 'Marks the current trip as completed',
              ),
              VoiceCommand(
                example: 'Start trip',
                description: 'Starts the trip (changes status to In Progress)',
              ),
              VoiceCommand(
                example: 'Cancel trip',
                description: 'Cancels the current trip',
              ),
              VoiceCommand(
                example: 'Reached Delhi',
                description: 'Updates trip notes with arrival at Delhi',
              ),
              VoiceCommand(
                example: 'Arrived at Mumbai',
                description: 'Updates trip notes with arrival at Mumbai',
              ),
            ],
          ),

          // Search Commands
          _buildCommandSection(
            context,
            icon: Icons.search,
            title: 'Search Commands',
            color: Colors.orange,
            commands: [
              VoiceCommand(
                example: 'Show trips today',
                description: 'Displays trips from today',
              ),
              VoiceCommand(
                example: 'Show trips last week',
                description: 'Displays trips from last week',
              ),
              VoiceCommand(
                example: 'Show trips last month',
                description: 'Displays trips from last month',
              ),
              VoiceCommand(
                example: 'Show expenses this month',
                description: 'Displays expenses from this month',
              ),
              VoiceCommand(
                example: 'Show payments',
                description: 'Displays payment records',
              ),
            ],
          ),

          // Tips Section
          Card(
            color: theme.colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tips for Better Recognition',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Speak clearly and at a normal pace'),
                  _buildTip('Use in a quiet environment for best results'),
                  _buildTip('Say numbers clearly (e.g., "two thousand" or "2000")'),
                  _buildTip('Include keywords like "expense", "trip", "show"'),
                  _buildTip('Works in all 8 supported languages'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Supported Languages
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.language,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Supported Languages',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildLanguageChip(context, 'English'),
                      _buildLanguageChip(context, 'हिंदी (Hindi)'),
                      _buildLanguageChip(context, 'ਪੰਜਾਬੀ (Punjabi)'),
                      _buildLanguageChip(context, 'தமிழ் (Tamil)'),
                      _buildLanguageChip(context, 'తెలుగు (Telugu)'),
                      _buildLanguageChip(context, 'मराठी (Marathi)'),
                      _buildLanguageChip(context, 'ગુજરાતી (Gujarati)'),
                      _buildLanguageChip(context, 'বাংলা (Bengali)'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommandSection(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required List<VoiceCommand> commands,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...commands.map((command) => _buildCommandItem(context, command)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommandItem(BuildContext context, VoiceCommand command) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.mic,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '"${command.example}"',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              command.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(child: Text(tip)),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(BuildContext context, String language) {
    return Chip(
      label: Text(
        language,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}

class VoiceCommand {
  final String example;
  final String description;

  VoiceCommand({
    required this.example,
    required this.description,
  });
}
