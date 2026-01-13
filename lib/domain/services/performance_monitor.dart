import 'dart:async';
import 'package:flutter/foundation.dart';

/// Performance monitoring service for tracking LLM and tool execution metrics
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._();
  static PerformanceMonitor get instance => _instance;
  
  PerformanceMonitor._();

  final Map<String, _PerformanceMetric> _metrics = {};
  final List<_PerformanceEvent> _events = [];
  final int _maxEvents = 1000;

  /// Start tracking a performance metric
  String startMetric(String name, {Map<String, dynamic>? metadata}) {
    final id = '${name}_${DateTime.now().millisecondsSinceEpoch}';
    _metrics[id] = _PerformanceMetric(
      id: id,
      name: name,
      startTime: DateTime.now(),
      metadata: metadata ?? {},
    );
    return id;
  }

  /// End tracking a performance metric
  void endMetric(String id, {Map<String, dynamic>? additionalMetadata}) {
    final metric = _metrics[id];
    if (metric == null) return;

    metric.endTime = DateTime.now();
    metric.duration = metric.endTime!.difference(metric.startTime);
    
    if (additionalMetadata != null) {
      metric.metadata.addAll(additionalMetadata);
    }

    _addEvent(_PerformanceEvent(
      timestamp: metric.endTime!,
      type: 'metric_completed',
      name: metric.name,
      duration: metric.duration,
      metadata: metric.metadata,
    ));

    if (kDebugMode) {
      print('[PerformanceMonitor] ${metric.name}: ${metric.duration?.inMilliseconds}ms');
    }
  }

  /// Log a performance event
  void logEvent(String type, String name, {Map<String, dynamic>? metadata}) {
    _addEvent(_PerformanceEvent(
      timestamp: DateTime.now(),
      type: type,
      name: name,
      metadata: metadata ?? {},
    ));
  }

  /// Get metrics by name
  List<_PerformanceMetric> getMetricsByName(String name) {
    return _metrics.values.where((m) => m.name == name).toList();
  }

  /// Get average duration for a metric
  Duration? getAverageDuration(String metricName) {
    final metrics = getMetricsByName(metricName)
        .where((m) => m.duration != null)
        .toList();
    
    if (metrics.isEmpty) return null;
    
    final totalMs = metrics.fold<int>(
      0,
      (sum, m) => sum + m.duration!.inMilliseconds,
    );
    
    return Duration(milliseconds: totalMs ~/ metrics.length);
  }

  /// Get recent events
  List<_PerformanceEvent> getRecentEvents({int limit = 100}) {
    final events = _events.reversed.take(limit).toList();
    return events.reversed.toList();
  }

  /// Get events by type
  List<_PerformanceEvent> getEventsByType(String type) {
    return _events.where((e) => e.type == type).toList();
  }

  /// Clear old metrics to prevent memory leaks
  void cleanup({Duration? olderThan}) {
    final cutoff = olderThan ?? const Duration(hours: 1);
    final now = DateTime.now();
    
    _metrics.removeWhere((key, metric) {
      final age = now.difference(metric.startTime);
      return age > cutoff;
    });

    if (_events.length > _maxEvents) {
      _events.removeRange(0, _events.length - _maxEvents);
    }
  }

  /// Get performance summary
  Map<String, dynamic> getSummary() {
    final summary = <String, dynamic>{};
    
    final metricNames = _metrics.values.map((m) => m.name).toSet();
    for (final name in metricNames) {
      final avg = getAverageDuration(name);
      final count = getMetricsByName(name).length;
      summary[name] = {
        'count': count,
        'averageMs': avg?.inMilliseconds,
      };
    }
    
    return summary;
  }

  /// Clear all metrics and events
  void clear() {
    _metrics.clear();
    _events.clear();
  }

  void _addEvent(_PerformanceEvent event) {
    _events.add(event);
    if (_events.length > _maxEvents) {
      _events.removeAt(0);
    }
  }
}

class _PerformanceMetric {
  final String id;
  final String name;
  final DateTime startTime;
  final Map<String, dynamic> metadata;
  
  DateTime? endTime;
  Duration? duration;

  _PerformanceMetric({
    required this.id,
    required this.name,
    required this.startTime,
    required this.metadata,
  });
}

class _PerformanceEvent {
  final DateTime timestamp;
  final String type;
  final String name;
  final Duration? duration;
  final Map<String, dynamic> metadata;

  _PerformanceEvent({
    required this.timestamp,
    required this.type,
    required this.name,
    this.duration,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'type': type,
    'name': name,
    'durationMs': duration?.inMilliseconds,
    'metadata': metadata,
  };
}
