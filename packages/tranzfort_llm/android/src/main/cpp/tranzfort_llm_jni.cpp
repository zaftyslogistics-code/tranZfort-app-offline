#include <jni.h>
#include <android/log.h>

#include <string>

#include "tranzfort_llm_backend.h"

#define LOG_TAG "tranzfort_llm_native"
#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, LOG_TAG, __VA_ARGS__)
#define LOGE(...) __android_log_print(ANDROID_LOG_ERROR, LOG_TAG, __VA_ARGS__)

extern "C" JNIEXPORT jboolean JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeLoadModel(
    JNIEnv* env,
    jobject /*thiz*/,
    jstring modelPath,
    jint contextSize,
    jint threads,
    jboolean useGpu) {
  const char* path = env->GetStringUTFChars(modelPath, nullptr);
  const bool ok = TranzfortLlmBackend::Instance().LoadModel(
      std::string(path),
      static_cast<int>(contextSize),
      static_cast<int>(threads),
      useGpu == JNI_TRUE);
  LOGI("nativeLoadModel called. path=%s", path);
  env->ReleaseStringUTFChars(modelPath, path);
  return ok ? JNI_TRUE : JNI_FALSE;
}

extern "C" JNIEXPORT void JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeUnloadModel(
    JNIEnv* /*env*/,
    jobject /*thiz*/) {
  TranzfortLlmBackend::Instance().UnloadModel();
  LOGI("nativeUnloadModel called");
}

extern "C" JNIEXPORT jboolean JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeIsModelLoaded(
    JNIEnv* /*env*/,
    jobject /*thiz*/) {
  return TranzfortLlmBackend::Instance().IsModelLoaded() ? JNI_TRUE : JNI_FALSE;
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeGenerateText(
    JNIEnv* env,
    jobject /*thiz*/,
    jstring prompt,
    jint maxTokens,
    jdouble temperature,
    jdouble topP,
    jint topK,
    jstring stopSequence) {
  const char* p = env->GetStringUTFChars(prompt, nullptr);

  std::string stop;
  if (stopSequence != nullptr) {
    const char* s = env->GetStringUTFChars(stopSequence, nullptr);
    stop = std::string(s);
    env->ReleaseStringUTFChars(stopSequence, s);
  }

  const std::string out = TranzfortLlmBackend::Instance().GenerateText(
      std::string(p),
      static_cast<int>(maxTokens),
      static_cast<double>(temperature),
      static_cast<double>(topP),
      static_cast<int>(topK),
      stop);

  LOGI("nativeGenerateText called. prompt_len=%zu", out.size());
  env->ReleaseStringUTFChars(prompt, p);
  return env->NewStringUTF(out.c_str());
}

extern "C" JNIEXPORT jstring JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeGenerateTextStreaming(
    JNIEnv* env,
    jobject thiz,
    jstring prompt,
    jint maxTokens,
    jdouble temperature,
    jdouble topP,
    jint topK,
    jstring stopSequence) {
  
  // Get Java class and method for callback
  jclass clazz = env->GetObjectClass(thiz);
  jmethodID callbackMethod = env->GetMethodID(clazz, "onTokenGenerated", "(Ljava/lang/String;)V");
  
  if (callbackMethod == nullptr) {
    LOGE("Failed to find onTokenGenerated method");
    return env->NewStringUTF("");
  }
  
  const char* p = env->GetStringUTFChars(prompt, nullptr);
  std::string stop;
  if (stopSequence != nullptr) {
    const char* s = env->GetStringUTFChars(stopSequence, nullptr);
    stop = std::string(s);
    env->ReleaseStringUTFChars(stopSequence, s);
  }

  // Create global reference to jobject for callback
  jobject globalThiz = env->NewGlobalRef(thiz);
  
  // Set up token callback
  auto tokenCallback = [env, globalThiz, callbackMethod](const std::string& token) {
    jstring jtoken = env->NewStringUTF(token.c_str());
    env->CallVoidMethod(globalThiz, callbackMethod, jtoken);
    env->DeleteLocalRef(jtoken);
  };
  
  // Generate with streaming
  const std::string out = TranzfortLlmBackend::Instance().GenerateTextWithCallback(
      std::string(p),
      static_cast<int>(maxTokens),
      static_cast<double>(temperature),
      static_cast<double>(topP),
      static_cast<int>(topK),
      stop,
      tokenCallback);

  env->DeleteGlobalRef(globalThiz);
  env->ReleaseStringUTFChars(prompt, p);
  
  LOGI("nativeGenerateTextStreaming completed. output_len=%zu", out.size());
  return env->NewStringUTF(out.c_str());
}

extern "C" JNIEXPORT void JNICALL
Java_com_zaftyslogistics_tranzfort_tranzfort_1llm_TranzfortLlmPlugin_nativeCancelGeneration(
    JNIEnv* /*env*/,
    jobject /*thiz*/) {
  TranzfortLlmBackend::Instance().CancelGeneration();
  LOGI("nativeCancelGeneration called");
}
