class ToolResult {
  final String toolCallId;
  final bool success;
  final Map<String, dynamic>? data;
  final String? errorMessage;

  const ToolResult({
    required this.toolCallId,
    required this.success,
    required this.data,
    required this.errorMessage,
  });

  factory ToolResult.success(String toolCallId, Map<String, dynamic> data) {
    return ToolResult(
      toolCallId: toolCallId,
      success: true,
      data: data,
      errorMessage: null,
    );
  }

  factory ToolResult.failure(String toolCallId, String errorMessage) {
    return ToolResult(
      toolCallId: toolCallId,
      success: false,
      data: null,
      errorMessage: errorMessage,
    );
  }
}
