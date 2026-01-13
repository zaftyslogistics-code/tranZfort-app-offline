# tranzfort_llm

On-device LLM inference plugin for Tranzfort TMS using llama.cpp (MIT licensed).

## Features

- Load and run GGUF quantized models (llama.cpp format)
- Streaming and non-streaming text generation
- Cross-platform support (Android, iOS, Windows, Linux, macOS)
- GPU acceleration support (where available)
- Configurable context size, temperature, top-p, top-k sampling

## Usage

```dart
import 'package:tranzfort_llm/tranzfort_llm.dart';

final llm = TranzfortLlm.instance;

// Load model
await llm.loadModel(
  modelPath: '/path/to/model.gguf',
  contextSize: 2048,
  threads: 4,
);

// Generate text
final response = await llm.generateText(
  prompt: 'Hello, how are you?',
  maxTokens: 100,
  temperature: 0.7,
);

// Streaming generation
llm.generateTextStream(
  prompt: 'Tell me a story',
  maxTokens: 500,
).listen((token) {
  print(token);
});

// Cleanup
await llm.unloadModel();
```

## License

MIT License - Based on llama.cpp (MIT licensed)
