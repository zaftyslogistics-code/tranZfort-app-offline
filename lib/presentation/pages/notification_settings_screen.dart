import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notification Settings Screen
/// Allows users to configure notification preferences
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _maintenanceEnabled = true;
  bool _paymentEnabled = true;
  bool _documentEnabled = true;
  bool _creditEnabled = true;
  bool _summaryEnabled = true;
  
  TimeOfDay _summaryTime = const TimeOfDay(hour: 20, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _maintenanceEnabled = prefs.getBool('notif_maintenance') ?? true;
      _paymentEnabled = prefs.getBool('notif_payment') ?? true;
      _documentEnabled = prefs.getBool('notif_document') ?? true;
      _creditEnabled = prefs.getBool('notif_credit') ?? true;
      _summaryEnabled = prefs.getBool('notif_summary') ?? true;
      
      final hour = prefs.getInt('summary_hour') ?? 20;
      final minute = prefs.getInt('summary_minute') ?? 0;
      _summaryTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _savePreference(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveSummaryTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('summary_hour', _summaryTime.hour);
    await prefs.setInt('summary_minute', _summaryTime.minute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Reminder Notifications', theme),
          SwitchListTile(
            title: const Text('Maintenance Reminders'),
            subtitle: const Text('Get notified 7 days before maintenance is due'),
            value: _maintenanceEnabled,
            onChanged: (value) {
              setState(() => _maintenanceEnabled = value);
              _savePreference('notif_maintenance', value);
            },
            secondary: const Icon(Icons.build),
          ),
          SwitchListTile(
            title: const Text('Payment Alerts'),
            subtitle: const Text('Get notified about pending payments'),
            value: _paymentEnabled,
            onChanged: (value) {
              setState(() => _paymentEnabled = value);
              _savePreference('notif_payment', value);
            },
            secondary: const Icon(Icons.payment),
          ),
          SwitchListTile(
            title: const Text('Document Expiry'),
            subtitle: const Text('Get notified 30 days before documents expire'),
            value: _documentEnabled,
            onChanged: (value) {
              setState(() => _documentEnabled = value);
              _savePreference('notif_document', value);
            },
            secondary: const Icon(Icons.description),
          ),
          SwitchListTile(
            title: const Text('Credit Limit Warnings'),
            subtitle: const Text('Get notified when party credit exceeds limit'),
            value: _creditEnabled,
            onChanged: (value) {
              setState(() => _creditEnabled = value);
              _savePreference('notif_credit', value);
            },
            secondary: const Icon(Icons.warning),
          ),
          
          const Divider(height: 32),
          
          _buildSectionHeader('Daily Summary', theme),
          SwitchListTile(
            title: const Text('Daily Business Summary'),
            subtitle: const Text('Get a daily summary of your business'),
            value: _summaryEnabled,
            onChanged: (value) {
              setState(() => _summaryEnabled = value);
              _savePreference('notif_summary', value);
            },
            secondary: const Icon(Icons.summarize),
          ),
          ListTile(
            title: const Text('Summary Time'),
            subtitle: Text('Receive summary at ${_summaryTime.format(context)}'),
            trailing: const Icon(Icons.access_time),
            enabled: _summaryEnabled,
            onTap: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _summaryTime,
              );
              if (time != null) {
                setState(() => _summaryTime = time);
                await _saveSummaryTime();
              }
            },
          ),
          
          const Divider(height: 32),
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Test notification sent')),
                );
              },
              icon: const Icon(Icons.notifications_active),
              label: const Text('Send Test Notification'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
