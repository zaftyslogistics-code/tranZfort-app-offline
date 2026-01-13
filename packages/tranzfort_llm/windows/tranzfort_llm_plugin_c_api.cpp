#include "include/tranzfort_llm/tranzfort_llm_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "tranzfort_llm_plugin.h"

void TranzfortLlmPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  tranzfort_llm::TranzfortLlmPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
