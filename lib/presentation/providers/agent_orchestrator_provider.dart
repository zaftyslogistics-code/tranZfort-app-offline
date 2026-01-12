import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/agent_orchestrator.dart';
import '../../domain/services/chat_service.dart';
import '../../domain/services/nlp_service.dart';
import '../../domain/services/query_builder_service.dart';
import '../../domain/services/response_generator_service.dart';
import '../../domain/services/rule_based_ai_engine.dart';
import '../../domain/services/tool_executor.dart';
import '../../domain/services/tool_registry.dart';
import 'database_provider.dart';

final agentOrchestratorProvider = ChangeNotifierProvider<AgentOrchestrator>((ref) {
  final database = ref.read(databaseProvider);
  final nlpService = NlpService();
  final queryBuilder = QueryBuilderService(database);
  final responseGenerator = ResponseGeneratorService();

  final chatService = ChatService(
    nlpService: nlpService,
    queryBuilder: queryBuilder,
    responseGenerator: responseGenerator,
  );

  final engine = RuleBasedAiEngine(chatService: chatService);

  final toolRegistry = ToolRegistry.defaultRegistry();
  final toolExecutor = ToolExecutor(registry: toolRegistry);

  return AgentOrchestrator(engine: engine, toolExecutor: toolExecutor);
});
