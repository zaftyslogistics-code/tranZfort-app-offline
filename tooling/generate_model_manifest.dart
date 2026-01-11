import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

Future<void> main(List<String> args) async {
  if (args.length < 3) {
    stderr.writeln(
      'Usage: dart run tooling/generate_model_manifest.dart <ggufPath> <version> <outPath> [--id=<id>] [--context=<tokens>]',
    );
    exitCode = 2;
    return;
  }

  final ggufPath = args[0];
  final version = args[1];
  final outPath = args[2];

  var manifestId = 'tranzfort-offline-llm';
  var contextSize = 2048;

  for (final arg in args.skip(3)) {
    if (arg.startsWith('--id=')) {
      manifestId = arg.substring('--id='.length);
    } else if (arg.startsWith('--context=')) {
      contextSize = int.parse(arg.substring('--context='.length));
    }
  }

  final file = File(ggufPath);
  if (!await file.exists()) {
    stderr.writeln('GGUF not found: $ggufPath');
    exitCode = 2;
    return;
  }

  final bytes = await file.length();
  final digest = await sha256.bind(file.openRead()).first;
  final shaHex = digest.toString();

  final fileName = file.uri.pathSegments.isNotEmpty
      ? file.uri.pathSegments.last
      : 'model.gguf';

  final modelUrl =
      'https://github.com/zaftyslogistics-code/tranZfort-app-offline/releases/latest/download/$fileName';

  final manifest = {
    'id': manifestId,
    'version': version,
    'models': [
      {
        'name': 'qwen2.5-1.5b-instruct-q4_k_m',
        'url': modelUrl,
        'sha256': shaHex,
        'bytes': bytes,
        'recommendedContextSize': contextSize,
        'defaultGenerationParams': {
          'temperature': 0.7,
          'topP': 0.9,
          'topK': 40,
          'maxTokens': 512,
          'repeatPenalty': 1.1,
          'stopSequences': <String>[],
        },
      }
    ],
  };

  final outFile = File(outPath);
  await outFile.parent.create(recursive: true);
  await outFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(manifest),
  );

  stdout.writeln('Wrote manifest: $outPath');
  stdout.writeln('Model: $fileName');
  stdout.writeln('Bytes: $bytes');
  stdout.writeln('SHA256: $shaHex');
}
