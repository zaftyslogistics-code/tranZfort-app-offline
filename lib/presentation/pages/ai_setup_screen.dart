import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/model_pack_manifest.dart';
import '../providers/model_manifest_provider.dart';
import '../providers/model_manager_provider.dart';
import 'ai_chat_screen.dart';

class AiSetupScreen extends ConsumerWidget {
  const AiSetupScreen({super.key});

  String _formatMb(int bytes) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
  }

  Future<ModelPackEntry?> _promptModelChoice(
    BuildContext context, {
    required List<ModelPackEntry> models,
  }) async {
    return showDialog<ModelPackEntry>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Choose offline AI model'),
          children: models
              .map(
                (m) => SimpleDialogOption(
                  onPressed: () {
                    Navigator.of(ctx).pop(m);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.name),
                      const SizedBox(height: 4),
                      Text(
                        _formatMb(m.bytes),
                        style: Theme.of(ctx).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stateAsync = ref.watch(modelManagerControllerProvider);
    final manifestAsync = ref.watch(modelManifestProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline AI Setup'),
      ),
      body: stateAsync.when(
        data: (state) {
          final controller = ref.read(modelManagerControllerProvider.notifier);

          final status = state.status;
          final installed = state.installedModel;
          final selected = state.selectedEntry;

          Future<void> startDownload() async {
            final manifest = await ref.read(modelManifestProvider.future);
            if (manifest.models.isEmpty) {
              throw Exception('No models found in manifest');
            }

            if (manifest.models.length == 1) {
              await controller.installFromManifestEntry(
                manifest: manifest,
                entry: manifest.models.first,
              );
              return;
            }

            final chosen = await _promptModelChoice(context, models: manifest.models);
            if (chosen == null) return;
            await controller.installFromManifestEntry(manifest: manifest, entry: chosen);
          }

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
                if (selected != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    selected.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMb(selected.bytes),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
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
                    onPressed: () async {
                      controller.cancelDownload();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pausing download…')),
                      );
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel (pause)'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await controller.deleteInstalledModel();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset complete')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            );
          } else if (status == ModelInstallStatus.paused) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download paused',
                  style: theme.textTheme.titleMedium,
                ),
                if (selected != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    selected.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMb(selected.bytes),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.resumeDownload,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Resume download'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await controller.deleteInstalledModel();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reset complete')),
                        );
                      }
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Reset'),
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
                  _formatMb(installed.bytes),
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
            final resumeLikely = (state.progress > 0) || selected != null;
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Download failed',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
                if (selected != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    selected.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatMb(selected.bytes),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'Unknown error',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: controller.retryInstall,
                    icon: const Icon(Icons.refresh),
                    label: Text(resumeLikely ? 'Retry / Resume download' : 'Retry download'),
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
                const SizedBox(height: 12),
                manifestAsync.when(
                  data: (manifest) {
                    if (manifest.models.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    if (manifest.models.length == 1) {
                      final m = manifest.models.first;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.name, style: theme.textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text(_formatMb(m.bytes), style: theme.textTheme.bodySmall),
                        ],
                      );
                    }

                    return Text(
                      'Multiple models available. You can choose one during download.',
                      style: theme.textTheme.bodySmall,
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      try {
                        await startDownload();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
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
