import 'dart:convert';

class ModelPackManifest {
  final String id;
  final String version;
  final List<ModelPackEntry> models;

  const ModelPackManifest({
    required this.id,
    required this.version,
    required this.models,
  });

  factory ModelPackManifest.fromJson(Map<String, dynamic> json) {
    return ModelPackManifest(
      id: json['id'] as String,
      version: json['version'] as String,
      models: (json['models'] as List<dynamic>)
          .map((e) => ModelPackEntry.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'version': version,
      'models': models.map((e) => e.toJson()).toList(growable: false),
    };
  }

  static ModelPackManifest parse(String jsonString) {
    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    return ModelPackManifest.fromJson(decoded);
  }
}

class ModelPackEntry {
  final String name;
  final String url;
  final String sha256;
  final int bytes;
  final int recommendedContextSize;
  final GenerationDefaults defaultGenerationParams;

  const ModelPackEntry({
    required this.name,
    required this.url,
    required this.sha256,
    required this.bytes,
    required this.recommendedContextSize,
    required this.defaultGenerationParams,
  });

  factory ModelPackEntry.fromJson(Map<String, dynamic> json) {
    return ModelPackEntry(
      name: json['name'] as String,
      url: json['url'] as String,
      sha256: json['sha256'] as String,
      bytes: (json['bytes'] as num).toInt(),
      recommendedContextSize: (json['recommendedContextSize'] as num).toInt(),
      defaultGenerationParams: GenerationDefaults.fromJson(
        json['defaultGenerationParams'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'sha256': sha256,
      'bytes': bytes,
      'recommendedContextSize': recommendedContextSize,
      'defaultGenerationParams': defaultGenerationParams.toJson(),
    };
  }
}

class GenerationDefaults {
  final double temperature;
  final double topP;
  final int topK;
  final int maxTokens;
  final double repeatPenalty;
  final List<String> stopSequences;

  const GenerationDefaults({
    required this.temperature,
    required this.topP,
    required this.topK,
    required this.maxTokens,
    required this.repeatPenalty,
    required this.stopSequences,
  });

  factory GenerationDefaults.fromJson(Map<String, dynamic> json) {
    return GenerationDefaults(
      temperature: (json['temperature'] as num).toDouble(),
      topP: (json['topP'] as num).toDouble(),
      topK: (json['topK'] as num).toInt(),
      maxTokens: (json['maxTokens'] as num).toInt(),
      repeatPenalty: (json['repeatPenalty'] as num).toDouble(),
      stopSequences: ((json['stopSequences'] as List<dynamic>?) ?? const [])
          .map((e) => e.toString())
          .toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'topP': topP,
      'topK': topK,
      'maxTokens': maxTokens,
      'repeatPenalty': repeatPenalty,
      'stopSequences': stopSequences,
    };
  }
}
