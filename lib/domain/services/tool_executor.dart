import '../models/tool_call.dart';
import '../models/tool_result.dart';
import 'tool_registry.dart';

class ToolExecutor {
  final ToolRegistry _registry;

  ToolExecutor({
    required ToolRegistry registry,
  }) : _registry = registry;

  Future<ToolResult> execute(ToolCall call) async {
    final tool = _registry.findByName(call.name);
    if (tool == null) {
      return ToolResult.failure(call.id, 'Unknown tool: ${call.name}');
    }

    return ToolResult.failure(call.id, 'Tool not implemented: ${tool.name}');
  }
}
