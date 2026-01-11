class InstalledModel {
  final String manifestId;
  final String manifestVersion;
  final String modelName;
  final String filePath;
  final String sha256;
  final int bytes;
  final int contextSize;
  final int installedAtEpochMs;

  const InstalledModel({
    required this.manifestId,
    required this.manifestVersion,
    required this.modelName,
    required this.filePath,
    required this.sha256,
    required this.bytes,
    required this.contextSize,
    required this.installedAtEpochMs,
  });

  factory InstalledModel.fromJson(Map<String, dynamic> json) {
    return InstalledModel(
      manifestId: json['manifestId'] as String,
      manifestVersion: json['manifestVersion'] as String,
      modelName: json['modelName'] as String,
      filePath: json['filePath'] as String,
      sha256: json['sha256'] as String,
      bytes: (json['bytes'] as num).toInt(),
      contextSize: (json['contextSize'] as num).toInt(),
      installedAtEpochMs: (json['installedAtEpochMs'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'manifestId': manifestId,
      'manifestVersion': manifestVersion,
      'modelName': modelName,
      'filePath': filePath,
      'sha256': sha256,
      'bytes': bytes,
      'contextSize': contextSize,
      'installedAtEpochMs': installedAtEpochMs,
    };
  }
}
