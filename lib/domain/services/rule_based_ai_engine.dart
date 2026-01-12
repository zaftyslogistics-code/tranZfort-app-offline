import '../models/query_intent.dart';
import 'ai_engine.dart';
import 'chat_service.dart';

class RuleBasedAiEngine implements AiEngine {
  final ChatService _chatService;

  RuleBasedAiEngine({
    required ChatService chatService,
  }) : _chatService = chatService;

  @override
  List<ChatMessage> get messages => _chatService.messages;

  @override
  Future<void> processUserMessage(String userInput) async {
    await _chatService.processMessage(userInput);
  }

  @override
  List<String> getSuggestions() => _chatService.getSuggestions();

  @override
  void clearHistory() {
    _chatService.clearHistory();
  }
}
