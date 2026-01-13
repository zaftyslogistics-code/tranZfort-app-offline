#import "TranzfortLlmBackendBridge.h"
#include "TranzfortLlmBackend.h"

@implementation TranzfortLlmBackendBridge

+ (BOOL)loadModelWithModelPath:(NSString *)modelPath
                   contextSize:(int32_t)contextSize
                       threads:(int32_t)threads
                        useGpu:(BOOL)useGpu {
  std::string path = std::string([modelPath UTF8String]);
  return TranzfortLlmBackend::Instance().LoadModel(
      path,
      static_cast<int>(contextSize),
      static_cast<int>(threads),
      useGpu);
}

+ (void)unloadModel {
  TranzfortLlmBackend::Instance().UnloadModel();
}

+ (BOOL)isModelLoaded {
  return TranzfortLlmBackend::Instance().IsModelLoaded();
}

+ (NSString *)generateTextWithPrompt:(NSString *)prompt
                          maxTokens:(int32_t)maxTokens
                        temperature:(double)temperature
                               topP:(double)topP
                               topK:(int32_t)topK
                       stopSequence:(NSString *)stopSequence {
  std::string promptStr = std::string([prompt UTF8String]);
  std::string stopStr = std::string([stopSequence UTF8String]);
  
  std::string result = TranzfortLlmBackend::Instance().GenerateText(
      promptStr,
      static_cast<int>(maxTokens),
      temperature,
      topP,
      static_cast<int>(topK),
      stopStr);
  
  return [NSString stringWithUTF8String:result.c_str()];
}

+ (void)cancelGeneration {
  TranzfortLlmBackend::Instance().CancelGeneration();
}

@end
