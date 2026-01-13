import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/model_manager_provider.dart';
import 'ai_setup_screen.dart';
import 'ai_entry_screen.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/ui_components.dart';

/// Settings Screen with Language Selector
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AiEntryScreen(),
                ),
              );
            },
            tooltip: 'AI Assistant',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spaceLg),
        children: [
          const AppSectionHeader(title: 'Language Settings'),
          _buildLanguageTile(context, 'English', const Locale('en')),
          _buildLanguageTile(context, 'हिंदी (Hindi)', const Locale('hi')),
          _buildLanguageTile(context, 'ਪੰਜਾਬੀ (Punjabi)', const Locale('pa')),
          _buildLanguageTile(context, 'தமிழ் (Tamil)', const Locale('ta')),
          _buildLanguageTile(context, 'తెలుగు (Telugu)', const Locale('te')),
          _buildLanguageTile(context, 'मराठी (Marathi)', const Locale('mr')),
          _buildLanguageTile(context, 'ગુજરાતી (Gujarati)', const Locale('gu')),
          _buildLanguageTile(context, 'বাংলা (Bengali)', const Locale('bn')),
          
          const SizedBox(height: AppTheme.spaceXl),

          const AppSectionHeader(title: 'AI Model'),
          _buildAiModelSection(context, ref),
          
          const SizedBox(height: AppTheme.spaceXl),
          
          const AppSectionHeader(title: 'App Information'),
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

  Widget _buildAiModelSection(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateAsync = ref.watch(modelManagerControllerProvider);

    return stateAsync.when(
      loading: () {
        return ListTile(
          leading: const Icon(Icons.smart_toy_outlined),
          title: const Text('Offline AI model'),
          subtitle: const Text('Loading model status…'),
          trailing: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      error: (error, stack) {
        return Column(
          children: [
            ListTile(
              leading: Icon(Icons.smart_toy_outlined, color: theme.colorScheme.error),
              title: const Text('Offline AI model'),
              subtitle: Text(error.toString()),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  ref.invalidate(modelManagerControllerProvider);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AiSetupScreen()),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  label: const Text('Open AI Setup'),
                ),
              ),
            ),
          ],
        );
      },
      data: (state) {
        final controller = ref.read(modelManagerControllerProvider.notifier);
        final installed = state.installedModel;

        if (state.status == ModelInstallStatus.downloading) {
          final value = state.progress > 0 ? state.progress.clamp(0.0, 1.0) : null;
          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.download),
                title: const Text('Downloading offline AI model…'),
                subtitle: Text(
                  value == null
                      ? 'Preparing download…'
                      : '${(value * 100).toStringAsFixed(0)}% complete',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LinearProgressIndicator(value: value),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.deleteInstalledModel,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel / Reset'),
                  ),
                ),
              ),
            ],
          );
        }

        if (state.status == ModelInstallStatus.verifying) {
          return const ListTile(
            leading: Icon(Icons.verified_outlined),
            title: Text('Verifying offline AI model…'),
            trailing: SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }

        if (state.status == ModelInstallStatus.error) {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.error_outline, color: theme.colorScheme.error),
                title: const Text('Offline AI model'),
                subtitle: Text(state.errorMessage ?? 'Download failed'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.installBaselineFromManifest,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.deleteInstalledModel,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Reset'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AiSetupScreen()),
                      );
                    },
                    icon: const Icon(Icons.settings),
                    label: const Text('Open AI Setup'),
                  ),
                ),
              ),
            ],
          );
        }

        if (state.status == ModelInstallStatus.installed && installed != null) {
          final sizeMb = installed.bytes / (1024 * 1024);

          return Column(
            children: [
              ListTile(
                leading: const Icon(Icons.smart_toy_outlined),
                title: const Text('Offline AI model'),
                subtitle: Text('${installed.modelName} • ${sizeMb.toStringAsFixed(0)} MB'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AiSetupScreen()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.refreshInstalledValidity,
                        icon: const Icon(Icons.verified_outlined),
                        label: const Text('Verify'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.deleteInstalledModel,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await controller.deleteInstalledModel();
                      await controller.installBaselineFromManifest();
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('Redownload model'),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            const ListTile(
              leading: Icon(Icons.smart_toy_outlined),
              title: Text('Offline AI model'),
              subtitle: Text('Download required to use AI without internet.'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: controller.installBaselineFromManifest,
                      icon: const Icon(Icons.download),
                      label: const Text('Download'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AiSetupScreen()),
                        );
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Manage'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
