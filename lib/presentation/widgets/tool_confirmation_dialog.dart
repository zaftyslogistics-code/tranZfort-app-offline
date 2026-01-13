import 'package:flutter/material.dart';
import '../../domain/models/tool_call.dart';
import '../../domain/models/tool_definition.dart';
import '../../domain/services/tool_registry.dart';

/// Confirmation dialog for tool execution
class ToolConfirmationDialog extends StatelessWidget {
  final ToolCall toolCall;
  final ToolDefinition toolDefinition;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ToolConfirmationDialog({
    super.key,
    required this.toolCall,
    required this.toolDefinition,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMutation = _isMutationTool(toolCall.name);

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            isMutation ? Icons.warning_amber : Icons.info_outline,
            color: isMutation ? Colors.orange : Colors.blue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isMutation ? 'Confirm Action' : 'Execute Query',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            toolDefinition.description,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          _buildArgumentsList(theme),
          if (isMutation) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action will modify data in the system.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.orange.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: isMutation ? Colors.orange : theme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(isMutation ? 'Execute' : 'Run Query'),
        ),
      ],
    );
  }

  Widget _buildArgumentsList(ThemeData theme) {
    final args = toolCall.arguments;
    if (args.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Parameters:',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...args.entries.map((entry) => _buildArgumentItem(entry.key, entry.value, theme)),
        ],
      ),
    );
  }

  Widget _buildArgumentItem(String key, dynamic value, ThemeData theme) {
    String displayValue;
    if (value == null) {
      displayValue = 'null';
    } else if (value is num) {
      displayValue = value.toString();
    } else if (value is bool) {
      displayValue = value.toString();
    } else if (value is String) {
      displayValue = '"$value"';
    } else {
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$key:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              displayValue,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  bool _isMutationTool(String toolName) {
    // Define which tools require confirmation (mutations)
    const mutationTools = {
      'create_trip',
      'add_expense',
      'add_payment',
      'update_trip',
      'update_trip_status',
      'delete_trip',
      'schedule_maintenance',
    };
    return mutationTools.contains(toolName);
  }
}
