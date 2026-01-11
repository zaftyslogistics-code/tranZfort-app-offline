import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'model_file_store.dart';

class IoModelFileStore implements ModelFileStore {
  @override
  Future<String> ensureModelsRootDir() async {
    final dir = await getApplicationDocumentsDirectory();
    final modelsRoot = Directory(p.join(dir.path, 'models'));
    if (!await modelsRoot.exists()) {
      await modelsRoot.create(recursive: true);
    }
    return modelsRoot.path;
  }

  @override
  Future<String> downloadFile({
    required String url,
    required String destPath,
    required void Function(int receivedBytes, int? totalBytes) onProgress,
  }) async {
    final client = http.Client();
    try {
      final request = http.Request('GET', Uri.parse(url));
      final response = await client.send(request);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Download failed (${response.statusCode})');
      }

      final contentLength = response.contentLength;
      final totalBytes = (contentLength != null && contentLength > 0)
          ? contentLength
          : null;
      var received = 0;

      final file = File(destPath);
      await file.parent.create(recursive: true);
      final sink = file.openWrite();

      try {
        await for (final chunk in response.stream) {
          sink.add(chunk);
          received += chunk.length;
          onProgress(received, totalBytes);
        }
      } finally {
        await sink.flush();
        await sink.close();
      }

      return destPath;
    } finally {
      client.close();
    }
  }

  @override
  Future<bool> exists(String path) async {
    return File(path).exists();
  }

  @override
  Future<void> deleteIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<int> fileSize(String path) async {
    return File(path).length();
  }

  @override
  Future<String> sha256Hex(String path) async {
    final file = File(path);
    final digest = await sha256.bind(file.openRead()).first;
    return digest.toString();
  }
}

ModelFileStore createModelFileStoreImpl() => IoModelFileStore();
