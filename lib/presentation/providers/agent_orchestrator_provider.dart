import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/agent_orchestrator.dart';
import '../../domain/services/ai_engine.dart';
import '../../domain/services/rule_based_ai_engine.dart';
import '../../domain/services/local_llm_ai_engine.dart';
import '../../domain/services/chat_service.dart';
import '../../domain/services/nlp_service.dart';
import '../../domain/services/response_generator_service.dart';
import '../../domain/services/tool_registry.dart';
import '../../domain/services/tool_executor.dart';
import '../../domain/services/query_builder_service.dart';
import 'database_provider.dart';
import 'model_manager_provider.dart';

final agentOrchestratorProvider = ChangeNotifierProvider<AgentOrchestrator>((ref) {
  final database = ref.read(databaseProvider);
  final queryBuilder = QueryBuilderService(database);
  final modelState = ref.watch(modelManagerControllerProvider);

  // Create chat service for rule-based engine
  final nlpService = NlpService();
  final responseGenerator = ResponseGeneratorService();
  final chatService = ChatService(
    nlpService: nlpService,
    queryBuilder: queryBuilder,
    responseGenerator: responseGenerator,
  );

  // Use LocalLlmAiEngine if model is installed, otherwise fallback to RuleBasedAiEngine
  final AiEngine engine = modelState.when(
    data: (status) {
      if (status.status == ModelInstallStatus.installed && status.installedModel != null) {
        // Model is installed, use LLM engine
        final modelPath = status.installedModel!.filePath;
        var contextSize = status.installedModel!.contextSize;
        if (contextSize > 1024) contextSize = 1024;
        if (contextSize < 256) contextSize = 256;
        return LocalLlmAiEngine(
          modelPath: modelPath,
          contextSize: contextSize,
          threads: 2,
        );
      } else {
        // Model not installed, use rule-based fallback
        return RuleBasedAiEngine(chatService: chatService);
      }
    },
    loading: () => RuleBasedAiEngine(chatService: chatService),
    error: (_, __) => RuleBasedAiEngine(chatService: chatService),
  );

  final toolRegistry = ToolRegistry.defaultRegistry();
  final toolExecutor = ToolExecutor(
    registry: toolRegistry,
    queryBuilder: queryBuilder,
    database: database,
  );

  return AgentOrchestrator(
    engine: engine,
    toolExecutor: toolExecutor,
  );
});
