import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/installed_model.dart';
import '../../domain/models/model_pack_manifest.dart';
import '../../domain/services/model_file_store.dart';
import '../../domain/services/model_manager.dart';
import 'model_manifest_provider.dart';

enum ModelInstallStatus {
  idle,
  downloading,
  verifying,
  installed,
  error,
}

class ModelManagerState {
  final ModelInstallStatus status;
  final double progress;
  final String? errorMessage;
  final InstalledModel? installedModel;

  const ModelManagerState({
    required this.status,
    required this.progress,
    required this.errorMessage,
    required this.installedModel,
  });

  factory ModelManagerState.initial() {
    return const ModelManagerState(
      status: ModelInstallStatus.idle,
      progress: 0,
      errorMessage: null,
      installedModel: null,
    );
  }

  ModelManagerState copyWith({
    ModelInstallStatus? status,
    double? progress,
    String? errorMessage,
    InstalledModel? installedModel,
  }) {
    return ModelManagerState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      installedModel: installedModel ?? this.installedModel,
    );
  }
}

class ModelManagerController extends AsyncNotifier<ModelManagerState> {
  static const baselineFileName = 'qwen2.5-1.5b-instruct-q4_k_m.gguf';

  late final ModelManager _manager;

  @override
  Future<ModelManagerState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final fileStore = ref.read(modelFileStoreProvider);
    _manager = ModelManager(prefs: prefs, fileStore: fileStore);

    final installed = _manager.getInstalledModel();
    if (installed == null) {
      return ModelManagerState.initial();
    }

    final ok = await _manager.isInstalledAndValid(installed);
    if (!ok) {
      await _manager.clearInstalledModel();
      return ModelManagerState.initial();
    }

    return ModelManagerState.initial().copyWith(
      status: ModelInstallStatus.installed,
      installedModel: installed,
    );
  }

  Future<void> refreshInstalledValidity() async {
    final current = state.value ?? ModelManagerState.initial();
    final installed = _manager.getInstalledModel();
    if (installed == null) {
      state = AsyncData(ModelManagerState.initial());
      return;
    }

    state = AsyncData(current.copyWith(status: ModelInstallStatus.verifying, errorMessage: null));

    final ok = await _manager.isInstalledAndValid(installed);
    if (!ok) {
      await deleteInstalledModel();
      return;
    }

    state = AsyncData(
      current.copyWith(status: ModelInstallStatus.installed, installedModel: installed, progress: 1.0),
    );
  }

  Future<void> installBaselineFromManifest() async {
    final current = state.value ?? ModelManagerState.initial();
    state = AsyncData(current.copyWith(status: ModelInstallStatus.downloading, progress: 0, errorMessage: null));

    try {
      final manifest = await ref.read(modelManifestProvider.future);

      final entry = manifest.models.firstWhere(
        (m) => Uri.parse(m.url).pathSegments.isNotEmpty &&
            Uri.parse(m.url).pathSegments.last == baselineFileName,
      );

      final installed = await _manager.installFromManifestEntry(
        manifest: manifest,
        entry: entry,
        onProgress: (received, total) {
          final p = total == null || total == 0 ? 0.0 : (received / total);
          final latest = state.value ?? current;
          state = AsyncData(latest.copyWith(status: ModelInstallStatus.downloading, progress: p));
        },
      );

      state = AsyncData(
        current.copyWith(
          status: ModelInstallStatus.installed,
          progress: 1.0,
          installedModel: installed,
          errorMessage: null,
        ),
      );
    } catch (e) {
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(status: ModelInstallStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> deleteInstalledModel() async {
    final current = state.value ?? ModelManagerState.initial();
    final installed = _manager.getInstalledModel();

    if (installed != null) {
      await ref.read(modelFileStoreProvider).deleteIfExists(installed.filePath);
    }

    await _manager.clearInstalledModel();
    state = AsyncData(current.copyWith(status: ModelInstallStatus.idle, installedModel: null, progress: 0, errorMessage: null));
  }
}

final modelFileStoreProvider = Provider<ModelFileStore>((ref) {
  return createModelFileStore();
});

final modelManagerControllerProvider =
    AsyncNotifierProvider<ModelManagerController, ModelManagerState>(
  ModelManagerController.new,
);
