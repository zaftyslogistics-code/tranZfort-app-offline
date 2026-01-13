import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Audit logger for tracking tool executions and critical operations
class AuditLogger {
  static final AuditLogger _instance = AuditLogger._();
  static AuditLogger get instance => _instance;
  
  AuditLogger._();

  final List<AuditEntry> _entries = [];
  final int _maxEntries = 5000;

  /// Log a tool execution
  void logToolExecution({
    required String toolName,
    required Map<String, dynamic> arguments,
    required bool success,
    String? error,
    Map<String, dynamic>? result,
    Duration? executionTime,
  }) {
    _addEntry(AuditEntry(
      timestamp: DateTime.now(),
      category: AuditCategory.toolExecution,
      action: toolName,
      success: success,
      details: {
        'arguments': arguments,
        'result': result,
        'error': error,
        'executionTimeMs': executionTime?.inMilliseconds,
      },
    ));
  }

  /// Log model operation
  void logModelOperation({
    required String operation,
    required bool success,
    String? modelPath,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    _addEntry(AuditEntry(
      timestamp: DateTime.now(),
      category: AuditCategory.modelOperation,
      action: operation,
      success: success,
      details: {
        'modelPath': modelPath,
        'error': error,
        ...?metadata,
      },
    ));
  }

  /// Log generation event
  void logGeneration({
    required String prompt,
    required int promptLength,
    String? response,
    int? responseLength,
    int? tokenCount,
    Duration? duration,
    bool? cancelled,
    String? error,
  }) {
    _addEntry(AuditEntry(
      timestamp: DateTime.now(),
      category: AuditCategory.generation,
      action: 'generate_text',
      success: error == null,
      details: {
        'promptLength': promptLength,
        'responseLength': responseLength,
        'tokenCount': tokenCount,
        'durationMs': duration?.inMilliseconds,
        'cancelled': cancelled,
        'error': error,
        // Don't log full prompt/response in production for privacy
        if (kDebugMode) ...{
          'prompt': prompt.substring(0, prompt.length > 100 ? 100 : prompt.length),
          'response': response?.substring(0, response.length > 100 ? 100 : response.length),
        },
      },
    ));
  }

  /// Log user action
  void logUserAction({
    required String action,
    Map<String, dynamic>? metadata,
  }) {
    _addEntry(AuditEntry(
      timestamp: DateTime.now(),
      category: AuditCategory.userAction,
      action: action,
      success: true,
      details: metadata ?? {},
    ));
  }

  /// Log system event
  void logSystemEvent({
    required String event,
    required bool success,
    String? error,
    Map<String, dynamic>? metadata,
  }) {
    _addEntry(AuditEntry(
      timestamp: DateTime.now(),
      category: AuditCategory.systemEvent,
      action: event,
      success: success,
      details: {
        'error': error,
        ...?metadata,
      },
    ));
  }

  /// Get entries by category
  List<AuditEntry> getEntriesByCategory(AuditCategory category) {
    return _entries.where((e) => e.category == category).toList();
  }

  /// Get entries by time range
  List<AuditEntry> getEntriesByTimeRange(DateTime start, DateTime end) {
    return _entries.where((e) {
      return e.timestamp.isAfter(start) && e.timestamp.isBefore(end);
    }).toList();
  }

  /// Get failed operations
  List<AuditEntry> getFailedOperations() {
    return _entries.where((e) => !e.success).toList();
  }

  /// Get recent entries
  List<AuditEntry> getRecentEntries({int limit = 100}) {
    final entries = _entries.reversed.take(limit).toList();
    return entries.reversed.toList();
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    final stats = <String, dynamic>{};
    
    // Count by category
    for (final category in AuditCategory.values) {
      final entries = getEntriesByCategory(category);
      stats['${category.name}_count'] = entries.length;
      stats['${category.name}_success'] = entries.where((e) => e.success).length;
      stats['${category.name}_failed'] = entries.where((e) => !e.success).length;
    }
    
    // Tool execution stats
    final toolExecutions = getEntriesByCategory(AuditCategory.toolExecution);
    final toolStats = <String, Map<String, int>>{};
    for (final entry in toolExecutions) {
      final tool = entry.action;
      toolStats[tool] ??= {'total': 0, 'success': 0, 'failed': 0};
      toolStats[tool]!['total'] = toolStats[tool]!['total']! + 1;
      if (entry.success) {
        toolStats[tool]!['success'] = toolStats[tool]!['success']! + 1;
      } else {
        toolStats[tool]!['failed'] = toolStats[tool]!['failed']! + 1;
      }
    }
    stats['tool_stats'] = toolStats;
    
    return stats;
  }

  /// Export audit log as JSON
  String exportAsJson() {
    final data = _entries.map((e) => e.toJson()).toList();
    return jsonEncode(data);
  }

  /// Clear old entries to prevent memory leaks
  void cleanup({Duration? olderThan}) {
    final cutoff = olderThan ?? const Duration(days: 7);
    final now = DateTime.now();
    
    _entries.removeWhere((entry) {
      final age = now.difference(entry.timestamp);
      return age > cutoff;
    });

    if (_entries.length > _maxEntries) {
      _entries.removeRange(0, _entries.length - _maxEntries);
    }
  }

  /// Clear all entries
  void clear() {
    _entries.clear();
  }

  void _addEntry(AuditEntry entry) {
    _entries.add(entry);
    
    if (_entries.length > _maxEntries) {
      _entries.removeAt(0);
    }

    if (kDebugMode && !entry.success) {
      print('[AuditLogger] FAILED: ${entry.category.name} - ${entry.action}');
      if (entry.details['error'] != null) {
        print('[AuditLogger] Error: ${entry.details['error']}');
      }
    }
  }
}

enum AuditCategory {
  toolExecution,
  modelOperation,
  generation,
  userAction,
  systemEvent,
}

class AuditEntry {
  final DateTime timestamp;
  final AuditCategory category;
  final String action;
  final bool success;
  final Map<String, dynamic> details;

  AuditEntry({
    required this.timestamp,
    required this.category,
    required this.action,
    required this.success,
    required this.details,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'category': category.name,
    'action': action,
    'success': success,
    'details': details,
  };
}
