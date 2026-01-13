import '../../../domain/models/tool_call.dart';
import '../../../domain/models/tool_result.dart';

class NavigationTools {
  static const String openScreenToolName = 'open_screen';
  static const String showInsightsToolName = 'show_insights';

  static Map<String, dynamic> getOpenScreenSchema() {
    return {
      'name': openScreenToolName,
      'description': 'Navigate to a specific screen in the app',
      'parameters': {
        'type': 'object',
        'properties': {
          'screen': {
            'type': 'string',
            'enum': [
              'trips',
              'expenses',
              'payments',
              'insights',
              'vehicles',
              'drivers',
              'parties',
              'fuel',
              'maintenance',
              'settings',
            ],
            'description': 'The screen to navigate to',
          },
        },
        'required': ['screen'],
      },
    };
  }

  static Map<String, dynamic> getShowInsightsSchema() {
    return {
      'name': showInsightsToolName,
      'description': 'Show specific insights category in the Insights Hub',
      'parameters': {
        'type': 'object',
        'properties': {
          'category': {
            'type': 'string',
            'enum': [
              'profit',
              'cashflow',
              'routes',
              'expenses',
              'vehicles',
              'drivers',
              'fuel',
              'maintenance',
            ],
            'description': 'The insights category to display',
          },
        },
        'required': ['category'],
      },
    };
  }

  static ToolResult executeOpenScreen(Map<String, dynamic> arguments) {
    final screen = arguments['screen'] as String?;

    if (screen == null || screen.isEmpty) {
      return ToolResult.failure('', 'screen parameter is required',
      );
    }

    final validScreens = [
      'trips',
      'expenses',
      'payments',
      'insights',
      'vehicles',
      'drivers',
      'parties',
      'fuel',
      'maintenance',
      'settings',
    ];

    if (!validScreens.contains(screen)) {
      return ToolResult.failure('', 'Invalid screen: $screen. Valid screens: ${validScreens.join(", ")}',
      );
    }

    return ToolResult.success('', {
        'action': 'navigate',
        'screen': screen,
        'message': 'Opening $screen screen...',
      },
    );
  }

  static ToolResult executeShowInsights(Map<String, dynamic> arguments) {
    final category = arguments['category'] as String?;

    if (category == null || category.isEmpty) {
      return ToolResult.failure('', 'category parameter is required',
      );
    }

    final validCategories = [
      'profit',
      'cashflow',
      'routes',
      'expenses',
      'vehicles',
      'drivers',
      'fuel',
      'maintenance',
    ];

    if (!validCategories.contains(category)) {
      return ToolResult.failure('', 'Invalid category: $category. Valid categories: ${validCategories.join(", ")}',
      );
    }

    return ToolResult.success('', {
        'action': 'navigate',
        'screen': 'insights',
        'category': category,
        'message': 'Showing $category insights...',
      },
    );
  }
}
