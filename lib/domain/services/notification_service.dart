import 'package:drift/drift.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Notification Service
/// Manages smart notifications and reminders for the app
class NotificationService {
  final AppDatabase _database;

  NotificationService(this._database);

  /// Check for due maintenance reminders
  Future<List<MaintenanceReminder>> checkMaintenanceReminders() async {
    final schedules = await _database.select(_database.maintenanceSchedules)
        .get()
        .then((list) => list.where((s) => s.status == 'PENDING').toList());

    final reminders = <MaintenanceReminder>[];
    final now = DateTime.now();
    final sevenDaysFromNow = now.add(const Duration(days: 7));

    for (final schedule in schedules) {
      final dueDate = schedule.dueDate;
      
      // Check if due within 7 days
      if (dueDate.isBefore(sevenDaysFromNow) && dueDate.isAfter(now)) {
        final daysUntilDue = dueDate.difference(now).inDays;
        reminders.add(MaintenanceReminder(
          vehicleId: schedule.vehicleId,
          maintenanceType: schedule.maintenanceType,
          dueDate: dueDate,
          daysUntilDue: daysUntilDue,
          isOverdue: false,
        ));
      }
      
      // Check if overdue
      if (dueDate.isBefore(now)) {
        final daysOverdue = now.difference(dueDate).inDays;
        reminders.add(MaintenanceReminder(
          vehicleId: schedule.vehicleId,
          maintenanceType: schedule.maintenanceType,
          dueDate: dueDate,
          daysUntilDue: -daysOverdue,
          isOverdue: true,
        ));
      }
    }

    return reminders;
  }

  /// Check for pending payments
  Future<List<PaymentReminder>> checkPendingPayments() async {
    final trips = await _database.select(_database.trips)
        .get()
        .then((list) => list.where((t) => t.status == 'COMPLETED').toList());

    final reminders = <PaymentReminder>[];

    for (final trip in trips) {
      final payments = await _database.select(_database.payments)
          .get()
          .then((list) => list.where((p) => p.tripId == trip.id).toList());

      double totalPaid = 0;
      for (final payment in payments) {
        if (payment.type == 'IN') {
          totalPaid += payment.amount;
        }
      }

      final pendingAmount = trip.freightAmount - totalPaid;
      
      if (pendingAmount > 0) {
        reminders.add(PaymentReminder(
          tripId: trip.id,
          partyId: trip.partyId,
          fromLocation: trip.fromLocation,
          toLocation: trip.toLocation,
          pendingAmount: pendingAmount,
          completedDate: trip.actualEndDate,
        ));
      }
    }

    return reminders;
  }

  /// Check for document expiry
  Future<List<DocumentExpiryReminder>> checkDocumentExpiry() async {
    final vehicles = await _database.select(_database.vehicles).get();
    final drivers = await _database.select(_database.drivers).get();

    final reminders = <DocumentExpiryReminder>[];
    final now = DateTime.now();
    final thirtyDaysFromNow = now.add(const Duration(days: 30));

    // Check vehicle documents
    for (final vehicle in vehicles) {
      if (vehicle.insuranceExpiry != null) {
        final expiry = vehicle.insuranceExpiry!;
        if (expiry.isBefore(thirtyDaysFromNow) && expiry.isAfter(now)) {
          reminders.add(DocumentExpiryReminder(
            entityType: 'Vehicle',
            entityId: vehicle.id,
            entityName: vehicle.truckNumber,
            documentType: 'Insurance',
            expiryDate: expiry,
            daysUntilExpiry: expiry.difference(now).inDays,
          ));
        }
      }

      if (vehicle.fitnessExpiry != null) {
        final expiry = vehicle.fitnessExpiry!;
        if (expiry.isBefore(thirtyDaysFromNow) && expiry.isAfter(now)) {
          reminders.add(DocumentExpiryReminder(
            entityType: 'Vehicle',
            entityId: vehicle.id,
            entityName: vehicle.truckNumber,
            documentType: 'Fitness Certificate',
            expiryDate: expiry,
            daysUntilExpiry: expiry.difference(now).inDays,
          ));
        }
      }
    }

    // Check driver documents
    for (final driver in drivers) {
      if (driver.licenseExpiry != null) {
        final expiry = driver.licenseExpiry!;
        if (expiry.isBefore(thirtyDaysFromNow) && expiry.isAfter(now)) {
          reminders.add(DocumentExpiryReminder(
            entityType: 'Driver',
            entityId: driver.id,
            entityName: driver.name,
            documentType: 'License',
            expiryDate: expiry,
            daysUntilExpiry: expiry.difference(now).inDays,
          ));
        }
      }
    }

    return reminders;
  }

  /// Check for party credit limit warnings
  Future<List<CreditLimitWarning>> checkCreditLimits() async {
    final parties = await _database.select(_database.parties).get();
    final warnings = <CreditLimitWarning>[];

    for (final party in parties) {
      final payments = await _database.select(_database.payments)
          .get()
          .then((list) => list.where((p) => p.partyId == party.id).toList());

      double balance = 0;
      for (final payment in payments) {
        if (payment.type == 'IN') {
          balance += payment.amount;
        } else {
          balance -= payment.amount;
        }
      }

      // Warn if balance exceeds ₹50,000
      if (balance < -50000) {
        warnings.add(CreditLimitWarning(
          partyId: party.id,
          partyName: party.name,
          outstandingBalance: -balance,
          severity: balance < -100000 ? 'HIGH' : 'MEDIUM',
        ));
      }
    }

    return warnings;
  }

  /// Get daily summary
  Future<DailySummary> getDailySummary() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final activeTrips = await _database.select(_database.trips)
        .get()
        .then((list) => list.where((t) => t.status == 'RUNNING').length);

    final todayExpenses = await _database.select(_database.expenses)
        .get()
        .then((list) => list.where((e) => 
            e.createdAt.isAfter(startOfDay) && 
            e.createdAt.isBefore(endOfDay)).toList());

    double totalExpenses = 0;
    for (final expense in todayExpenses) {
      totalExpenses += expense.amount;
    }

    final pendingPayments = await checkPendingPayments();
    double totalPending = 0;
    for (final reminder in pendingPayments) {
      totalPending += reminder.pendingAmount;
    }

    return DailySummary(
      activeTrips: activeTrips,
      todayExpenses: totalExpenses,
      pendingPayments: totalPending,
      date: now,
    );
  }

  /// Get all notifications
  Future<NotificationSummary> getAllNotifications() async {
    final maintenance = await checkMaintenanceReminders();
    final payments = await checkPendingPayments();
    final documents = await checkDocumentExpiry();
    final credits = await checkCreditLimits();

    return NotificationSummary(
      maintenanceReminders: maintenance,
      paymentReminders: payments,
      documentExpiry: documents,
      creditWarnings: credits,
      totalCount: maintenance.length + payments.length + 
                  documents.length + credits.length,
    );
  }
}

/// Maintenance Reminder Model
class MaintenanceReminder {
  final String vehicleId;
  final String maintenanceType;
  final DateTime dueDate;
  final int daysUntilDue;
  final bool isOverdue;

  MaintenanceReminder({
    required this.vehicleId,
    required this.maintenanceType,
    required this.dueDate,
    required this.daysUntilDue,
    required this.isOverdue,
  });

  String get message {
    if (isOverdue) {
      return '$maintenanceType is overdue by ${-daysUntilDue} days';
    }
    return '$maintenanceType due in $daysUntilDue days';
  }
}

/// Payment Reminder Model
class PaymentReminder {
  final String tripId;
  final String partyId;
  final String fromLocation;
  final String toLocation;
  final double pendingAmount;
  final DateTime? completedDate;

  PaymentReminder({
    required this.tripId,
    required this.partyId,
    required this.fromLocation,
    required this.toLocation,
    required this.pendingAmount,
    this.completedDate,
  });

  String get message {
    return 'Pending payment of ₹${pendingAmount.toStringAsFixed(0)} for trip $fromLocation → $toLocation';
  }
}

/// Document Expiry Reminder Model
class DocumentExpiryReminder {
  final String entityType;
  final String entityId;
  final String entityName;
  final String documentType;
  final DateTime expiryDate;
  final int daysUntilExpiry;

  DocumentExpiryReminder({
    required this.entityType,
    required this.entityId,
    required this.entityName,
    required this.documentType,
    required this.expiryDate,
    required this.daysUntilExpiry,
  });

  String get message {
    return '$documentType for $entityName expires in $daysUntilExpiry days';
  }
}

/// Credit Limit Warning Model
class CreditLimitWarning {
  final String partyId;
  final String partyName;
  final double outstandingBalance;
  final String severity;

  CreditLimitWarning({
    required this.partyId,
    required this.partyName,
    required this.outstandingBalance,
    required this.severity,
  });

  String get message {
    return '$partyName has outstanding balance of ₹${outstandingBalance.toStringAsFixed(0)}';
  }
}

/// Daily Summary Model
class DailySummary {
  final int activeTrips;
  final double todayExpenses;
  final double pendingPayments;
  final DateTime date;

  DailySummary({
    required this.activeTrips,
    required this.todayExpenses,
    required this.pendingPayments,
    required this.date,
  });
}

/// Notification Summary Model
class NotificationSummary {
  final List<MaintenanceReminder> maintenanceReminders;
  final List<PaymentReminder> paymentReminders;
  final List<DocumentExpiryReminder> documentExpiry;
  final List<CreditLimitWarning> creditWarnings;
  final int totalCount;

  NotificationSummary({
    required this.maintenanceReminders,
    required this.paymentReminders,
    required this.documentExpiry,
    required this.creditWarnings,
    required this.totalCount,
  });

  bool get hasNotifications => totalCount > 0;
}
