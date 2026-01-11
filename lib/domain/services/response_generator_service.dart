import 'package:tranzfort_tms/domain/models/query_intent.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Response Generator Service
/// Generates natural language responses from query results
class ResponseGeneratorService {
  /// Generate response from query result
  AiResponse generateResponse(QueryIntent intent, Map<String, dynamic> result) {
    if (!result['success']) {
      return AiResponse(
        message: result['error'] ?? 'Failed to process your request.',
        type: ResponseType.error,
      );
    }

    final entityType = result['type'] as String?;
    final count = result['count'] as int? ?? 0;

    switch (entityType) {
      case 'trips':
        return _generateTripResponse(intent, result, count);
      case 'expenses':
        return _generateExpenseResponse(intent, result, count);
      case 'payments':
        return _generatePaymentResponse(intent, result, count);
      case 'vehicles':
        return _generateVehicleResponse(intent, result, count);
      case 'drivers':
        return _generateDriverResponse(intent, result, count);
      case 'fuel_entries':
        return _generateFuelResponse(intent, result, count);
      default:
        return AiResponse(
          message: 'Found $count results.',
          type: ResponseType.info,
          data: result,
        );
    }
  }

  /// Generate trip response
  AiResponse _generateTripResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    if (count == 0) {
      return AiResponse(
        message: 'No trips found matching your criteria.',
        type: ResponseType.info,
        suggestions: [
          'Show all trips',
          'Show trips this month',
          'Show completed trips',
        ],
      );
    }

    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;
    final status = intent.entities['status'] as String?;
    final location = intent.entities['location'] as String?;

    String message = 'I found $count trip${count > 1 ? 's' : ''}';

    if (dateRange != null) {
      message += ' ${_formatDateRange(dateRange)}';
    }
    if (status != null) {
      message += ' with status $status';
    }
    if (location != null) {
      message += ' to/from $location';
    }

    message += '.';

    return AiResponse(
      message: message,
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show trip details',
        'Show expenses for trips',
        'Show trip statistics',
      ],
    );
  }

  /// Generate expense response
  AiResponse _generateExpenseResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    if (count == 0) {
      return AiResponse(
        message: 'No expenses found matching your criteria.',
        type: ResponseType.info,
        suggestions: [
          'Show all expenses',
          'Show expenses this month',
          'Show fuel expenses',
        ],
      );
    }

    final total = result['total'] as double?;
    final category = intent.entities['category'] as String?;
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;

    String message;

    if (intent.action == 'calculate_amount' && total != null) {
      message = 'Your total ${category ?? 'expense'} is ₹${_formatAmount(total)}';
      if (count > 1) {
        message += ' across $count entries';
      }
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += '.';
    } else {
      message = 'I found $count expense${count > 1 ? 's' : ''}';
      if (category != null) {
        message += ' in category $category';
      }
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += '.';
    }

    return AiResponse(
      message: message,
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show expense breakdown',
        'Show expenses by category',
        'Show expense trends',
      ],
    );
  }

  /// Generate payment response
  AiResponse _generatePaymentResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    if (count == 0) {
      return AiResponse(
        message: 'No payments found matching your criteria.',
        type: ResponseType.info,
        suggestions: [
          'Show all payments',
          'Show pending payments',
          'Show received payments',
        ],
      );
    }

    final totalIn = result['totalIn'] as double?;
    final totalOut = result['totalOut'] as double?;
    final net = result['net'] as double?;
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;

    String message;

    if (intent.action == 'calculate_amount' && totalIn != null && totalOut != null) {
      message = 'Payment summary';
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += ':\n';
      message += 'Received: ₹${_formatAmount(totalIn)}\n';
      message += 'Paid: ₹${_formatAmount(totalOut)}\n';
      message += 'Net: ₹${_formatAmount(net ?? 0)}';
    } else {
      message = 'I found $count payment${count > 1 ? 's' : ''}';
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += '.';
    }

    return AiResponse(
      message: message,
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show payment details',
        'Show payment breakdown',
        'Show pending payments',
      ],
    );
  }

  /// Generate vehicle response
  AiResponse _generateVehicleResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    return AiResponse(
      message: 'I found $count vehicle${count > 1 ? 's' : ''} in your fleet.',
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show vehicle details',
        'Show vehicle maintenance',
        'Show vehicle trips',
      ],
    );
  }

  /// Generate driver response
  AiResponse _generateDriverResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    return AiResponse(
      message: 'I found $count driver${count > 1 ? 's' : ''} in your team.',
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show driver details',
        'Show driver trips',
        'Show driver performance',
      ],
    );
  }

  /// Generate fuel response
  AiResponse _generateFuelResponse(QueryIntent intent, Map<String, dynamic> result, int count) {
    final totalCost = result['totalCost'] as double?;
    final totalLiters = result['totalLiters'] as double?;
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;

    String message;

    if (intent.action == 'calculate_amount' && totalCost != null) {
      message = 'Fuel summary';
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += ':\n';
      message += 'Total cost: ₹${_formatAmount(totalCost)}\n';
      if (totalLiters != null) {
        message += 'Total liters: ${totalLiters.toStringAsFixed(2)} L\n';
        message += 'Average: ₹${(totalCost / totalLiters).toStringAsFixed(2)}/L';
      }
    } else {
      message = 'I found $count fuel entr${count > 1 ? 'ies' : 'y'}';
      if (dateRange != null) {
        message += ' ${_formatDateRange(dateRange)}';
      }
      message += '.';
    }

    return AiResponse(
      message: message,
      type: ResponseType.data,
      data: result,
      suggestions: [
        'Show fuel details',
        'Show fuel trends',
        'Show mileage analysis',
      ],
    );
  }

  /// Generate command response
  AiResponse generateCommandResponse(QueryIntent intent) {
    final action = intent.action;
    final entityType = intent.entities['entityType'] as String?;

    switch (action) {
      case 'create':
        return AiResponse(
          message: 'I can help you create a new ${entityType ?? 'entry'}. What details would you like to add?',
          type: ResponseType.question,
          actions: [
            ActionButton(label: 'Add Expense', action: 'add_expense'),
            ActionButton(label: 'Create Trip', action: 'create_trip'),
          ],
        );
      case 'update':
        return AiResponse(
          message: 'I can help you update ${entityType ?? 'this entry'}. What would you like to change?',
          type: ResponseType.question,
        );
      case 'complete':
        return AiResponse(
          message: 'I can help you complete this ${entityType ?? 'entry'}. Would you like to proceed?',
          type: ResponseType.question,
          actions: [
            ActionButton(label: 'Yes, Complete', action: 'complete_confirm'),
            ActionButton(label: 'Cancel', action: 'cancel'),
          ],
        );
      default:
        return AiResponse(
          message: 'I understand you want to $action ${entityType ?? 'something'}. How can I help?',
          type: ResponseType.question,
        );
    }
  }

  /// Generate error response
  AiResponse generateErrorResponse(String error) {
    return AiResponse(
      message: 'Sorry, I encountered an error: $error',
      type: ResponseType.error,
      suggestions: [
        'Try again',
        'Show help',
        'Start over',
      ],
    );
  }

  /// Format date range for display
  String _formatDateRange(Map<String, DateTime> dateRange) {
    final start = dateRange['start']!;
    final end = dateRange['end']!;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Check for common ranges
    if (start.year == today.year && start.month == today.month && start.day == today.day) {
      return 'today';
    }
    
    final yesterday = today.subtract(const Duration(days: 1));
    if (start.year == yesterday.year && start.month == yesterday.month && start.day == yesterday.day) {
      return 'yesterday';
    }
    
    // Check for this month
    if (start.year == now.year && start.month == now.month && start.day == 1) {
      return 'this month';
    }
    
    // Check for last month
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    if (start.year == lastMonth.year && start.month == lastMonth.month && start.day == 1) {
      return 'last month';
    }
    
    // Default format
    return 'from ${_formatDate(start)} to ${_formatDate(end)}';
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format amount with Indian number system
  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    }
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} L';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(2)} K';
    }
    return amount.toStringAsFixed(2);
  }
}
