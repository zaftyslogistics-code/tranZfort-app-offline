import 'package:http/http.dart' as http;

import '../models/model_pack_manifest.dart';

class ModelManifestService {
  final String manifestUrl;

  const ModelManifestService({required this.manifestUrl});

  Future<ModelPackManifest> fetchManifest() async {
    final response = await http.get(Uri.parse(manifestUrl));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to fetch model manifest (${response.statusCode})');
    }

    return ModelPackManifest.parse(response.body);
  }
}
