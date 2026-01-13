#ifndef FLUTTER_PLUGIN_TRANZFORT_LLM_PLUGIN_H_
#define FLUTTER_PLUGIN_TRANZFORT_LLM_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace tranzfort_llm {

class TranzfortLlmPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  TranzfortLlmPlugin();

  virtual ~TranzfortLlmPlugin();

  // Disallow copy and assign.
  TranzfortLlmPlugin(const TranzfortLlmPlugin&) = delete;
  TranzfortLlmPlugin& operator=(const TranzfortLlmPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace tranzfort_llm

#endif  // FLUTTER_PLUGIN_TRANZFORT_LLM_PLUGIN_H_
