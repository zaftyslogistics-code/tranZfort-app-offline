import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/model_pack_manifest.dart';
import '../../domain/services/model_manifest_service.dart';

const defaultModelManifestUrl =
    'https://github.com/zaftyslogistics-code/tranZfort-app-offline/releases/latest/download/manifest.json';

final modelManifestServiceProvider = Provider<ModelManifestService>((ref) {
  return const ModelManifestService(manifestUrl: defaultModelManifestUrl);
});

final modelManifestProvider = FutureProvider<ModelPackManifest>((ref) async {
  final service = ref.watch(modelManifestServiceProvider);
  return service.fetchManifest();
});
