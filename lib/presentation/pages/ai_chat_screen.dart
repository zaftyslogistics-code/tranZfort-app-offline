import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../domain/models/query_intent.dart';
import '../../domain/models/tool_call.dart';
import '../providers/agent_orchestrator_provider.dart';
import '../providers/model_manager_provider.dart';
import '../widgets/voice_input_button.dart';
import 'ai_setup_screen.dart';
import '../../domain/services/tool_registry.dart';

/// AI Chat Screen
/// Conversational AI assistant for natural language queries
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _ToolCallDisplay {
  final String toolName;
  final String displayText;
  final Map<String, dynamic> arguments;

  _ToolCallDisplay({
    required this.toolName,
    required this.displayText,
    required this.arguments,
  });
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _inputFocusNode = FocusNode();
  bool _inputHasFocus = false;

  @override
  void initState() {
    super.initState();
    _inputFocusNode.addListener(() {
      if (!mounted) return;
      final hasFocus = _inputFocusNode.hasFocus;
      if (hasFocus == _inputHasFocus) return;
      setState(() {
        _inputHasFocus = hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  _ToolCallDisplay? _tryParseToolCallForDisplay(ChatMessage message) {
    if (!message.isUser) return null;
    final trimmed = message.content.trim();
    if (!trimmed.startsWith('{')) return null;

    try {
      final decoded = jsonDecode(trimmed);
      if (decoded is! Map) return null;
      final raw = decoded['tool_call'];
      if (raw is! Map) return null;
      final name = raw['name'];
      final args = raw['arguments'];
      if (name is! String) return null;
      if (args is! Map) return null;
      return _ToolCallDisplay(
        toolName: name,
        displayText: 'Tool request: $name',
        arguments: Map<String, dynamic>.from(args as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Widget _buildPendingToolCallCard(ThemeData theme, ToolCall toolCall) {
    final toolDefinition = ToolRegistry.defaultRegistry().findByName(toolCall.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primary,
            child: Icon(
              Icons.build_circle_outlined,
              size: 18,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.pending_actions, size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pending action: ${toolCall.name}',
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                  if (toolDefinition != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      toolDefinition.description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.8),
                      ),
                    ),
                  ],
                  if (toolCall.arguments.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    ...toolCall.arguments.entries.take(6).map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${e.key}: ${e.value}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => ref.read(agentOrchestratorProvider).cancelToolExecution(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => ref.read(agentOrchestratorProvider).confirmToolExecution(),
                          child: const Text('Confirm'),
                        ),
                      ),
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

  Widget _buildModelStatusBanner(ThemeData theme, AsyncValue<ModelManagerState> stateAsync) {
    return stateAsync.when(
      loading: () {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Checking offline AI model status…',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
        );
      },
      error: (error, _) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: theme.colorScheme.errorContainer,
            border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI model status error: $error',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiSetupScreen()));
                },
                child: const Text('Open setup'),
              ),
            ],
          ),
        );
      },
      data: (state) {
        final controller = ref.read(modelManagerControllerProvider.notifier);

        if (state.status == ModelInstallStatus.downloading) {
          final value = state.progress > 0 ? state.progress.clamp(0.0, 1.0) : null;
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.download),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        value == null ? 'Preparing model download…' : 'Downloading model… ${(value * 100).toStringAsFixed(0)}%',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                    TextButton(
                      onPressed: controller.deleteInstalledModel,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: value),
              ],
            ),
          );
        }

        if (state.status == ModelInstallStatus.verifying) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Verifying offline AI model…',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.status == ModelInstallStatus.error) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        state.errorMessage ?? 'Model download failed',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onErrorContainer),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.installBaselineFromManifest,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiSetupScreen()));
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text('Manage'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        final isInstalled = state.status == ModelInstallStatus.installed && state.installedModel != null;
        if (!isInstalled) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
            ),
            child: Row(
              children: [
                const Icon(Icons.smart_toy_outlined),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Offline AI model is not downloaded yet.'),
                ),
                TextButton(
                  onPressed: controller.installBaselineFromManifest,
                  child: const Text('Download'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AiSetupScreen()));
                  },
                  child: const Text('Manage'),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messageController.clear();

    try {
      await ref.read(agentOrchestratorProvider).sendMessage(text);
      
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _handleVoiceInput(String text) {
    _messageController.text = text;
    _sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orchestrator = ref.watch(agentOrchestratorProvider);
    final modelStateAsync = ref.watch(modelManagerControllerProvider);
    final messages = orchestrator.messages;
    final suggestions = orchestrator.getSuggestions();
    final isProcessing = orchestrator.isProcessing;
    final isAwaitingConfirmation = orchestrator.isAwaitingConfirmation;
    final pendingToolCall = orchestrator.pendingToolCall;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Navigate to AI help screen
            },
            tooltip: 'Help',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ref.read(agentOrchestratorProvider).clearHistory();
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildModelStatusBanner(theme, modelStateAsync),

          // Messages list
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + (isAwaitingConfirmation && pendingToolCall != null ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index >= messages.length) {
                        return _buildPendingToolCallCard(theme, pendingToolCall!);
                      }

                      final message = messages[index];
                      return _buildMessageBubble(message, theme);
                    },
                  ),
          ),

          // Suggestions
          if (suggestions.isNotEmpty && !isProcessing)
            _buildSuggestions(suggestions, theme),

          // Processing indicator
          if (isProcessing)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Thinking...',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),

          // Input area
          _buildInputArea(theme, isProcessing, messages),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _inputHasFocus ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 180),
              child: AnimatedScale(
                scale: _inputHasFocus ? 0.7 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: IgnorePointer(
                  ignoring: _inputHasFocus,
                  child: Transform.scale(
                    scale: 1.2,
                    child: VoiceInputButton(
                      onResult: _handleVoiceInput,
                      tooltip: 'Tap to speak',
                      icon: Icons.mic_none,
                      activeColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Tap the mic to speak',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Or type below. I can help with trips, expenses, payments, and more.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildExampleChip('Show trips today', theme),
                _buildExampleChip('How much did I spend on fuel?', theme),
                _buildExampleChip('Show pending payments', theme),
                _buildExampleChip('Find trips to Delhi', theme),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleChip(String text, ThemeData theme) {
    return ActionChip(
      label: Text(text),
      onPressed: () => _sendMessage(text),
      backgroundColor: theme.colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 12,
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, ThemeData theme) {
    final parsed = _tryParseToolCallForDisplay(message);
    final displayText = parsed?.displayText ?? message.content;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.smart_toy,
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: message.isUser
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (message.type == MessageType.data && message.data != null)
                    _buildDataPreview(message.data!, theme, message.isUser),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 18,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDataPreview(Map<String, dynamic> data, ThemeData theme, bool isUser) {
    final actionMessage = data['message'];
    if (actionMessage is String && actionMessage.trim().isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isUser
                ? theme.colorScheme.onPrimary.withOpacity(0.1)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 16,
                color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  actionMessage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isUser ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final count = data['count'] as int? ?? 0;
    final type = data['type'] as String? ?? '';
    
    if (count == 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.onPrimary.withOpacity(0.1)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIconForType(type),
              size: 16,
              color: isUser
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '$count ${_getPluralType(type, count)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isUser
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'trips':
        return Icons.local_shipping;
      case 'expenses':
        return Icons.receipt_long;
      case 'payments':
        return Icons.payment;
      case 'vehicles':
        return Icons.directions_car;
      case 'drivers':
        return Icons.person;
      case 'fuel_entries':
        return Icons.local_gas_station;
      default:
        return Icons.data_object;
    }
  }

  String _getPluralType(String type, int count) {
    if (count == 1) {
      return type.substring(0, type.length - 1); // Remove 's'
    }
    return type;
  }

  Widget _buildSuggestions(List<String> suggestions, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Suggestions',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () => _sendMessage(suggestion),
                backgroundColor: theme.colorScheme.secondaryContainer,
                labelStyle: TextStyle(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 12,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, bool isProcessing, List<ChatMessage> messages) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick templates
          if (!isProcessing && messages.isEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Quick actions',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.add_location_alt, size: 16),
                        label: const Text('Create Trip'),
                        onPressed: () => _sendMessage('Help me create a new trip'),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.receipt_long, size: 16),
                        label: const Text('Add Expense'),
                        onPressed: () => _sendMessage('Help me add an expense'),
                        backgroundColor: theme.colorScheme.secondaryContainer,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onSecondaryContainer,
                          fontSize: 12,
                        ),
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.payment, size: 16),
                        label: const Text('Check Payments'),
                        onPressed: () => _sendMessage('Show me pending payments'),
                        backgroundColor: theme.colorScheme.tertiaryContainer,
                        labelStyle: TextStyle(
                          color: theme.colorScheme.onTertiaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          // Input row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    focusNode: _inputFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: _sendMessage,
                    enabled: !isProcessing,
                  ),
                ),
                const SizedBox(width: 8),
                // Voice input or Cancel button
                if (isProcessing)
                  IconButton(
                    icon: const Icon(Icons.stop_circle_outlined),
                    onPressed: () {
                      // TODO: Implement cancellation logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cancellation not yet implemented'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    color: theme.colorScheme.error,
                    tooltip: 'Cancel',
                  )
                else
                  CompactVoiceInputButton(
                    onResult: _handleVoiceInput,
                    tooltip: 'Voice input',
                  ),
                const SizedBox(width: 8),
                // Send button
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: isProcessing
                      ? null
                      : () => _sendMessage(_messageController.text),
                  color: theme.colorScheme.primary,
                  tooltip: 'Send',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
