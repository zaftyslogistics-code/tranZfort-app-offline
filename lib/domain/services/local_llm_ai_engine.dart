import 'dart:async';
import 'package:tranzfort_llm/tranzfort_llm.dart';
import 'package:uuid/uuid.dart';
import '../models/query_intent.dart';
import 'ai_engine.dart';

/// LocalLlmAiEngine - Uses on-device LLM via tranzfort_llm plugin
class LocalLlmAiEngine implements AiEngine, StreamingAiEngine {
  final TranzfortLlm _llm = TranzfortLlm.instance;
  final String _modelPath;
  final int _contextSize;
  final int _threads;
  bool _isLoaded = false;
  Future<bool>? _initInFlight;

  LocalLlmAiEngine({
    required String modelPath,
    int contextSize = 2048,
    int threads = 4,
  })  : _modelPath = modelPath,
        _contextSize = contextSize,
        _threads = threads;

  @override
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  final List<ChatMessage> _messages = [];

  bool get supportsToolCalling => true;

  /// Initialize the LLM (load model)
  Future<bool> initialize() async {
    if (_isLoaded) return true;

    final inFlight = _initInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    try {
      final f = _llm
          .loadModel(
            modelPath: _modelPath,
            contextSize: _contextSize,
            threads: _threads,
            useGpu: false, // Phase-2: GPU acceleration
          )
          .then((ok) {
        _isLoaded = ok;
        return ok;
      });
      _initInFlight = f;
      return await f;
    } catch (e) {
      print('LocalLlmAiEngine: Failed to load model: $e');
      return false;
    } finally {
      _initInFlight = null;
    }
  }

  /// Dispose and unload model
  Future<void> dispose() async {
    if (_isLoaded) {
      await _llm.unloadModel();
      _isLoaded = false;
    }
  }

  @override
  Future<void> processUserMessage(String userMessage) async {
    final buffer = StringBuffer();
    await for (final token in streamUserMessage(userMessage)) {
      buffer.write(token);
    }
  }

  Stream<String> generateMessageStream(String userMessage) async* {
    yield* streamUserMessage(userMessage);
  }

  @override
  Stream<String> streamUserMessage(String userMessage) async* {
    if (!_isLoaded) {
      final ok = await initialize();
      if (!ok) {
        throw StateError('Model not loaded. Please go back to Offline AI Setup and retry loading.');
      }
    }

    print('LocalLlmAiEngine: starting generation (ctx=$_contextSize threads=$_threads)');

    final now = DateTime.now();
    final userId = const Uuid().v4();

    // Add user message to history
    _messages.add(ChatMessage(
      id: userId,
      content: userMessage,
      isUser: true,
      timestamp: now,
      type: MessageType.text,
    ));

    // Build prompt from conversation history
    final prompt = _buildPrompt();

    final assistantId = const Uuid().v4();
    final assistantIndex = _messages.length;
    _messages.add(
      ChatMessage(
        id: assistantId,
        content: '',
        isUser: false,
        timestamp: now,
        type: MessageType.text,
      ),
    );

    final responseBuffer = StringBuffer();

    try {
      // Stream tokens
      await for (final token in _llm.generateTextStream(
        prompt: prompt,
        maxTokens: 128,
        temperature: 0.7,
        topP: 0.9,
        topK: 40,
      )) {
        responseBuffer.write(token);

        // Update assistant message progressively
        if (assistantIndex < _messages.length && _messages[assistantIndex].id == assistantId) {
          _messages[assistantIndex] = _messages[assistantIndex].copyWith(
            content: responseBuffer.toString(),
            timestamp: DateTime.now(),
            type: MessageType.text,
          );
        }

        yield token;
      }
    } catch (e) {
      print('LocalLlmAiEngine: Streaming generation failed: $e');

      if (assistantIndex < _messages.length && _messages[assistantIndex].id == assistantId) {
        _messages[assistantIndex] = _messages[assistantIndex].copyWith(
          content: 'Sorry, I encountered an error generating a response.',
          timestamp: DateTime.now(),
          type: MessageType.error,
        );
      }
    }
  }

  /// Build prompt from conversation history
  /// Uses Qwen2.5 chat template format
  String _buildPrompt() {
    final buffer = StringBuffer();

    // System prompt for TMS assistant
    buffer.writeln('<|im_start|>system');
    buffer.writeln('You are a helpful AI assistant for a Transport Management System (TMS). '
        'You can help users manage trips, expenses, payments, and provide business insights. '
        'When users ask you to perform actions, respond with tool calls in JSON format.');
    buffer.writeln('<|im_end|>');

    // Add conversation history
    for (final msg in _messages) {
      final role = msg.isUser ? 'user' : 'assistant';
      buffer.writeln('<|im_start|>$role');
      buffer.writeln(msg.content);
      buffer.writeln('<|im_end|>');
    }

    // Start assistant response
    buffer.write('<|im_start|>assistant\n');

    return buffer.toString();
  }

  @override
  void clearHistory() {
    _messages.clear();
  }

  @override
  List<String> getSuggestions() {
    // TODO: Implement context-aware suggestions based on conversation
    return [];
  }
}
