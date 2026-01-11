import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/model_manager_provider.dart';
import 'ai_chat_screen.dart';
import 'ai_setup_screen.dart';

class AiEntryScreen extends ConsumerWidget {
  const AiEntryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateAsync = ref.watch(modelManagerControllerProvider);

    return stateAsync.when(
      data: (state) {
        final isReady =
            state.status == ModelInstallStatus.installed && state.installedModel != null;
        return isReady ? const AiChatScreen() : const AiSetupScreen();
      },
      error: (error, stack) => const AiSetupScreen(),
      loading: () => const AiSetupScreen(),
    );
  }
}
