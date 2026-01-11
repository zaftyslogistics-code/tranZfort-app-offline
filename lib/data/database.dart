import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DataClassName('Vehicle')
class Vehicles extends Table {
  TextColumn get id => text()();
  TextColumn get truckNumber => text().unique()();
  TextColumn get truckType => text()();
  RealColumn get capacity => real()();
  TextColumn get fuelType => text()();
  TextColumn get registrationNumber => text()();
  DateTimeColumn get insuranceExpiry => dateTime().nullable()();
  DateTimeColumn get fitnessExpiry => dateTime().nullable()();
  TextColumn get assignedDriverId => text().nullable()();
  TextColumn get status => text()();
  TextColumn get currentLocation => text().nullable()();
  RealColumn get totalKm => real().nullable()();
  DateTimeColumn get lastServiceDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Driver')
class Drivers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get licenseNumber => text()();
  TextColumn get licenseType => text()();
  DateTimeColumn get licenseExpiry => dateTime().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get emergencyContact => text().nullable()();
  TextColumn get status => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Party')
class Parties extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get mobile => text()();
  TextColumn get city => text()();
  TextColumn get gst => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Trip')
class Trips extends Table {
  TextColumn get id => text()();
  TextColumn get fromLocation => text()();
  TextColumn get toLocation => text()();
  TextColumn get vehicleId => text()();
  TextColumn get driverId => text()();
  TextColumn get partyId => text()();
  RealColumn get freightAmount => real()();
  RealColumn get advanceAmount => real().nullable()();
  TextColumn get status => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get expectedEndDate => dateTime().nullable()();
  DateTimeColumn get actualEndDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Expense')
class Expenses extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  TextColumn get category => text()();
  RealColumn get amount => real()();
  TextColumn get paidMode => text()();
  TextColumn get billImagePath => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Payment')
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get tripId => text().nullable()();
  TextColumn get partyId => text()();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  TextColumn get mode => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Document')
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get filePath => text()();
  TextColumn get description => text()();
  IntColumn get fileSize => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Users table
class Users extends Table {
  @override
  String get tableName => 'users';
  
  TextColumn get id => text()();
  TextColumn get username => text().unique()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get role => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get profilePicture => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// UserSessions table
class UserSessions extends Table {
  @override
  String get tableName => 'user_sessions';
  
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get sessionToken => text().unique()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// UserPermissions table
class UserPermissions extends Table {
  @override
  String get tableName => 'user_permissions';
  
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get permission => text()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ActivityLogs table
class ActivityLogs extends Table {
  @override
  String get tableName => 'activity_logs';
  
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get action => text()();
  TextColumn get entityType => text().nullable()();
  TextColumn get entityId => text().nullable()();
  TextColumn get description => text()();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get userAgent => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// SystemSettings table
class SystemSettings extends Table {
  @override
  String get tableName => 'system_settings';
  
  TextColumn get id => text()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
  TextColumn get description => text()();
  TextColumn get category => text()();
  TextColumn get updatedBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ScheduledReports table
class ScheduledReports extends Table {
  @override
  String get tableName => 'scheduled_reports';
  
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get reportType => text()();
  TextColumn get scheduleType => text()(); // daily, weekly, monthly, yearly
  TextColumn get scheduleConfig => text()(); // JSON config for schedule
  TextColumn get recipients => text()(); // JSON array of email addresses
  TextColumn get format => text()(); // csv, excel, pdf
  TextColumn get filters => text()(); // JSON filters for report
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get nextRunAt => dateTime()();
  DateTimeColumn get lastRunAt => dateTime().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ReportExecutions table
class ReportExecutions extends Table {
  @override
  String get tableName => 'report_executions';
  
  TextColumn get id => text()();
  TextColumn get scheduledReportId => text()();
  TextColumn get status => text()(); // pending, running, completed, failed
  TextColumn get filePath => text().nullable()();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get executedBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// EmailNotifications table
class EmailNotifications extends Table {
  @override
  String get tableName => 'email_notifications';
  
  TextColumn get id => text()();
  TextColumn get reportExecutionId => text()();
  TextColumn get recipient => text()();
  TextColumn get subject => text()();
  TextColumn get body => text()();
  TextColumn get status => text()(); // pending, sent, failed
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Backups table
class Backups extends Table {
  @override
  String get tableName => 'backups';
  
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get type => text()(); // full, incremental, differential
  TextColumn get filePath => text()();
  IntColumn get fileSize => integer()(); // in bytes
  TextColumn get checksum => text()(); // for integrity verification
  TextColumn get encryptionKey => text().nullable()(); // encrypted backup key
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompressed => boolean().withDefault(const Constant(true))();
  TextColumn get status => text()(); // pending, running, completed, failed
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// BackupJobs table
class BackupJobs extends Table {
  @override
  String get tableName => 'backup_jobs';
  
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get backupType => text()(); // full, incremental, differential
  TextColumn get scheduleType => text()(); // daily, weekly, monthly
  TextColumn get scheduleConfig => text()(); // JSON config
  TextColumn get retentionPolicy => text()(); // JSON config for retention
  TextColumn get targetPath => text()(); // backup storage location
  BoolColumn get isEncrypted => boolean().withDefault(const Constant(false))();
  BoolColumn get isCompressed => boolean().withDefault(const Constant(true))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get nextRunAt => dateTime()();
  DateTimeColumn get lastRunAt => dateTime().nullable()();
  TextColumn get lastBackupId => text().nullable()(); // reference to last successful backup
  TextColumn get createdBy => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Routes table
class Routes extends Table {
  @override
  String get tableName => 'routes';
  
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get routeType => text()(); // one-way, round-trip
  TextColumn get distance => text()(); // in kilometers
  TextColumn get duration => text()(); // in hours
  TextColumn get status => text()(); // active, inactive
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// RouteHistory table
class RouteHistory extends Table {
  @override
  String get tableName => 'route_history';
  
  TextColumn get id => text()();
  TextColumn get routeId => text()();
  TextColumn get driverId => text()();
  TextColumn get vehicleId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get status => text()(); // completed, cancelled
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// FuelEntries table
class FuelEntries extends Table {
  @override
  String get tableName => 'fuel_entries';
  
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  TextColumn get fuelType => text()(); // diesel, petrol
  RealColumn get quantityLiters => real()(); // in liters
  RealColumn get costPerLiter => real()(); // cost per liter
  RealColumn get totalCost => real()(); // total cost
  RealColumn get odometerReading => real()(); // odometer reading in km
  TextColumn get fuelPumpName => text().nullable()();
  DateTimeColumn get entryDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// MaintenanceSchedules table
class MaintenanceSchedules extends Table {
  @override
  String get tableName => 'maintenance_schedules';
  
  TextColumn get id => text()();
  TextColumn get vehicleId => text()();
  TextColumn get maintenanceType => text()(); // oil change, tire rotation
  DateTimeColumn get scheduleDate => dateTime()();
  DateTimeColumn get dueDate => dateTime()();
  TextColumn get status => text()(); // pending, completed
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// GpsBreadcrumbs table for GPS tracking
class GpsBreadcrumbs extends Table {
  @override
  String get tableName => 'gps_breadcrumbs';
  
  TextColumn get id => text()();
  TextColumn get tripId => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get speed => real()();
  RealColumn get accuracy => real()();
  
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Vehicles,
    Drivers,
    Parties,
    Trips,
    Expenses,
    Payments,
    Documents,
    Users,
    UserSessions,
    UserPermissions,
    ActivityLogs,
    SystemSettings,
    ScheduledReports,
    ReportExecutions,
    EmailNotifications,
    Backups,
    BackupJobs,
    Routes,
    RouteHistory,
    FuelEntries,
    MaintenanceSchedules,
    GpsBreadcrumbs,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (migrator, from, to) async {
          if (from < 2) {
            await migrator.deleteTable('documents');
            await migrator.createTable(documents);
          }
        },
      );

  static QueryExecutor _openConnection() {
    // Use file-based database for data persistence
    return LazyDatabase(() async {
      try {
        final Directory dbFolder;
        if (Platform.isIOS || Platform.isAndroid) {
          dbFolder = await getApplicationSupportDirectory();
        } else {
          dbFolder = await getApplicationSupportDirectory();
        }

        print('Database folder: ${dbFolder.path}');
        final file = File(p.join(dbFolder.path, 'tranzfort_tms.sqlite'));
        print('Database file path: ${file.path}');

        // Ensure the directory exists (and ensure parent folder exists too)
        if (!await dbFolder.exists()) {
          print('Creating database directory');
          await dbFolder.create(recursive: true);
        }
        if (!await file.parent.exists()) {
          await file.parent.create(recursive: true);
        }
        if (!await file.exists()) {
          await file.create(recursive: true);
        }

        try {
          return NativeDatabase(file);
        } catch (e) {
          // Fallback: Some systems block access to Documents/AppSupport via policy
          // (e.g., Controlled Folder Access). Try a temp folder.
          final tmp = await getTemporaryDirectory();
          final tmpFile = File(p.join(tmp.path, 'tranzfort_tms.sqlite'));
          print('Falling back to temp database file path: ${tmpFile.path}');
          if (!await tmpFile.parent.exists()) {
            await tmpFile.parent.create(recursive: true);
          }
          if (!await tmpFile.exists()) {
            await tmpFile.create(recursive: true);
          }
          try {
            return NativeDatabase(tmpFile);
          } catch (_) {
            return NativeDatabase.memory();
          }
        }
      } catch (e) {
        print('Failed to create file database: $e');
        rethrow;
      }
    });
    
    // Original file-based approach (commented out for now):
    /*
    if (Platform.isAndroid || Platform.isIOS) {
      return LazyDatabase(() async {
        try {
          final dbFolder = await getApplicationDocumentsDirectory();
          print('Database folder: ${dbFolder.path}');
          final file = File(p.join(dbFolder.path, 'tranzfort_tms.sqlite'));
          print('Database file path: ${file.path}');
          
          // Ensure the directory exists
          if (!await dbFolder.exists()) {
            print('Creating database directory');
            await dbFolder.create(recursive: true);
          }
          
          final database = NativeDatabase(file);
          print('NativeDatabase created successfully');
          return database;
        } catch (e) {
          print('Failed to open file database, using memory database: $e');
          // Fallback to memory database if file access fails
          return NativeDatabase.memory();
        }
      });
    }
    // For web or desktop testing
    return LazyDatabase(() async {
      try {
        print('Using memory database for web/desktop');
        return NativeDatabase.memory();
      } catch (e) {
        print('Failed to open memory database: $e');
        rethrow;
      }
    });
    */
  }
}
