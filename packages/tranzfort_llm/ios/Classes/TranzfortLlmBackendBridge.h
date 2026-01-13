#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TranzfortLlmBackendBridge : NSObject

+ (BOOL)loadModelWithModelPath:(NSString *)modelPath
                   contextSize:(int32_t)contextSize
                       threads:(int32_t)threads
                        useGpu:(BOOL)useGpu;

+ (void)unloadModel;

+ (BOOL)isModelLoaded;

+ (NSString *)generateTextWithPrompt:(NSString *)prompt
                          maxTokens:(int32_t)maxTokens
                        temperature:(double)temperature
                               topP:(double)topP
                               topK:(int32_t)topK
                       stopSequence:(NSString *)stopSequence;

+ (void)cancelGeneration;

@end

NS_ASSUME_NONNULL_END
