import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
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

  int? _tryParseTotalFromContentRange(String? contentRange) {
    if (contentRange == null) return null;
    final parts = contentRange.split('/');
    if (parts.length != 2) return null;
    final totalRaw = parts[1].trim();
    final total = int.tryParse(totalRaw);
    return total;
  }

  @override
  Future<String> downloadFile({
    required String url,
    required String destPath,
    required void Function(int receivedBytes, int? totalBytes) onProgress,
    bool Function()? shouldCancel,
  }) async {
    final httpClient = HttpClient()
      ..connectionTimeout = const Duration(seconds: 30)
      ..idleTimeout = const Duration(seconds: 60);
    final client = IOClient(httpClient);

    final partPath = '$destPath.part';
    final partFile = File(partPath);
    await partFile.parent.create(recursive: true);

    try {
      const maxAttempts = 4;
      for (var attempt = 1; attempt <= maxAttempts; attempt++) {
        try {
          if (shouldCancel?.call() == true) {
            throw DownloadCancelledException();
          }

          var existingBytes = 0;
          if (await partFile.exists()) {
            existingBytes = await partFile.length();
          }

          final request = http.Request('GET', Uri.parse(url));
          if (existingBytes > 0) {
            request.headers['Range'] = 'bytes=$existingBytes-';
          }

          final response = await client.send(request).timeout(const Duration(seconds: 120));

          if (response.statusCode == 416) {
            await partFile.delete();
            existingBytes = 0;
            continue;
          }

          if (existingBytes > 0 && response.statusCode == 200) {
            await partFile.delete();
            existingBytes = 0;
          }

          if (response.statusCode != 200 && response.statusCode != 206) {
            throw Exception('Download failed (${response.statusCode})');
          }

          final totalFromRange = _tryParseTotalFromContentRange(response.headers['content-range']);
          final contentLength = response.contentLength;
          final totalBytes = totalFromRange ?? ((contentLength != null && contentLength > 0)
              ? contentLength + existingBytes
              : null);

          final sink = partFile.openWrite(
            mode: existingBytes > 0 && response.statusCode == 206
                ? FileMode.append
                : FileMode.write,
          );

          var received = existingBytes;
          onProgress(received, totalBytes);

          try {
            await for (final chunk in response.stream.timeout(const Duration(seconds: 120))) {
              if (shouldCancel?.call() == true) {
                throw DownloadCancelledException();
              }
              sink.add(chunk);
              received += chunk.length;
              onProgress(received, totalBytes);
            }
          } finally {
            await sink.flush();
            await sink.close();
          }

          if (totalBytes != null && received != totalBytes) {
            throw const HttpException('Connection closed before completing download');
          }

          final finalFile = File(destPath);
          if (await finalFile.exists()) {
            await finalFile.delete();
          }
          await partFile.rename(destPath);
          return destPath;
        } on TimeoutException catch (_) {
          if (attempt == maxAttempts) rethrow;
        } on SocketException catch (_) {
          if (attempt == maxAttempts) rethrow;
        } on HttpException catch (_) {
          if (attempt == maxAttempts) rethrow;
        } on http.ClientException catch (_) {
          if (attempt == maxAttempts) rethrow;
        }

        await Future<void>.delayed(Duration(milliseconds: 500 * (1 << (attempt - 1))));
      }

      throw Exception('Download failed');
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

    final partFile = File('$path.part');
    if (await partFile.exists()) {
      await partFile.delete();
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
