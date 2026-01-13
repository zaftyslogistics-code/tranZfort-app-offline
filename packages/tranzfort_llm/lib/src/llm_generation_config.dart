class LlmGenerationConfig {
  final int maxTokens;
  final double temperature;
  final double topP;
  final int topK;
  final String? stopSequence;

  const LlmGenerationConfig({
    this.maxTokens = 512,
    this.temperature = 0.7,
    this.topP = 0.9,
    this.topK = 40,
    this.stopSequence,
  });

  Map<String, dynamic> toJson() => {
        'maxTokens': maxTokens,
        'temperature': temperature,
        'topP': topP,
        'topK': topK,
        'stopSequence': stopSequence,
      };
}
