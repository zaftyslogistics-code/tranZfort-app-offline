class LlmModelConfig {
  final String modelPath;
  final int contextSize;
  final int threads;
  final bool useGpu;

  const LlmModelConfig({
    required this.modelPath,
    this.contextSize = 2048,
    this.threads = 4,
    this.useGpu = false,
  });

  Map<String, dynamic> toJson() => {
        'modelPath': modelPath,
        'contextSize': contextSize,
        'threads': threads,
        'useGpu': useGpu,
      };
}
