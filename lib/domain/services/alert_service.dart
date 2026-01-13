import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/alert.dart';
import '../../data/database.dart';

class AlertService {
  static final AlertService _instance = AlertService._();
  static AlertService get instance => _instance;
  
  AlertService._();

  final List<Alert> _alerts = [];
  AlertThresholds _thresholds = const AlertThresholds();
  bool _isEnabled = true;

  List<Alert> get alerts => List.unmodifiable(_alerts);
  AlertThresholds get thresholds => _thresholds;
  bool get isEnabled => _isEnabled;
  int get unreadCount => _alerts.where((a) => !a.isRead).length;

  Future<void> initialize() async {
    await _loadThresholds();
    await _loadAlerts();
    await _loadEnabled();
  }

  Future<void> _loadThresholds() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('alert_thresholds');
    if (json != null) {
      try {
        _thresholds = AlertThresholds.fromJson(jsonDecode(json));
      } catch (e) {
        if (kDebugMode) {
          print('[AlertService] Failed to load thresholds: $e');
        }
      }
    }
  }

  Future<void> _loadAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('alerts');
    if (json != null) {
      try {
        final List<dynamic> list = jsonDecode(json);
        _alerts.clear();
        _alerts.addAll(list.map((e) => Alert.fromJson(e)));
      } catch (e) {
        if (kDebugMode) {
          print('[AlertService] Failed to load alerts: $e');
        }
      }
    }
  }

  Future<void> _loadEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool('alerts_enabled') ?? true;
  }

  Future<void> _saveAlerts() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_alerts.map((e) => e.toJson()).toList());
    await prefs.setString('alerts', json);
  }

  Future<void> updateThresholds(AlertThresholds thresholds) async {
    _thresholds = thresholds;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('alert_thresholds', jsonEncode(thresholds.toJson()));
  }

  Future<void> setEnabled(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alerts_enabled', enabled);
  }

  Future<void> checkForAlerts(AppDatabase database) async {
    if (!_isEnabled) return;

    await _checkUnusualExpenses(database);
    await _checkCreditRisk(database);
    await _checkMaintenanceDue(database);
    await _checkLowProfitRoutes(database);
    await _checkHighFuelCost(database);

    await _saveAlerts();
  }

  Future<void> _checkUnusualExpenses(AppDatabase database) async {
    try {
      final expenses = await database.managers.expenses.get();
      if (expenses.isEmpty) return;

      final categoryAverages = <String, double>{};
      final categoryCounts = <String, int>{};

      for (final expense in expenses) {
        final category = expense.category;
        categoryAverages[category] = (categoryAverages[category] ?? 0) + expense.amount;
        categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
      }

      categoryAverages.forEach((category, total) {
        categoryAverages[category] = total / categoryCounts[category]!;
      });

      final recentExpenses = expenses.where((e) {
        final age = DateTime.now().difference(e.createdAt);
        return age.inDays <= 7;
      });

      for (final expense in recentExpenses) {
        final average = categoryAverages[expense.category] ?? 0;
        if (average > 0 && expense.amount > average * _thresholds.unusualExpenseMultiplier) {
          _addAlert(
            type: AlertType.unusualExpense,
            severity: AlertSeverity.warning,
            title: 'Unusual Expense Detected',
            message: '${expense.category} expense of ₹${expense.amount.toStringAsFixed(0)} is ${_thresholds.unusualExpenseMultiplier}x higher than average (₹${average.toStringAsFixed(0)})',
            metadata: {
              'expenseId': expense.id,
              'category': expense.category,
              'amount': expense.amount,
              'average': average,
            },
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[AlertService] Error checking unusual expenses: $e');
      }
    }
  }

  Future<void> _checkCreditRisk(AppDatabase database) async {
    return;
  }

  Future<void> _checkMaintenanceDue(AppDatabase database) async {
    return;
  }

  Future<void> _checkLowProfitRoutes(AppDatabase database) async {
    try {
      final trips = await database.managers.trips.get();
      final completedTrips = trips.where((t) => t.status == 'completed');

      final routeProfits = <String, List<double>>{};

      for (final trip in completedTrips) {
        final route = '${trip.fromLocation}-${trip.toLocation}';
        final profit = trip.freightAmount;
        routeProfits[route] = (routeProfits[route] ?? [])..add(profit);
      }

      routeProfits.forEach((route, profits) {
        final avgProfit = profits.reduce((a, b) => a + b) / profits.length;
        if (avgProfit < _thresholds.lowProfitThreshold && profits.length >= 3) {
          _addAlert(
            type: AlertType.lowProfitRoute,
            severity: avgProfit < 0 ? AlertSeverity.critical : AlertSeverity.warning,
            title: 'Low Profit Route',
            message: 'Route $route has low average profit: ₹${avgProfit.toStringAsFixed(0)} (${profits.length} trips)',
            metadata: {
              'route': route,
              'averageProfit': avgProfit,
              'tripCount': profits.length,
            },
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('[AlertService] Error checking low profit routes: $e');
      }
    }
  }

  Future<void> _checkHighFuelCost(AppDatabase database) async {
    return;
  }

  void _addAlert({
    required AlertType type,
    required AlertSeverity severity,
    required String title,
    required String message,
    Map<String, dynamic> metadata = const {},
  }) {
    final isDuplicate = _alerts.any((a) =>
        a.type == type &&
        a.title == title &&
        a.message == message &&
        DateTime.now().difference(a.timestamp).inHours < 24);

    if (isDuplicate) return;

    final alert = Alert(
      id: const Uuid().v4(),
      type: type,
      severity: severity,
      title: title,
      message: message,
      timestamp: DateTime.now(),
      metadata: metadata,
    );

    _alerts.insert(0, alert);

    if (_alerts.length > 100) {
      _alerts.removeRange(100, _alerts.length);
    }
  }

  Future<void> markAsRead(String alertId) async {
    final index = _alerts.indexWhere((a) => a.id == alertId);
    if (index != -1) {
      _alerts[index] = _alerts[index].copyWith(isRead: true);
      await _saveAlerts();
    }
  }

  Future<void> markAllAsRead() async {
    for (var i = 0; i < _alerts.length; i++) {
      _alerts[i] = _alerts[i].copyWith(isRead: true);
    }
    await _saveAlerts();
  }

  Future<void> dismissAlert(String alertId) async {
    _alerts.removeWhere((a) => a.id == alertId);
    await _saveAlerts();
  }

  Future<void> clearAll() async {
    _alerts.clear();
    await _saveAlerts();
  }

  List<Alert> getAlertsByType(AlertType type) {
    return _alerts.where((a) => a.type == type).toList();
  }

  List<Alert> getUnreadAlerts() {
    return _alerts.where((a) => !a.isRead).toList();
  }
}
