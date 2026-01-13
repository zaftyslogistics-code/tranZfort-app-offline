class LlmMessage {
  final String role;
  final String content;

  const LlmMessage({
    required this.role,
    required this.content,
  });

  factory LlmMessage.system(String content) => LlmMessage(
        role: 'system',
        content: content,
      );

  factory LlmMessage.user(String content) => LlmMessage(
        role: 'user',
        content: content,
      );

  factory LlmMessage.assistant(String content) => LlmMessage(
        role: 'assistant',
        content: content,
      );

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
      };

  factory LlmMessage.fromJson(Map<String, dynamic> json) => LlmMessage(
        role: json['role'] as String,
        content: json['content'] as String,
      );
}
