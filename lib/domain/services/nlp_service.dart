import 'package:tranzfort_tms/domain/models/query_intent.dart';

/// Natural Language Processing Service
/// Provides advanced NLP capabilities without requiring a full LLM
class NlpService {
  /// Classify the intent of a user query
  QueryIntent classifyIntent(String input) {
    final normalized = input.toLowerCase().trim();

    // Query intents (show, find, search, filter)
    if (_isQueryIntent(normalized)) {
      return QueryIntent(
        type: IntentType.query,
        action: _extractQueryAction(normalized),
        entities: _extractEntities(normalized),
        confidence: _calculateConfidence(normalized, IntentType.query),
      );
    }

    // Command intents (add, update, delete, complete)
    if (_isCommandIntent(normalized)) {
      return QueryIntent(
        type: IntentType.command,
        action: _extractCommandAction(normalized),
        entities: _extractEntities(normalized),
        confidence: _calculateConfidence(normalized, IntentType.command),
      );
    }

    // Question intents (how much, how many, when, where)
    if (_isQuestionIntent(normalized)) {
      return QueryIntent(
        type: IntentType.question,
        action: _extractQuestionAction(normalized),
        entities: _extractEntities(normalized),
        confidence: _calculateConfidence(normalized, IntentType.question),
      );
    }

    // Default to query
    return QueryIntent(
      type: IntentType.query,
      action: 'search',
      entities: _extractEntities(normalized),
      confidence: 0.5,
    );
  }

  /// Check if input is a query intent
  bool _isQueryIntent(String input) {
    final queryKeywords = [
      'show', 'display', 'list', 'find', 'search', 'get', 'fetch',
      'view', 'see', 'check', 'look', 'filter', 'give me'
    ];
    return queryKeywords.any((keyword) => input.contains(keyword));
  }

  /// Check if input is a command intent
  bool _isCommandIntent(String input) {
    final commandKeywords = [
      'add', 'create', 'new', 'insert', 'update', 'edit', 'modify',
      'delete', 'remove', 'complete', 'finish', 'start', 'cancel',
      'mark', 'set', 'change'
    ];
    return commandKeywords.any((keyword) => input.contains(keyword));
  }

  /// Check if input is a question intent
  bool _isQuestionIntent(String input) {
    final questionKeywords = [
      'how much', 'how many', 'what', 'when', 'where', 'who',
      'which', 'why', 'can you', 'could you', 'is there', 'are there'
    ];
    return questionKeywords.any((keyword) => input.contains(keyword));
  }

  /// Extract query action
  String _extractQueryAction(String input) {
    if (input.contains('show') || input.contains('display') || input.contains('list')) {
      return 'show';
    }
    if (input.contains('find') || input.contains('search')) {
      return 'find';
    }
    if (input.contains('filter')) {
      return 'filter';
    }
    return 'show';
  }

  /// Extract command action
  String _extractCommandAction(String input) {
    if (input.contains('add') || input.contains('create') || input.contains('new')) {
      return 'create';
    }
    if (input.contains('update') || input.contains('edit') || input.contains('modify')) {
      return 'update';
    }
    if (input.contains('delete') || input.contains('remove')) {
      return 'delete';
    }
    if (input.contains('complete') || input.contains('finish')) {
      return 'complete';
    }
    if (input.contains('start') || input.contains('begin')) {
      return 'start';
    }
    if (input.contains('cancel')) {
      return 'cancel';
    }
    return 'update';
  }

  /// Extract question action
  String _extractQuestionAction(String input) {
    if (input.contains('how much')) {
      return 'calculate_amount';
    }
    if (input.contains('how many')) {
      return 'count';
    }
    if (input.contains('when')) {
      return 'find_date';
    }
    if (input.contains('where')) {
      return 'find_location';
    }
    if (input.contains('who')) {
      return 'find_person';
    }
    return 'query';
  }

  /// Extract entities from input
  Map<String, dynamic> _extractEntities(String input) {
    final entities = <String, dynamic>{};

    // Extract entity type (trips, expenses, payments, etc.)
    entities['entityType'] = _extractEntityType(input);

    // Extract date/time
    final dateRange = _extractDateRange(input);
    if (dateRange != null) {
      entities['dateRange'] = dateRange;
    }

    // Extract amount
    final amount = _extractAmount(input);
    if (amount != null) {
      entities['amount'] = amount;
    }

    // Extract category
    final category = _extractCategory(input);
    if (category != null) {
      entities['category'] = category;
    }

    // Extract location
    final location = _extractLocation(input);
    if (location != null) {
      entities['location'] = location;
    }

    // Extract status
    final status = _extractStatus(input);
    if (status != null) {
      entities['status'] = status;
    }

    return entities;
  }

  /// Extract entity type
  String _extractEntityType(String input) {
    if (input.contains('trip')) return 'trips';
    if (input.contains('expense')) return 'expenses';
    if (input.contains('payment')) return 'payments';
    if (input.contains('vehicle')) return 'vehicles';
    if (input.contains('driver')) return 'drivers';
    if (input.contains('party') || input.contains('customer')) return 'parties';
    if (input.contains('fuel')) return 'fuel_entries';
    if (input.contains('maintenance')) return 'maintenance';
    return 'trips'; // Default
  }

  /// Extract date range
  Map<String, DateTime>? _extractDateRange(String input) {
    final now = DateTime.now();

    // Today
    if (input.contains('today')) {
      return {
        'start': DateTime(now.year, now.month, now.day),
        'end': DateTime(now.year, now.month, now.day, 23, 59, 59),
      };
    }

    // Yesterday
    if (input.contains('yesterday')) {
      final yesterday = now.subtract(const Duration(days: 1));
      return {
        'start': DateTime(yesterday.year, yesterday.month, yesterday.day),
        'end': DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
      };
    }

    // This week
    if (input.contains('this week')) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      return {
        'start': DateTime(weekStart.year, weekStart.month, weekStart.day),
        'end': now,
      };
    }

    // Last week
    if (input.contains('last week')) {
      final lastWeekEnd = now.subtract(Duration(days: now.weekday));
      final lastWeekStart = lastWeekEnd.subtract(const Duration(days: 6));
      return {
        'start': DateTime(lastWeekStart.year, lastWeekStart.month, lastWeekStart.day),
        'end': DateTime(lastWeekEnd.year, lastWeekEnd.month, lastWeekEnd.day, 23, 59, 59),
      };
    }

    // This month
    if (input.contains('this month')) {
      return {
        'start': DateTime(now.year, now.month, 1),
        'end': now,
      };
    }

    // Last month
    if (input.contains('last month')) {
      final lastMonth = DateTime(now.year, now.month - 1, 1);
      final lastMonthEnd = DateTime(now.year, now.month, 0);
      return {
        'start': lastMonth,
        'end': lastMonthEnd,
      };
    }

    // Last 7 days
    if (input.contains('last 7 days') || input.contains('past week')) {
      return {
        'start': now.subtract(const Duration(days: 7)),
        'end': now,
      };
    }

    // Last 30 days
    if (input.contains('last 30 days') || input.contains('past month')) {
      return {
        'start': now.subtract(const Duration(days: 30)),
        'end': now,
      };
    }

    return null;
  }

  /// Extract amount
  double? _extractAmount(String input) {
    final amountRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:rupees?|rs|₹)?');
    final match = amountRegex.firstMatch(input);
    if (match != null) {
      return double.tryParse(match.group(1)!);
    }
    return null;
  }

  /// Extract category
  String? _extractCategory(String input) {
    if (input.contains('fuel') || input.contains('diesel') || input.contains('petrol')) {
      return 'FUEL';
    }
    if (input.contains('toll')) {
      return 'TOLL';
    }
    if (input.contains('food') || input.contains('lunch') || input.contains('dinner')) {
      return 'FOOD';
    }
    if (input.contains('maintenance') || input.contains('repair')) {
      return 'MAINTENANCE';
    }
    if (input.contains('parking')) {
      return 'PARKING';
    }
    if (input.contains('loading') || input.contains('unloading')) {
      return 'LOADING_UNLOADING';
    }
    if (input.contains('driver') && input.contains('salary')) {
      return 'DRIVER_SALARY';
    }
    return null;
  }

  /// Extract location
  String? _extractLocation(String input) {
    // Look for "to [location]" or "from [location]" patterns
    final toRegex = RegExp(r'to\s+([A-Za-z\s]+?)(?:\s|$|,)');
    final fromRegex = RegExp(r'from\s+([A-Za-z\s]+?)(?:\s|$|,)');
    
    final toMatch = toRegex.firstMatch(input);
    if (toMatch != null) {
      return toMatch.group(1)?.trim();
    }

    final fromMatch = fromRegex.firstMatch(input);
    if (fromMatch != null) {
      return fromMatch.group(1)?.trim();
    }

    return null;
  }

  /// Extract status
  String? _extractStatus(String input) {
    if (input.contains('pending')) return 'PENDING';
    if (input.contains('completed') || input.contains('complete')) return 'COMPLETED';
    if (input.contains('in progress') || input.contains('ongoing')) return 'IN_PROGRESS';
    if (input.contains('cancelled') || input.contains('canceled')) return 'CANCELLED';
    if (input.contains('planned')) return 'PLANNED';
    return null;
  }

  /// Calculate confidence score
  double _calculateConfidence(String input, IntentType type) {
    double confidence = 0.5;

    // Increase confidence based on keyword matches
    final words = input.split(' ');
    
    // More words generally means more context
    if (words.length > 3) confidence += 0.1;
    if (words.length > 5) confidence += 0.1;

    // Specific patterns increase confidence
    if (_extractDateRange(input) != null) confidence += 0.15;
    if (_extractAmount(input) != null) confidence += 0.1;
    if (_extractCategory(input) != null) confidence += 0.1;
    if (_extractLocation(input) != null) confidence += 0.1;

    return confidence.clamp(0.0, 1.0);
  }

  /// Normalize query for better matching
  String normalizeQuery(String input) {
    return input
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll(RegExp(r'[^\w\s]'), '');
  }

  /// Get suggestions for incomplete queries
  List<String> getSuggestions(String partialInput) {
    final suggestions = <String>[];
    final normalized = partialInput.toLowerCase();

    if (normalized.contains('show') || normalized.contains('trip')) {
      suggestions.addAll([
        'Show trips today',
        'Show trips last week',
        'Show trips last month',
        'Show completed trips',
        'Show pending trips',
      ]);
    }

    if (normalized.contains('expense') || normalized.contains('spent')) {
      suggestions.addAll([
        'Show expenses today',
        'Show fuel expenses',
        'How much did I spend on fuel?',
        'Show expenses last month',
      ]);
    }

    if (normalized.contains('payment')) {
      suggestions.addAll([
        'Show pending payments',
        'Show payments this month',
        'Show received payments',
      ]);
    }

    return suggestions.take(5).toList();
  }
}
