import '../models/tool_definition.dart';

class ToolRegistry {
  final List<ToolDefinition> tools;

  ToolRegistry({
    required this.tools,
  });

  ToolDefinition? findByName(String name) {
    for (final tool in tools) {
      if (tool.name == name) return tool;
    }
    return null;
  }

  factory ToolRegistry.defaultRegistry() {
    return ToolRegistry(
      tools: [
        ToolDefinition(
          name: 'query_trips',
          description: 'Query trips from the local database.',
          inputSchema: {
            'type': 'object',
            'properties': {
              'dateRange': {
                'type': 'object',
                'properties': {
                  'start': {'type': 'string'},
                  'end': {'type': 'string'},
                },
              },
              'status': {'type': 'string'},
              'location': {'type': 'string'},
            },
          },
        ),
        ToolDefinition(
          name: 'query_expenses',
          description: 'Query expenses from the local database.',
          inputSchema: {
            'type': 'object',
            'properties': {
              'dateRange': {
                'type': 'object',
                'properties': {
                  'start': {'type': 'string'},
                  'end': {'type': 'string'},
                },
              },
              'category': {'type': 'string'},
            },
          },
        ),
        ToolDefinition(
          name: 'query_payments',
          description: 'Query payments from the local database.',
          inputSchema: {
            'type': 'object',
            'properties': {
              'dateRange': {
                'type': 'object',
                'properties': {
                  'start': {'type': 'string'},
                  'end': {'type': 'string'},
                },
              },
            },
          },
        ),
      ],
    );
  }
}
