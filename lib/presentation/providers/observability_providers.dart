import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/performance_monitor.dart';
import '../../domain/services/audit_logger.dart';
import '../../domain/services/feature_flags.dart';

/// Performance monitor provider
final performanceMonitorProvider = Provider<PerformanceMonitor>((ref) {
  return PerformanceMonitor.instance;
});

/// Audit logger provider
final auditLoggerProvider = Provider<AuditLogger>((ref) {
  return AuditLogger.instance;
});

/// Feature flags provider
final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return FeatureFlags.instance;
});

/// Provider to check if a specific feature is enabled
final featureEnabledProvider = Provider.family<bool, Feature>((ref, feature) {
  final flags = ref.watch(featureFlagsProvider);
  return flags.isEnabled(feature);
});

/// Performance summary provider
final performanceSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final monitor = ref.watch(performanceMonitorProvider);
  return monitor.getSummary();
});

/// Audit statistics provider
final auditStatisticsProvider = Provider<Map<String, dynamic>>((ref) {
  final logger = ref.watch(auditLoggerProvider);
  return logger.getStatistics();
});
