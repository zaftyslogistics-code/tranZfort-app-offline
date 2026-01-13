import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

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
  paused,
  error,
}

class ModelManagerState {
  final ModelInstallStatus status;
  final double progress;
  final String? errorMessage;
  final InstalledModel? installedModel;
  final ModelPackEntry? selectedEntry;

  const ModelManagerState({
    required this.status,
    required this.progress,
    required this.errorMessage,
    required this.installedModel,
    required this.selectedEntry,
  });

  factory ModelManagerState.initial() {
    return const ModelManagerState(
      status: ModelInstallStatus.idle,
      progress: 0,
      errorMessage: null,
      installedModel: null,
      selectedEntry: null,
    );
  }

  ModelManagerState copyWith({
    ModelInstallStatus? status,
    double? progress,
    String? errorMessage,
    InstalledModel? installedModel,
    ModelPackEntry? selectedEntry,
  }) {
    return ModelManagerState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage,
      installedModel: installedModel ?? this.installedModel,
      selectedEntry: selectedEntry ?? this.selectedEntry,
    );
  }
}

class ModelManagerController extends AsyncNotifier<ModelManagerState> {
  static const baselineFileName = 'qwen2.5-1.5b-instruct-q4_k_m.gguf';

  late final ModelManager _manager;

  bool _cancelRequested = false;
  Future<void>? _activeInstall;

  @override
  Future<ModelManagerState> build() async {
    final prefs = await SharedPreferences.getInstance();
    final fileStore = ref.read(modelFileStoreProvider);
    _manager = ModelManager(prefs: prefs, fileStore: fileStore);

    final installed = _manager.getInstalledModel();
    if (installed == null) {
      return ModelManagerState.initial();
    }

    // Avoid blocking the UI on app start: full SHA-256 over a ~GB GGUF can take minutes.
    // We do a fast check here (exists + file size). Full verification can be done via "Check again".
    final ok = await _manager.isInstalledAndValid(installed, verifySha: false);
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

    final ok = await _manager.isInstalledAndValid(installed, verifySha: true);
    if (!ok) {
      await deleteInstalledModel();
      return;
    }

    state = AsyncData(
      current.copyWith(status: ModelInstallStatus.installed, installedModel: installed, progress: 1.0),
    );
  }

  Future<void> installBaselineFromManifest() async {
    try {
      final manifest = await ref.read(modelManifestProvider.future);

      final entry = manifest.models.firstWhere(
        (m) => Uri.parse(m.url).pathSegments.isNotEmpty &&
            Uri.parse(m.url).pathSegments.last == baselineFileName,
      );

      await installFromManifestEntry(manifest: manifest, entry: entry);
    } catch (e) {
      final current = state.value ?? ModelManagerState.initial();
      final msg = e.toString();
      final idx = msg.indexOf(', uri=');
      state = AsyncData(
        current.copyWith(
          status: ModelInstallStatus.error,
          errorMessage: idx == -1 ? msg : msg.substring(0, idx),
        ),
      );
    }
  }

  Future<void> retryInstall() async {
    final current = state.value ?? ModelManagerState.initial();
    final existingSelection = current.selectedEntry;

    if (existingSelection == null) {
      await installBaselineFromManifest();
      return;
    }

    try {
      final manifest = await ref.read(modelManifestProvider.future);
      final match = manifest.models.firstWhere(
        (m) => m.url == existingSelection.url,
        orElse: () => existingSelection,
      );
      await installFromManifestEntry(manifest: manifest, entry: match);
    } catch (e) {
      final msg = e.toString();
      final idx = msg.indexOf(', uri=');
      state = AsyncData(
        current.copyWith(
          status: ModelInstallStatus.error,
          errorMessage: idx == -1 ? msg : msg.substring(0, idx),
          selectedEntry: existingSelection,
        ),
      );
    }
  }

  Future<void> installFromManifestEntry({
    required ModelPackManifest manifest,
    required ModelPackEntry entry,
  }) async {
    final current = state.value ?? ModelManagerState.initial();

    if (_activeInstall != null) {
      return;
    }

    _cancelRequested = false;
    state = AsyncData(
      current.copyWith(
        status: ModelInstallStatus.downloading,
        progress: 0,
        errorMessage: null,
        selectedEntry: entry,
      ),
    );

    await WakelockPlus.enable();

    Future<void> runInstall() async {
      final installed = await _manager.installFromManifestEntry(
        manifest: manifest,
        entry: entry,
        shouldCancel: () => _cancelRequested,
        onProgress: (received, total) {
          final p = total == null || total == 0 ? 0.0 : (received / total);
          final latest = state.value ?? current;
          state = AsyncData(
            latest.copyWith(
              status: ModelInstallStatus.downloading,
              progress: p,
              selectedEntry: entry,
            ),
          );
        },
      );

      state = AsyncData(
        current.copyWith(
          status: ModelInstallStatus.installed,
          progress: 1.0,
          installedModel: installed,
          errorMessage: null,
          selectedEntry: entry,
        ),
      );
    }

    _activeInstall = runInstall();
    try {
      await _activeInstall;
    } on DownloadCancelledException {
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          status: ModelInstallStatus.paused,
          errorMessage: null,
          selectedEntry: entry,
        ),
      );
    } catch (e) {
      final msg = e.toString();
      final idx = msg.indexOf(', uri=');
      final latest = state.value ?? current;
      state = AsyncData(
        latest.copyWith(
          status: ModelInstallStatus.error,
          errorMessage: idx == -1 ? msg : msg.substring(0, idx),
          selectedEntry: entry,
        ),
      );
    } finally {
      _activeInstall = null;
      await WakelockPlus.disable();
    }
  }

  Future<void> cancelDownload() async {
    _cancelRequested = true;
  }

  Future<void> resumeDownload() async {
    await retryInstall();
  }

  Future<void> deleteInstalledModel() async {
    final current = state.value ?? ModelManagerState.initial();
    _cancelRequested = true;
    try {
      await _activeInstall;
    } catch (_) {
      // ignore
    }
    final installed = _manager.getInstalledModel();

    if (installed != null) {
      await ref.read(modelFileStoreProvider).deleteIfExists(installed.filePath);
    } else {
      final entry = current.selectedEntry;
      if (entry != null) {
        try {
          final manifest = await ref.read(modelManifestProvider.future);
          final modelsRoot = await ref.read(modelFileStoreProvider).ensureModelsRootDir();

          final fileName = Uri.parse(entry.url).pathSegments.isNotEmpty
              ? Uri.parse(entry.url).pathSegments.last
              : '${entry.name}.gguf';
          final destPath = p.join(modelsRoot, manifest.id, manifest.version, fileName);
          await ref.read(modelFileStoreProvider).deleteIfExists(destPath);
        } catch (_) {
          // best-effort cleanup
        }
      }
    }

    await _manager.clearInstalledModel();
    state = AsyncData(
      current.copyWith(
        status: ModelInstallStatus.idle,
        installedModel: null,
        progress: 0,
        errorMessage: null,
        selectedEntry: null,
      ),
    );
  }
}

final modelFileStoreProvider = Provider<ModelFileStore>((ref) {
  return createModelFileStore();
});

final modelManagerControllerProvider =
    AsyncNotifierProvider<ModelManagerController, ModelManagerState>(
  ModelManagerController.new,
);

final selectedModelEntryProvider = StateProvider<ModelPackEntry?>((ref) {
  return null;
});
