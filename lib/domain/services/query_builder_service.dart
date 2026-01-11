import 'package:tranzfort_tms/domain/models/query_intent.dart';
import 'package:tranzfort_tms/data/database.dart';

/// Query Builder Service
/// Converts natural language queries to database queries
class QueryBuilderService {
  final AppDatabase _database;

  QueryBuilderService(this._database);

  /// Build and execute query from intent
  Future<Map<String, dynamic>> executeQuery(QueryIntent intent) async {
    try {
      final entityType = intent.entities['entityType'] as String?;
      
      switch (entityType) {
        case 'trips':
          return await _queryTrips(intent);
        case 'expenses':
          return await _queryExpenses(intent);
        case 'payments':
          return await _queryPayments(intent);
        case 'vehicles':
          return await _queryVehicles(intent);
        case 'drivers':
          return await _queryDrivers(intent);
        case 'fuel_entries':
          return await _queryFuelEntries(intent);
        default:
          return await _queryTrips(intent); // Default to trips
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to execute query: $e',
      };
    }
  }

  /// Query trips
  Future<Map<String, dynamic>> _queryTrips(QueryIntent intent) async {
    // Get all trips first, then filter in memory for simplicity
    final allTrips = await _database.select(_database.trips).get();
    
    var results = allTrips;

    // Apply date range filter
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;
    if (dateRange != null) {
      results = results.where((trip) {
        return trip.startDate.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               trip.startDate.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply status filter
    final status = intent.entities['status'] as String?;
    if (status != null) {
      results = results.where((trip) => trip.status == status).toList();
    }

    // Apply location filter
    final location = intent.entities['location'] as String?;
    if (location != null) {
      results = results.where((trip) {
        return trip.fromLocation.toLowerCase().contains(location.toLowerCase()) ||
               trip.toLocation.toLowerCase().contains(location.toLowerCase());
      }).toList();
    }

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'trips',
    };
  }

  /// Query expenses
  Future<Map<String, dynamic>> _queryExpenses(QueryIntent intent) async {
    final allExpenses = await _database.select(_database.expenses).get();
    var results = allExpenses;

    // Apply date range filter
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;
    if (dateRange != null) {
      results = results.where((expense) {
        return expense.createdAt.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               expense.createdAt.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }

    // Apply category filter
    final category = intent.entities['category'] as String?;
    if (category != null) {
      results = results.where((expense) => expense.category == category).toList();
    }

    // Calculate total if it's a "how much" question
    if (intent.action == 'calculate_amount') {
      final total = results.fold<double>(0, (sum, expense) => sum + expense.amount);
      return {
        'success': true,
        'count': results.length,
        'total': total,
        'data': results,
        'type': 'expenses',
      };
    }

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'expenses',
    };
  }

  /// Query payments
  Future<Map<String, dynamic>> _queryPayments(QueryIntent intent) async {
    final allPayments = await _database.select(_database.payments).get();
    var results = allPayments;

    // Apply date range filter
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;
    if (dateRange != null) {
      results = results.where((payment) {
        return payment.createdAt.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               payment.createdAt.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }

    // Calculate total if it's a "how much" question
    if (intent.action == 'calculate_amount') {
      final totalIn = results
          .where((p) => p.type == 'IN')
          .fold<double>(0, (sum, payment) => sum + payment.amount);
      final totalOut = results
          .where((p) => p.type == 'OUT')
          .fold<double>(0, (sum, payment) => sum + payment.amount);
      
      return {
        'success': true,
        'count': results.length,
        'totalIn': totalIn,
        'totalOut': totalOut,
        'net': totalIn - totalOut,
        'data': results,
        'type': 'payments',
      };
    }

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'payments',
    };
  }

  /// Query vehicles
  Future<Map<String, dynamic>> _queryVehicles(QueryIntent intent) async {
    final query = _database.select(_database.vehicles);
    final results = await query.get();

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'vehicles',
    };
  }

  /// Query drivers
  Future<Map<String, dynamic>> _queryDrivers(QueryIntent intent) async {
    final query = _database.select(_database.drivers);
    final results = await query.get();

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'drivers',
    };
  }

  /// Query fuel entries
  Future<Map<String, dynamic>> _queryFuelEntries(QueryIntent intent) async {
    final allFuelEntries = await _database.select(_database.fuelEntries).get();
    var results = allFuelEntries;

    // Apply date range filter
    final dateRange = intent.entities['dateRange'] as Map<String, DateTime>?;
    if (dateRange != null) {
      results = results.where((entry) {
        return entry.entryDate.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               entry.entryDate.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }

    // Calculate totals
    if (intent.action == 'calculate_amount') {
      final totalCost = results.fold<double>(0, (sum, entry) => sum + entry.totalCost);
      final totalLiters = results.fold<double>(0, (sum, entry) => sum + entry.quantityLiters);
      
      return {
        'success': true,
        'count': results.length,
        'totalCost': totalCost,
        'totalLiters': totalLiters,
        'data': results,
        'type': 'fuel_entries',
      };
    }

    return {
      'success': true,
      'count': results.length,
      'data': results,
      'type': 'fuel_entries',
    };
  }

  /// Get statistics for a query
  Future<Map<String, dynamic>> getStatistics(String entityType, Map<String, DateTime>? dateRange) async {
    switch (entityType) {
      case 'trips':
        return await _getTripStatistics(dateRange);
      case 'expenses':
        return await _getExpenseStatistics(dateRange);
      case 'payments':
        return await _getPaymentStatistics(dateRange);
      default:
        return {};
    }
  }

  /// Get trip statistics
  Future<Map<String, dynamic>> _getTripStatistics(Map<String, DateTime>? dateRange) async {
    var trips = await _database.select(_database.trips).get();
    
    if (dateRange != null) {
      trips = trips.where((trip) {
        return trip.startDate.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               trip.startDate.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }
    
    return {
      'total': trips.length,
      'completed': trips.where((t) => t.status == 'COMPLETED').length,
      'inProgress': trips.where((t) => t.status == 'IN_PROGRESS').length,
      'pending': trips.where((t) => t.status == 'PENDING').length,
      'totalRevenue': trips.fold<double>(0, (sum, t) => sum + t.freightAmount),
    };
  }

  /// Get expense statistics
  Future<Map<String, dynamic>> _getExpenseStatistics(Map<String, DateTime>? dateRange) async {
    var expenses = await _database.select(_database.expenses).get();
    
    if (dateRange != null) {
      expenses = expenses.where((expense) {
        return expense.createdAt.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               expense.createdAt.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }
    
    // Group by category
    final byCategory = <String, double>{};
    for (final expense in expenses) {
      byCategory[expense.category] = (byCategory[expense.category] ?? 0) + expense.amount;
    }

    return {
      'total': expenses.length,
      'totalAmount': expenses.fold<double>(0, (sum, e) => sum + e.amount),
      'byCategory': byCategory,
    };
  }

  /// Get payment statistics
  Future<Map<String, dynamic>> _getPaymentStatistics(Map<String, DateTime>? dateRange) async {
    var payments = await _database.select(_database.payments).get();
    
    if (dateRange != null) {
      payments = payments.where((payment) {
        return payment.createdAt.isAfter(dateRange['start']!.subtract(const Duration(days: 1))) &&
               payment.createdAt.isBefore(dateRange['end']!.add(const Duration(days: 1)));
      }).toList();
    }
    
    final totalIn = payments
        .where((p) => p.type == 'IN')
        .fold<double>(0, (sum, p) => sum + p.amount);
    final totalOut = payments
        .where((p) => p.type == 'OUT')
        .fold<double>(0, (sum, p) => sum + p.amount);

    return {
      'total': payments.length,
      'totalIn': totalIn,
      'totalOut': totalOut,
      'net': totalIn - totalOut,
    };
  }
}
