package com.zaftyslogistics.tranzfort.tranzfort_llm

import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

/** TranzfortLlmPlugin */
class TranzfortLlmPlugin :
    FlutterPlugin,
    MethodCallHandler,
    EventChannel.StreamHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private val mainHandler = Handler(Looper.getMainLooper())
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    private val tag = "TranzfortLlmPlugin"

    companion object {
        private var nativeLoaded: Boolean = false

        init {
            try {
                System.loadLibrary("tranzfort_llm_native")
                nativeLoaded = true
            } catch (t: Throwable) {
                nativeLoaded = false
            }
        }
    }

    private external fun nativeLoadModel(modelPath: String, contextSize: Int, threads: Int, useGpu: Boolean): Boolean
    private external fun nativeUnloadModel()
    private external fun nativeIsModelLoaded(): Boolean
    private external fun nativeGenerateText(
        prompt: String,
        maxTokens: Int,
        temperature: Double,
        topP: Double,
        topK: Int,
        stopSequence: String?
    ): String
    private external fun nativeGenerateTextStreaming(
        prompt: String,
        maxTokens: Int,
        temperature: Double,
        topP: Double,
        topK: Int,
        stopSequence: String?
    ): String
    private external fun nativeCancelGeneration()

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tranzfort_llm")
        channel.setMethodCallHandler(this)
        
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "tranzfort_llm/stream")
        eventChannel.setStreamHandler(this)
    }
    
    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
        Log.i(tag, "EventChannel listener attached")
    }
    
    override fun onCancel(arguments: Any?) {
        eventSink = null
        Log.i(tag, "EventChannel listener cancelled")
    }
    
    private fun sendToken(token: String) {
        mainHandler.post {
            eventSink?.success(token)
        }
    }
    
    private fun sendError(error: String) {
        mainHandler.post {
            eventSink?.error("GENERATION_ERROR", error, null)
        }
    }
    
    private fun sendDone() {
        mainHandler.post {
            eventSink?.endOfStream()
        }
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        Log.i(tag, "onMethodCall: ${call.method}")
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")

            "loadModel",
            "unloadModel",
            "isModelLoaded",
            "generateText",
            "startStreamingGeneration",
            "cancelGeneration" -> {
                if (!nativeLoaded) {
                    result.error("NATIVE_UNAVAILABLE", "Native library not loaded", null)
                    return
                }

                when (call.method) {
                    "loadModel" -> {
                        val modelPath = call.argument<String>("modelPath")
                        val contextSize = call.argument<Int>("contextSize") ?: 2048
                        val threads = call.argument<Int>("threads") ?: 4
                        val useGpu = call.argument<Boolean>("useGpu") ?: false

                        if (modelPath.isNullOrBlank()) {
                            result.error("INVALID_ARGS", "modelPath is required", null)
                            return
                        }

                        executor.execute {
                            try {
                                Log.i(tag, "loadModel: start ctx=$contextSize threads=$threads useGpu=$useGpu")
                                val ok = nativeLoadModel(modelPath, contextSize, threads, useGpu)
                                Log.i(tag, "loadModel: done ok=$ok")
                                mainHandler.post { result.success(ok) }
                            } catch (t: Throwable) {
                                Log.e(tag, "loadModel: failed", t)
                                mainHandler.post {
                                    result.error("NATIVE_ERROR", "nativeLoadModel failed: ${t.message}", null)
                                }
                            }
                        }
                    }

                    "unloadModel" -> {
                        nativeUnloadModel()
                        result.success(null)
                    }

                    "isModelLoaded" -> {
                        result.success(nativeIsModelLoaded())
                    }

                    "generateText" -> {
                        val prompt = call.argument<String>("prompt")
                        val maxTokens = call.argument<Int>("maxTokens") ?: 256
                        val temperature = call.argument<Double>("temperature") ?: 0.7
                        val topP = call.argument<Double>("topP") ?: 0.9
                        val topK = call.argument<Int>("topK") ?: 40
                        val stopSequence = call.argument<String>("stopSequence")

                        if (prompt.isNullOrEmpty()) {
                            result.error("INVALID_ARGS", "prompt is required", null)
                            return
                        }

                        executor.execute {
                            try {
                                Log.i(tag, "generateText: start promptLen=${prompt.length} maxTokens=$maxTokens")
                                val text = nativeGenerateText(prompt, maxTokens, temperature, topP, topK, stopSequence)
                                Log.i(tag, "generateText: done outLen=${text.length}")
                                mainHandler.post { result.success(text) }
                            } catch (t: Throwable) {
                                Log.e(tag, "generateText: failed", t)
                                mainHandler.post {
                                    result.error("NATIVE_ERROR", "nativeGenerateText failed: ${t.message}", null)
                                }
                            }
                        }
                    }

                    "startStreamingGeneration" -> {
                        val prompt = call.argument<String>("prompt")
                        val maxTokens = call.argument<Int>("maxTokens") ?: 256
                        val temperature = call.argument<Double>("temperature") ?: 0.7
                        val topP = call.argument<Double>("topP") ?: 0.9
                        val topK = call.argument<Int>("topK") ?: 40
                        val stopSequence = call.argument<String>("stopSequence")

                        if (prompt.isNullOrEmpty()) {
                            result.error("INVALID_ARGS", "prompt is required", null)
                            return
                        }

                        if (eventSink == null) {
                            result.error("NO_LISTENER", "EventChannel has no listener", null)
                            return
                        }

                        executor.execute {
                            try {
                                Log.i(tag, "startStreamingGeneration: start promptLen=${prompt.length} maxTokens=$maxTokens")
                                
                                // Use callback-based streaming (implemented in C++)
                                val text = nativeGenerateTextStreaming(prompt, maxTokens, temperature, topP, topK, stopSequence)
                                
                                Log.i(tag, "startStreamingGeneration: done outLen=${text.length}")
                                sendDone()
                            } catch (t: Throwable) {
                                Log.e(tag, "startStreamingGeneration: failed", t)
                                sendError("Generation failed: ${t.message}")
                            }
                        }
                        
                        result.success(null)
                    }

                    "cancelGeneration" -> {
                        try {
                            Log.i(tag, "cancelGeneration")
                            nativeCancelGeneration()
                            result.success(null)
                        } catch (t: Throwable) {
                            Log.e(tag, "cancelGeneration: failed", t)
                            result.error("NATIVE_ERROR", "nativeCancelGeneration failed: ${t.message}", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        eventSink = null
        executor.shutdown()
    }
    
    // Callback from native code to send tokens
    @Suppress("unused")
    fun onTokenGenerated(token: String) {
        sendToken(token)
    }
}
