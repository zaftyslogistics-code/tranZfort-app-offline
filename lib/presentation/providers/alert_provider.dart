import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/alert_service.dart';
import '../../domain/models/alert.dart';
import '../../data/database.dart';

final alertServiceProvider = Provider<AlertService>((ref) {
  return AlertService.instance;
});

final alertsProvider = StateProvider<List<Alert>>((ref) {
  final service = ref.watch(alertServiceProvider);
  return service.alerts;
});

final unreadAlertsCountProvider = Provider<int>((ref) {
  final alerts = ref.watch(alertsProvider);
  return alerts.where((a) => !a.isRead).length;
});

final alertThresholdsProvider = StateProvider<AlertThresholds>((ref) {
  final service = ref.watch(alertServiceProvider);
  return service.thresholds;
});

final alertsEnabledProvider = StateProvider<bool>((ref) {
  final service = ref.watch(alertServiceProvider);
  return service.isEnabled;
});

final alertsByTypeProvider = Provider.family<List<Alert>, AlertType>((ref, type) {
  final service = ref.watch(alertServiceProvider);
  return service.getAlertsByType(type);
});

final checkAlertsProvider = FutureProvider.autoDispose<void>((ref) async {
  final service = ref.watch(alertServiceProvider);
  await service.initialize();
  ref.invalidate(alertsProvider);
});
