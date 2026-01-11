import 'dart:convert';

import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/installed_model.dart';
import '../models/model_pack_manifest.dart';
import 'model_file_store.dart';

class ModelManager {
  static const installedModelKey = 'installed_model_v1';

  final SharedPreferences _prefs;
  final ModelFileStore _fileStore;

  ModelManager({
    required SharedPreferences prefs,
    required ModelFileStore fileStore,
  })  : _prefs = prefs,
        _fileStore = fileStore;

  InstalledModel? getInstalledModel() {
    final jsonString = _prefs.getString(installedModelKey);
    if (jsonString == null || jsonString.isEmpty) {
      return null;
    }

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return InstalledModel.fromJson(decoded);
  }

  Future<void> clearInstalledModel() async {
    await _prefs.remove(installedModelKey);
  }

  Future<bool> isInstalledAndValid(InstalledModel model) async {
    final exists = await _fileStore.exists(model.filePath);
    if (!exists) {
      return false;
    }

    final size = await _fileStore.fileSize(model.filePath);
    if (size != model.bytes) {
      return false;
    }

    final hash = await _fileStore.sha256Hex(model.filePath);
    return hash.toLowerCase() == model.sha256.toLowerCase();
  }

  Future<InstalledModel> installFromManifestEntry({
    required ModelPackManifest manifest,
    required ModelPackEntry entry,
    required void Function(int receivedBytes, int? totalBytes) onProgress,
  }) async {
    final modelsRoot = await _fileStore.ensureModelsRootDir();

    final fileName = Uri.parse(entry.url).pathSegments.isNotEmpty
        ? Uri.parse(entry.url).pathSegments.last
        : '${entry.name}.gguf';

    final destPath = p.join(modelsRoot, manifest.id, manifest.version, fileName);

    await _fileStore.deleteIfExists(destPath);

    final downloadedPath = await _fileStore.downloadFile(
      url: entry.url,
      destPath: destPath,
      onProgress: onProgress,
    );

    final actualBytes = await _fileStore.fileSize(downloadedPath);
    if (actualBytes != entry.bytes) {
      await _fileStore.deleteIfExists(downloadedPath);
      throw Exception('Downloaded file size mismatch');
    }

    final actualSha = await _fileStore.sha256Hex(downloadedPath);
    if (actualSha.toLowerCase() != entry.sha256.toLowerCase()) {
      await _fileStore.deleteIfExists(downloadedPath);
      throw Exception('Downloaded file checksum mismatch');
    }

    final installed = InstalledModel(
      manifestId: manifest.id,
      manifestVersion: manifest.version,
      modelName: entry.name,
      filePath: downloadedPath,
      sha256: entry.sha256,
      bytes: entry.bytes,
      contextSize: entry.recommendedContextSize,
      installedAtEpochMs: DateTime.now().millisecondsSinceEpoch,
    );

    await _prefs.setString(installedModelKey, jsonEncode(installed.toJson()));
    return installed;
  }
}
