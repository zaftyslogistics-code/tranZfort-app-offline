import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tranzfort_tms/domain/services/notification_service.dart';
import 'package:tranzfort_tms/presentation/providers/database_provider.dart';

/// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final database = ref.watch(databaseProvider);
  return NotificationService(database);
});

/// All Notifications Provider
final allNotificationsProvider = FutureProvider<NotificationSummary>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getAllNotifications();
});

/// Maintenance Reminders Provider
final maintenanceRemindersProvider = FutureProvider<List<MaintenanceReminder>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.checkMaintenanceReminders();
});

/// Payment Reminders Provider
final paymentRemindersProvider = FutureProvider<List<PaymentReminder>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.checkPendingPayments();
});

/// Document Expiry Provider
final documentExpiryProvider = FutureProvider<List<DocumentExpiryReminder>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.checkDocumentExpiry();
});

/// Credit Limit Warnings Provider
final creditLimitWarningsProvider = FutureProvider<List<CreditLimitWarning>>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.checkCreditLimits();
});

/// Daily Summary Provider
final dailySummaryProvider = FutureProvider<DailySummary>((ref) async {
  final service = ref.watch(notificationServiceProvider);
  return await service.getDailySummary();
});
