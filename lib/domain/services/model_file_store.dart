import 'model_file_store_stub.dart'
    if (dart.library.io) 'model_file_store_io.dart';

class DownloadCancelledException implements Exception {
  @override
  String toString() => 'Download cancelled';
}

abstract class ModelFileStore {
  Future<String> ensureModelsRootDir();
  Future<String> downloadFile({
    required String url,
    required String destPath,
    required void Function(int receivedBytes, int? totalBytes) onProgress,
    bool Function()? shouldCancel,
  });

  Future<bool> exists(String path);
  Future<void> deleteIfExists(String path);
  Future<int> fileSize(String path);
  Future<String> sha256Hex(String path);
}

ModelFileStore createModelFileStore() => createModelFileStoreImpl();
