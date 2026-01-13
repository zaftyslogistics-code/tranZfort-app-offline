import '../models/query_intent.dart';

abstract class AiEngine {
  List<ChatMessage> get messages;

  Future<void> processUserMessage(String userInput);

  List<String> getSuggestions();

  void clearHistory();
}

abstract class StreamingAiEngine {
  Stream<String> streamUserMessage(String userInput);
}
