import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// Settings Screen with Language Selector
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('Language Settings', theme),
          _buildLanguageTile(context, 'English', const Locale('en')),
          _buildLanguageTile(context, 'हिंदी (Hindi)', const Locale('hi')),
          _buildLanguageTile(context, 'ਪੰਜਾਬੀ (Punjabi)', const Locale('pa')),
          _buildLanguageTile(context, 'தமிழ் (Tamil)', const Locale('ta')),
          _buildLanguageTile(context, 'తెలుగు (Telugu)', const Locale('te')),
          _buildLanguageTile(context, 'मराठी (Marathi)', const Locale('mr')),
          _buildLanguageTile(context, 'ગુજરાતી (Gujarati)', const Locale('gu')),
          _buildLanguageTile(context, 'বাংলা (Bengali)', const Locale('bn')),
          
          const Divider(height: 32),
          
          _buildSectionHeader('App Information', theme),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0 (Phase 1.1)'),
          ),
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Build'),
            subtitle: const Text('85% Complete - Production Ready'),
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

  Widget _buildLanguageTile(BuildContext context, String title, Locale locale) {
    final isSelected = context.locale == locale;
    
    return ListTile(
      leading: Icon(
        Icons.language,
        color: isSelected ? Theme.of(context).colorScheme.primary : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
          : null,
      onTap: () async {
        await context.setLocale(locale);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language changed to $title'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
}
