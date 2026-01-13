import '../models/tool_definition.dart';
import 'tools/navigation_tools.dart';
import 'tools/analytics_tools.dart';
import 'tools/trip_update_tools.dart';

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
        ToolDefinition(
          name: 'create_trip',
          description: 'Create a new trip in the system.',
          inputSchema: {
            'type': 'object',
            'required': ['fromLocation', 'toLocation'],
            'properties': {
              'fromLocation': {'type': 'string', 'description': 'Starting location'},
              'toLocation': {'type': 'string', 'description': 'Destination location'},
              'vehicleId': {'type': 'string', 'description': 'Vehicle ID (optional)'},
              'driverId': {'type': 'string', 'description': 'Driver ID (optional)'},
              'partyId': {'type': 'string', 'description': 'Party/Customer ID (optional)'},
              'freightAmount': {'type': 'number', 'description': 'Freight amount in rupees'},
              'advancePaid': {'type': 'number', 'description': 'Advance payment amount'},
              'startDate': {'type': 'string', 'description': 'Trip start date (ISO 8601 format)'},
              'loadWeight': {'type': 'number', 'description': 'Load weight in kg'},
              'notes': {'type': 'string', 'description': 'Additional notes'},
            },
          },
        ),
        ToolDefinition(
          name: 'add_expense',
          description: 'Add a new expense entry.',
          inputSchema: {
            'type': 'object',
            'required': ['category', 'amount'],
            'properties': {
              'category': {'type': 'string', 'description': 'Expense category (fuel, toll, maintenance, etc.)'},
              'amount': {'type': 'number', 'description': 'Expense amount in rupees'},
              'tripId': {'type': 'string', 'description': 'Associated trip ID (optional)'},
              'vehicleId': {'type': 'string', 'description': 'Associated vehicle ID (optional)'},
              'description': {'type': 'string', 'description': 'Expense description'},
              'date': {'type': 'string', 'description': 'Expense date (ISO 8601 format)'},
              'paymentMode': {'type': 'string', 'description': 'Payment mode (cash, upi, card, etc.)'},
            },
          },
        ),
        ToolDefinition(
          name: 'add_payment',
          description: 'Record a payment received from a party.',
          inputSchema: {
            'type': 'object',
            'required': ['partyId', 'amount'],
            'properties': {
              'partyId': {'type': 'string', 'description': 'Party ID who made the payment'},
              'amount': {'type': 'number', 'description': 'Payment amount in rupees'},
              'tripId': {'type': 'string', 'description': 'Associated trip ID (optional)'},
              'paymentMode': {'type': 'string', 'description': 'Payment mode (cash, upi, bank_transfer, etc.)'},
              'date': {'type': 'string', 'description': 'Payment date (ISO 8601 format)'},
              'referenceNumber': {'type': 'string', 'description': 'Transaction reference number'},
              'notes': {'type': 'string', 'description': 'Additional notes'},
            },
          },
        ),
        ToolDefinition(
          name: NavigationTools.openScreenToolName,
          description: 'Navigate to a specific screen in the app',
          inputSchema: NavigationTools.getOpenScreenSchema(),
        ),
        ToolDefinition(
          name: NavigationTools.showInsightsToolName,
          description: 'Show specific insights category in the Insights Hub',
          inputSchema: NavigationTools.getShowInsightsSchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getTripProfitToolName,
          description: 'Calculate profit for a specific trip',
          inputSchema: AnalyticsTools.getTripProfitSchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getMonthlyProfitTrendToolName,
          description: 'Get monthly profit trend for the last N months',
          inputSchema: AnalyticsTools.getMonthlyProfitTrendSchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getCashflowToolName,
          description: 'Get cashflow breakdown (income vs expenses)',
          inputSchema: AnalyticsTools.getCashflowSchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getExpenseBreakdownToolName,
          description: 'Get expense breakdown by category',
          inputSchema: AnalyticsTools.getExpenseBreakdownSchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getRouteProfitabilityToolName,
          description: 'Get profitability ranking by route',
          inputSchema: AnalyticsTools.getRouteProfitabilitySchema(),
        ),
        ToolDefinition(
          name: AnalyticsTools.getDriverPerformanceToolName,
          description: 'Get performance metrics for drivers',
          inputSchema: AnalyticsTools.getDriverPerformanceSchema(),
        ),
        ToolDefinition(
          name: TripUpdateTools.updateTripToolName,
          description: 'Update details of an existing trip',
          inputSchema: TripUpdateTools.getUpdateTripSchema(),
        ),
        ToolDefinition(
          name: TripUpdateTools.updateTripStatusToolName,
          description: 'Update the status of a trip',
          inputSchema: TripUpdateTools.getUpdateTripStatusSchema(),
        ),
        ToolDefinition(
          name: TripUpdateTools.scheduleMaintenanceToolName,
          description: 'Schedule maintenance for a vehicle',
          inputSchema: TripUpdateTools.getScheduleMaintenanceSchema(),
        ),
      ],
    );
  }
}
