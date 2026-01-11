import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/query_intent.dart';
import '../../domain/services/nlp_service.dart';
import '../../domain/services/query_builder_service.dart';
import '../../domain/services/response_generator_service.dart';
import '../../domain/services/chat_service.dart';
import '../providers/database_provider.dart';
import '../widgets/voice_input_button.dart';

/// AI Chat Screen
/// Conversational AI assistant for natural language queries
class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  late ChatService _chatService;
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeChatService();
  }

  void _initializeChatService() {
    final database = ref.read(databaseProvider);
    final nlpService = NlpService();
    final queryBuilder = QueryBuilderService(database);
    final responseGenerator = ResponseGeneratorService();
    
    _chatService = ChatService(
      nlpService: nlpService,
      queryBuilder: queryBuilder,
      responseGenerator: responseGenerator,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    _messageController.clear();

    try {
      await _chatService.processMessage(text);
      setState(() {});
      
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
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _handleVoiceInput(String text) {
    _messageController.text = text;
    _sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = _chatService.messages;
    final suggestions = _chatService.getSuggestions();

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
              setState(() {
                _chatService.clearHistory();
              });
            },
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return _buildMessageBubble(message, theme);
                    },
                  ),
          ),

          // Suggestions
          if (suggestions.isNotEmpty && !_isProcessing)
            _buildSuggestions(suggestions, theme),

          // Processing indicator
          if (_isProcessing)
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
          _buildInputArea(theme),
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
            Icon(
              Icons.smart_toy_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'AI Assistant',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Ask me anything about your trips, expenses, payments, and more!',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 32),
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
                    message.content,
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

  Widget _buildInputArea(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
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
              enabled: !_isProcessing,
            ),
          ),
          const SizedBox(width: 8),
          // Voice input button
          CompactVoiceInputButton(
            onResult: _handleVoiceInput,
            tooltip: 'Voice input',
          ),
          const SizedBox(width: 8),
          // Send button
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _isProcessing
                ? null
                : () => _sendMessage(_messageController.text),
            color: theme.colorScheme.primary,
            tooltip: 'Send',
          ),
        ],
      ),
    );
  }
}
