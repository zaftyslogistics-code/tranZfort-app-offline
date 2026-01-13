package com.zaftyslogistics.tranzfort.tranzfort_llm

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertNotNull
import org.junit.Assert.assertNull
import org.junit.Assert.assertTrue
import org.junit.Test

internal class TranzfortLlmPluginInstrumentedTest {
    private class CapturingResult : MethodChannel.Result {
        var successValue: Any? = null
        var errorCode: String? = null
        var errorMessage: String? = null
        var errorDetails: Any? = null
        var notImplementedCalled: Boolean = false

        override fun success(result: Any?) {
            successValue = result
        }

        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            this.errorCode = errorCode
            this.errorMessage = errorMessage
            this.errorDetails = errorDetails
        }

        override fun notImplemented() {
            notImplementedCalled = true
        }
    }

    @Test
    fun nativeBridge_doesNotCrash_onInvalidModelPath_andGenerateTextReturnsErrorString() {
        val plugin = TranzfortLlmPlugin()

        // Ensure initial state is not loaded.
        run {
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("isModelLoaded", null), result)
            assertNull(result.errorCode)
            assertEquals(false, result.successValue)
        }

        // Load model with invalid path should return false, not crash.
        run {
            val args = mapOf(
                "modelPath" to "/data/local/tmp/does-not-exist.gguf",
                "contextSize" to 256,
                "threads" to 2,
                "useGpu" to false,
            )
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("loadModel", args), result)
            assertNull(result.errorCode)
            assertEquals(false, result.successValue)
        }

        // generateText should still go through JNI and return the backend error string.
        run {
            val args = mapOf(
                "prompt" to "Hello",
                "maxTokens" to 8,
                "temperature" to 0.7,
                "topP" to 0.9,
                "topK" to 40,
                "stopSequence" to null,
            )
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("generateText", args), result)
            assertNull(result.errorCode)
            val text = result.successValue as String?
            assertNotNull(text)
            assertTrue(text!!.contains("model not loaded"))
        }

        // cancel/unload are no-op safety calls and should not crash.
        run {
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("cancelGeneration", null), result)
            assertNull(result.errorCode)
            assertNull(result.successValue)
            assertFalse(result.notImplementedCalled)
        }

        run {
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("unloadModel", null), result)
            assertNull(result.errorCode)
            assertNull(result.successValue)
            assertFalse(result.notImplementedCalled)
        }

        // Verify we are still not loaded.
        run {
            val result = CapturingResult()
            plugin.onMethodCall(MethodCall("isModelLoaded", null), result)
            assertNull(result.errorCode)
            assertEquals(false, result.successValue)
        }
    }
}
