import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/model_manager_provider.dart';
import 'ai_chat_screen.dart';

class AiSetupScreen extends ConsumerWidget {
  const AiSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateAsync = ref.watch(modelManagerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline AI Setup'),
      ),
      body: stateAsync.when(
        data: (state) {
          final controller = ref.read(modelManagerControllerProvider.notifier);

          final status = state.status;
          final installed = state.installedModel;

          Widget content;

          if (status == ModelInstallStatus.downloading) {
            final value = state.progress > 0 ? state.progress.clamp(0.0, 1.0) : null;
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Downloading offline AI model…',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(value: value),
                const SizedBox(height: 12),
                Text(
                  value == null
                      ? 'Preparing download…'
                      : '${(value * 100).toStringAsFixed(0)}% complete',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.deleteInstalledModel,
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel / Reset'),
                  ),
                ),
              ],
            );
          } else if (status == ModelInstallStatus.installed && installed != null) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline AI model is ready',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  installed.modelName,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${(installed.bytes / (1024 * 1024)).toStringAsFixed(0)} MB',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const AiChatScreen()),
                      );
                    },
                    icon: const Icon(Icons.chat),
                    label: const Text('Continue to AI Chat'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.deleteInstalledModel,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete model'),
                  ),
                ),
              ],
            );
          } else if (status == ModelInstallStatus.error) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download failed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Unknown error',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.installBaselineFromManifest,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry download'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.deleteInstalledModel,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            );
          } else {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download offline AI model',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Text(
                  'This is required to use the AI assistant without internet. The model will be downloaded to your device storage.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.installBaselineFromManifest,
                    icon: const Icon(Icons.download),
                    label: const Text('Download model'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: controller.refreshInstalledValidity,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Check again'),
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(child: content),
          );
        },
        error: (error, stack) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline AI setup unavailable',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  error.toString(),
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.invalidate(modelManagerControllerProvider);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
