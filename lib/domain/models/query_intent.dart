/// Query Intent Model
/// Represents the classified intent of a user query
class QueryIntent {
  final IntentType type;
  final String action;
  final Map<String, dynamic> entities;
  final double confidence;

  QueryIntent({
    required this.type,
    required this.action,
    required this.entities,
    required this.confidence,
  });

  @override
  String toString() {
    return 'QueryIntent(type: $type, action: $action, entities: $entities, confidence: $confidence)';
  }
}

/// Intent Types
enum IntentType {
  query,     // Show, find, search, filter
  command,   // Add, update, delete, complete
  question,  // How much, how many, when, where
}

/// Chat Message Model
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;
  final Map<String, dynamic>? data;
  final QueryIntent? intent;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.data,
    this.intent,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    MessageType? type,
    Map<String, dynamic>? data,
    QueryIntent? intent,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      data: data ?? this.data,
      intent: intent ?? this.intent,
    );
  }
}

/// Message Types
enum MessageType {
  text,
  data,
  error,
  suggestion,
  action,
}

/// AI Response Model
class AiResponse {
  final String message;
  final ResponseType type;
  final Map<String, dynamic>? data;
  final List<String>? suggestions;
  final List<ActionButton>? actions;

  AiResponse({
    required this.message,
    required this.type,
    this.data,
    this.suggestions,
    this.actions,
  });
}

/// Response Types
enum ResponseType {
  success,
  error,
  info,
  data,
  question,
}

/// Action Button Model
class ActionButton {
  final String label;
  final String action;
  final Map<String, dynamic>? params;

  ActionButton({
    required this.label,
    required this.action,
    this.params,
  });
}
