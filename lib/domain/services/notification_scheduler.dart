import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:tranzfort_tms/data/database.dart';
import 'package:tranzfort_tms/domain/services/notification_service.dart';

/// Notification Scheduler
/// Handles scheduling and delivery of local notifications
class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  final NotificationService _notificationService;

  NotificationScheduler(this._notificationsPlugin, this._notificationService);

  /// Initialize notification system
  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();

    // Create notification channels
    await _createNotificationChannels();
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  /// Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return;

    // Maintenance channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'maintenance',
        'Maintenance Reminders',
        description: 'Notifications for vehicle maintenance',
        importance: Importance.high,
      ),
    );

    // Payment channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'payments',
        'Payment Alerts',
        description: 'Notifications for pending payments',
        importance: Importance.high,
      ),
    );

    // Document channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'documents',
        'Document Expiry',
        description: 'Notifications for expiring documents',
        importance: Importance.high,
      ),
    );

    // Credit channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'credit',
        'Credit Warnings',
        description: 'Notifications for credit limit warnings',
        importance: Importance.max,
      ),
    );

    // Summary channel
    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'summary',
        'Daily Summary',
        description: 'Daily business summary notifications',
        importance: Importance.defaultImportance,
      ),
    );
  }

  /// Schedule daily check at 8 AM
  Future<void> scheduleDailyCheck() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8, // 8 AM
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      0,
      'Daily Check',
      'Checking for reminders...',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'maintenance',
          'Maintenance Reminders',
          channelDescription: 'Daily maintenance check',
          importance: Importance.low,
          priority: Priority.low,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Schedule daily summary at 8 PM
  Future<void> scheduleDailySummary() async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20, // 8 PM
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Get summary data
    final summary = await _notificationService.getDailySummary();

    await _notificationsPlugin.zonedSchedule(
      1,
      'Daily Business Summary',
      'Active Trips: ${summary.activeTrips}, Pending Payments: ${summary.pendingPayments}',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'summary',
          'Daily Summary',
          channelDescription: 'Daily business summary',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Check and send maintenance reminders
  Future<void> checkMaintenanceReminders() async {
    final reminders = await _notificationService.checkMaintenanceReminders();

    for (int i = 0; i < reminders.length; i++) {
      final reminder = reminders[i];
      await _notificationsPlugin.show(
        100 + i,
        'Maintenance Due',
        reminder.message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'maintenance',
            'Maintenance Reminders',
            channelDescription: 'Vehicle maintenance reminders',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  /// Check and send payment alerts
  Future<void> checkPaymentAlerts() async {
    final alerts = await _notificationService.checkPendingPayments();

    for (int i = 0; i < alerts.length; i++) {
      final alert = alerts[i];
      await _notificationsPlugin.show(
        200 + i,
        'Pending Payment',
        alert.message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'payments',
            'Payment Alerts',
            channelDescription: 'Pending payment alerts',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  /// Check and send document expiry warnings
  Future<void> checkDocumentExpiry() async {
    final warnings = await _notificationService.checkDocumentExpiry();

    for (int i = 0; i < warnings.length; i++) {
      final warning = warnings[i];
      await _notificationsPlugin.show(
        300 + i,
        'Document Expiring',
        warning.message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'documents',
            'Document Expiry',
            channelDescription: 'Document expiry warnings',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  }

  /// Check and send credit limit warnings
  Future<void> checkCreditLimits() async {
    final warnings = await _notificationService.checkCreditLimits();

    for (int i = 0; i < warnings.length; i++) {
      final warning = warnings[i];
      await _notificationsPlugin.show(
        400 + i,
        'Credit Limit Warning',
        warning.message,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'credit',
            'Credit Warnings',
            channelDescription: 'Credit limit warnings',
            importance: Importance.max,
            priority: Priority.max,
          ),
        ),
      );
    }
  }

  /// Run all checks
  Future<void> runAllChecks() async {
    await checkMaintenanceReminders();
    await checkPaymentAlerts();
    await checkDocumentExpiry();
    await checkCreditLimits();
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - navigate to relevant screen
    print('Notification tapped: ${response.payload}');
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
