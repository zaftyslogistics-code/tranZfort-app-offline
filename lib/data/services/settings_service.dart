import 'dart:convert';
import 'dart:math';
import 'package:drift/drift.dart';
import '../database.dart';

class SettingsService {
  final AppDatabase _db;

  SettingsService(this._db);

  // Setting categories
  static const List<String> settingCategories = [
    'general',
    'appearance',
    'notifications',
    'backup',
    'security',
    'system',
    'reports',
    'export',
  ];

  // Default settings
  static const Map<String, Map<String, String>> defaultSettings = {
    'general': {
      'app_name': 'Tranzfort TMS',
      'company_name': 'Your Company',
      'company_address': 'Your Address',
      'company_phone': '+91-XXXXXXXXXX',
      'company_email': 'info@yourcompany.com',
      'currency': 'INR',
      'date_format': 'dd/MM/yyyy',
      'time_format': '24h',
      'language': 'en',
      'timezone': 'Asia/Kolkata',
      'auto_save': 'true',
      'session_timeout': '30',
    },
    'appearance': {
      'theme': 'light',
      'primary_color': '#2196F3',
      'accent_color': '#4CAF50',
      'font_size': 'medium',
      'animations_enabled': 'true',
      'compact_view': 'false',
      'show_grid': 'true',
      'card_elevation': '2',
    },
    'notifications': {
      'email_enabled': 'true',
      'push_enabled': 'true',
      'sound_enabled': 'true',
      'vibration_enabled': 'true',
      'trip_notifications': 'true',
      'payment_notifications': 'true',
      'expense_notifications': 'true',
      'backup_notifications': 'true',
      'system_notifications': 'true',
    },
    'backup': {
      'auto_backup_enabled': 'true',
      'backup_frequency': 'daily',
      'backup_retention_days': '30',
      'backup_encryption': 'true',
      'backup_compression': 'true',
      'backup_location': 'local',
      'cloud_backup_enabled': 'false',
      'backup_schedule_time': '02:00',
    },
    'security': {
      'password_min_length': '6',
      'password_require_uppercase': 'true',
      'password_require_lowercase': 'true',
      'password_require_numbers': 'true',
      'password_require_special': 'true',
      'session_timeout_minutes': '30',
      'max_login_attempts': '5',
      'lockout_duration_minutes': '15',
      'two_factor_enabled': 'false',
      'audit_logging': 'true',
    },
    'system': {
      'debug_mode': 'false',
      'log_level': 'info',
      'cache_enabled': 'true',
      'cache_size_mb': '100',
      'auto_cleanup_days': '90',
      'performance_monitoring': 'true',
      'error_reporting': 'true',
      'usage_analytics': 'false',
    },
    'reports': {
      'default_date_range': '30',
      'chart_animation_enabled': 'true',
      'auto_refresh_enabled': 'true',
      'refresh_interval_minutes': '5',
      'decimal_places': '2',
      'show_zero_values': 'false',
      'chart_theme': 'default',
    },
    'export': {
      'default_format': 'csv',
      'include_headers': 'true',
      'date_format_export': 'dd-MM-yyyy',
      'compression_enabled': 'true',
      'auto_open_after_export': 'true',
      'export_location': 'downloads',
    },
  };

  // Get all settings
  Future<Map<String, Map<String, String>>> getAllSettings() async {
    final settings = await _db.select(_db.systemSettings).get();
    final settingsMap = <String, Map<String, String>>{};

    // Initialize with defaults
    for (final category in settingCategories) {
      settingsMap[category] = Map<String, String>.from(defaultSettings[category] ?? {});
    }

    // Override with database values
    for (final setting in settings) {
      if (settingCategories.contains(setting.category)) {
        settingsMap[setting.category]![setting.key] = setting.value;
      }
    }

    return settingsMap;
  }

  // Get settings by category
  Future<Map<String, String>> getSettingsByCategory(String category) async {
    final settings = await (_db.select(_db.systemSettings)
          ..where((s) => s.category.equals(category)))
        .get();

    final categorySettings = Map<String, String>.from(defaultSettings[category] ?? {});
    
    for (final setting in settings) {
      categorySettings[setting.key] = setting.value;
    }

    return categorySettings;
  }

  // Get single setting
  Future<String?> getSetting(String category, String key) async {
    final setting = await (_db.select(_db.systemSettings)
          ..where((s) => 
                s.category.equals(category) &
                s.key.equals(key)))
        .getSingleOrNull();

    return setting?.value;
  }

  // Set single setting
  Future<void> setSetting(
    String category,
    String key,
    String value, {
    String? updatedBy,
  }) async {
    final existingSetting = await (_db.select(_db.systemSettings)
          ..where((s) => 
                s.category.equals(category) &
                s.key.equals(key)))
        .getSingleOrNull();

    if (existingSetting != null) {
      // Update existing setting
      await (_db.update(_db.systemSettings)..where((s) => s.id.equals(existingSetting.id)))
          .write(SystemSettingsCompanion(
            value: Value(value),
            updatedBy: Value(updatedBy ?? 'system'),
            updatedAt: Value(DateTime.now()),
          ));
    } else {
      // Create new setting
      await _db.into(_db.systemSettings).insert(SystemSettingsCompanion.insert(
        id: _generateId(),
        key: key,
        value: value,
        description: _getSettingDescription(category, key),
        category: category,
        updatedBy: updatedBy ?? 'system',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
    }
  }

  // Set multiple settings
  Future<void> setSettings(
    String category,
    Map<String, String> settings, {
    String? updatedBy,
  }) async {
    for (final entry in settings.entries) {
      await setSetting(category, entry.key, entry.value, updatedBy: updatedBy);
    }
  }

  // Reset settings to defaults
  Future<void> resetSettingsToDefaults(String category) async {
    final defaults = defaultSettings[category] ?? {};
    await setSettings(category, defaults);
  }

  // Reset all settings to defaults
  Future<void> resetAllSettingsToDefaults() async {
    // Delete all existing settings
    await _db.delete(_db.systemSettings).go();
    
    // Insert default settings
    for (final category in defaultSettings.keys) {
      await resetSettingsToDefaults(category);
    }
  }

  // Delete setting
  Future<void> deleteSetting(String category, String key) async {
    await (_db.delete(_db.systemSettings)
          ..where((s) => 
                s.category.equals(category) &
                s.key.equals(key)))
        .go();
  }

  // Delete all settings in category
  Future<void> deleteSettingsByCategory(String category) async {
    await (_db.delete(_db.systemSettings)
          ..where((s) => s.category.equals(category)))
        .go();
  }

  // Export settings to JSON
  Future<String> exportSettings() async {
    final allSettings = await getAllSettings();
    return jsonEncode(allSettings);
  }

  // Import settings from JSON
  Future<void> importSettings(String jsonSettings) async {
    try {
      final settings = jsonDecode(jsonSettings) as Map<String, dynamic>;
      
      for (final categoryEntry in settings.entries) {
        final category = categoryEntry.key;
        final categorySettings = categoryEntry.value as Map<String, dynamic>;
        
        for (final settingEntry in categorySettings.entries) {
          final key = settingEntry.key;
          final value = settingEntry.value.toString();
          
          await setSetting(category, key, value);
        }
      }
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }

  // Get setting options for dropdown/select fields
  List<String> getSettingOptions(String category, String key) {
    final options = {
      'general': {
        'currency': ['INR', 'USD', 'EUR', 'GBP', 'JPY'],
        'date_format': ['dd/MM/yyyy', 'MM/dd/yyyy', 'yyyy-MM-dd', 'dd-MM-yyyy'],
        'time_format': ['12h', '24h'],
        'language': ['en', 'hi', 'gu', 'ta', 'te', 'mr', 'kn'],
        'timezone': [
          'Asia/Kolkata', 'Asia/Dubai', 'Asia/Singapore', 'Europe/London',
          'America/New_York', 'America/Los_Angeles', 'Australia/Sydney',
          'Europe/Paris', 'Asia/Tokyo', 'America/Chicago'
        ],
      },
      'appearance': {
        'theme': ['light', 'dark', 'system'],
        'primary_color': ['#2196F3', '#4CAF50', '#FF9800', '#9C27B0', '#F44336', '#795548'],
        'accent_color': ['#4CAF50', '#FF9800', '#2196F3', '#9C27B0', '#F44336', '#795548'],
        'font_size': ['small', 'medium', 'large'],
        'card_elevation': ['0', '1', '2', '3', '4', '5', '6', '7', '8'],
      },
      'backup': {
        'backup_frequency': ['daily', 'weekly', 'monthly'],
        'backup_location': ['local', 'cloud'],
      },
      'system': {
        'log_level': ['debug', 'info', 'warning', 'error'],
      },
      'reports': {
        'chart_theme': ['default', 'blue', 'green', 'orange', 'purple', 'red'],
      },
      'export': {
        'default_format': ['csv', 'excel', 'pdf'],
        'export_location': ['downloads', 'documents', 'desktop'],
      },
    };

    return options[category]?[key] ?? [];
  }

  // Get system information
  Future<Map<String, dynamic>> getSystemInfo() async {
    final settings = await getAllSettings();
    
    return {
      'app_version': '1.0.0',
      'build_number': '1',
      'total_settings': settings.values.fold(0, (sum, category) => sum + category.length),
      'categories': settings.keys.toList(),
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  // Clear cache
  Future<void> clearCache() async {
    // In a real implementation, you would clear application cache
    // TODO: Implement cache clearing
  }

  // Get application statistics
  Future<Map<String, dynamic>> getApplicationStatistics() async {
    final settings = await getAllSettings();
    final systemInfo = await getSystemInfo();
    
    return {
      'total_settings': settings.values.fold(0, (sum, category) => sum + category.length),
      'categories': settings.keys.length,
      'app_version': systemInfo['app_version'],
      'last_updated': systemInfo['last_updated'],
    };
  }

  // Validate setting value
  bool validateSetting(String category, String key, String value) {
    final options = getSettingOptions(category, key);
    return options.isEmpty || options.contains(value);
  }

  // Get setting categories with descriptions
  Map<String, String> getSettingCategories() {
    return {
      'general': 'General application settings',
      'appearance': 'Appearance and UI preferences',
      'notifications': 'Notification preferences',
      'backup': 'Backup and restore settings',
      'security': 'Security and authentication',
      'system': 'System and performance settings',
      'reports': 'Reports and analytics settings',
      'export': 'Export and data sharing settings',
    };
  }

  // Check if setting exists
  Future<bool> settingExists(String category, String key) async {
    final setting = await getSetting(category, key);
    return setting != null;
  }

  // Get boolean setting
  Future<bool> getBoolSetting(String category, String key, {bool defaultValue = false}) async {
    final value = await getSetting(category, key);
    return value?.toLowerCase() == 'true' ?? defaultValue;
  }

  // Get integer setting
  Future<int> getIntSetting(String category, String key, {int defaultValue = 0}) async {
    final value = await getSetting(category, key);
    return int.tryParse(value ?? '') ?? defaultValue;
  }

  // Get double setting
  Future<double> getDoubleSetting(String category, String key, {double defaultValue = 0.0}) async {
    final value = await getSetting(category, key);
    return double.tryParse(value ?? '') ?? defaultValue;
  }

  // Get setting description
  String _getSettingDescription(String category, String key) {
    final descriptions = {
      'general': {
        'app_name': 'Application name',
        'company_name': 'Company name',
        'company_address': 'Company address',
        'company_phone': 'Company phone number',
        'company_email': 'Company email address',
        'currency': 'Default currency',
        'date_format': 'Date display format',
        'time_format': 'Time display format',
        'language': 'Application language',
        'timezone': 'Application timezone',
        'auto_save': 'Auto-save enabled',
        'session_timeout': 'Session timeout in minutes',
      },
      'appearance': {
        'theme': 'Application theme',
        'primary_color': 'Primary color',
        'accent_color': 'Accent color',
        'font_size': 'Font size',
        'animations_enabled': 'Animations enabled',
        'compact_view': 'Compact view',
        'show_grid': 'Show grid',
        'card_elevation': 'Card elevation',
      },
      // Add more descriptions as needed
    };

    return descriptions[category]?[key] ?? '$category.$key';
  }

  // Generate unique ID
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() + 
           Random().nextInt(1000).toString().padLeft(3, '0');
  }
}
