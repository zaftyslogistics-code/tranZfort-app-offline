import 'package:uuid/uuid.dart';
import 'package:tranzfort_tms/domain/models/query_intent.dart';
import 'package:tranzfort_tms/domain/services/nlp_service.dart';
import 'package:tranzfort_tms/domain/services/query_builder_service.dart';
import 'package:tranzfort_tms/domain/services/response_generator_service.dart';

/// Chat Service
/// Manages AI chat conversations and message history
class ChatService {
  final NlpService _nlpService;
  final QueryBuilderService _queryBuilder;
  final ResponseGeneratorService _responseGenerator;
  final List<ChatMessage> _messages = [];
  final _uuid = const Uuid();

  ChatService({
    required NlpService nlpService,
    required QueryBuilderService queryBuilder,
    required ResponseGeneratorService responseGenerator,
  })  : _nlpService = nlpService,
        _queryBuilder = queryBuilder,
        _responseGenerator = responseGenerator;

  /// Get all messages
  List<ChatMessage> get messages => List.unmodifiable(_messages);

  /// Process user message
  Future<ChatMessage> processMessage(String userInput) async {
    // Add user message to history
    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: userInput,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
    _messages.add(userMessage);

    try {
      // Classify intent
      final intent = _nlpService.classifyIntent(userInput);

      // Execute query if it's a query or question
      if (intent.type == IntentType.query || intent.type == IntentType.question) {
        final queryResult = await _queryBuilder.executeQuery(intent);
        
        // Generate response
        final response = _responseGenerator.generateResponse(intent, queryResult);
        
        // Create AI message
        final aiMessage = ChatMessage(
          id: _uuid.v4(),
          content: response.message,
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.data,
          data: queryResult,
          intent: intent,
        );
        _messages.add(aiMessage);
        
        return aiMessage;
      }

      // Handle commands
      if (intent.type == IntentType.command) {
        final response = _responseGenerator.generateCommandResponse(intent);
        
        final aiMessage = ChatMessage(
          id: _uuid.v4(),
          content: response.message,
          isUser: false,
          timestamp: DateTime.now(),
          type: MessageType.action,
          intent: intent,
        );
        _messages.add(aiMessage);
        
        return aiMessage;
      }

      // Default response
      final aiMessage = ChatMessage(
        id: _uuid.v4(),
        content: "I'm not sure how to help with that. Try asking about trips, expenses, or payments.",
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
      _messages.add(aiMessage);
      
      return aiMessage;
    } catch (e) {
      // Error response
      final errorMessage = ChatMessage(
        id: _uuid.v4(),
        content: "Sorry, I encountered an error: $e",
        isUser: false,
        timestamp: DateTime.now(),
        type: MessageType.error,
      );
      _messages.add(errorMessage);
      
      return errorMessage;
    }
  }

  /// Get suggestions based on context
  List<String> getSuggestions() {
    if (_messages.isEmpty) {
      return [
        'Show trips today',
        'How much did I spend on fuel?',
        'Show pending payments',
        'Find trips to Delhi',
      ];
    }

    // Get suggestions based on last message
    final lastMessage = _messages.last;
    if (lastMessage.intent != null) {
      final entityType = lastMessage.intent!.entities['entityType'] as String?;
      
      switch (entityType) {
        case 'trips':
          return [
            'Show trip details',
            'Show expenses for this trip',
            'Show trip route',
          ];
        case 'expenses':
          return [
            'Show expense breakdown',
            'Show fuel expenses',
            'Show expenses by category',
          ];
        case 'payments':
          return [
            'Show payment details',
            'Show pending payments',
            'Show payment history',
          ];
        default:
          return [
            'Show trips today',
            'Show expenses this month',
            'Show pending payments',
          ];
      }
    }

    return [
      'Show trips today',
      'Show expenses this month',
      'Show pending payments',
    ];
  }

  /// Clear chat history
  void clearHistory() {
    _messages.clear();
  }

  /// Get message count
  int get messageCount => _messages.length;

  /// Get last user message
  ChatMessage? get lastUserMessage {
    return _messages.lastWhere(
      (m) => m.isUser,
      orElse: () => ChatMessage(
        id: '',
        content: '',
        isUser: true,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Get last AI message
  ChatMessage? get lastAiMessage {
    return _messages.lastWhere(
      (m) => !m.isUser,
      orElse: () => ChatMessage(
        id: '',
        content: '',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Export chat history
  String exportHistory() {
    final buffer = StringBuffer();
    buffer.writeln('Chat History - ${DateTime.now()}');
    buffer.writeln('=' * 50);
    
    for (final message in _messages) {
      final sender = message.isUser ? 'User' : 'AI';
      buffer.writeln('[$sender] ${message.timestamp}');
      buffer.writeln(message.content);
      buffer.writeln('-' * 50);
    }
    
    return buffer.toString();
  }
}
