import Flutter
import UIKit

public class TranzfortLlmPlugin: NSObject, FlutterPlugin {
  private let queue = DispatchQueue(label: "com.tranzfort.llm", qos: .userInitiated)
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "tranzfort_llm", binaryMessenger: registrar.messenger())
    let instance = TranzfortLlmPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      
    case "loadModel":
      handleLoadModel(call: call, result: result)
      
    case "unloadModel":
      handleUnloadModel(result: result)
      
    case "isModelLoaded":
      handleIsModelLoaded(result: result)
      
    case "generateText":
      handleGenerateText(call: call, result: result)
      
    case "cancelGeneration":
      handleCancelGeneration(result: result)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func handleLoadModel(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let modelPath = args["modelPath"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing modelPath", details: nil))
      return
    }
    
    let contextSize = args["contextSize"] as? Int ?? 2048
    let threads = args["threads"] as? Int ?? 4
    let useGpu = args["useGpu"] as? Bool ?? false
    
    queue.async {
      let success = TranzfortLlmBackendBridge.loadModel(
        modelPath: modelPath,
        contextSize: Int32(contextSize),
        threads: Int32(threads),
        useGpu: useGpu
      )
      
      DispatchQueue.main.async {
        if success {
          result(nil)
        } else {
          result(FlutterError(code: "LOAD_FAILED", message: "Failed to load model", details: nil))
        }
      }
    }
  }
  
  private func handleUnloadModel(result: @escaping FlutterResult) {
    queue.async {
      TranzfortLlmBackendBridge.unloadModel()
      DispatchQueue.main.async {
        result(nil)
      }
    }
  }
  
  private func handleIsModelLoaded(result: @escaping FlutterResult) {
    let loaded = TranzfortLlmBackendBridge.isModelLoaded()
    result(loaded)
  }
  
  private func handleGenerateText(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let prompt = args["prompt"] as? String else {
      result(FlutterError(code: "INVALID_ARGS", message: "Missing prompt", details: nil))
      return
    }
    
    let maxTokens = args["maxTokens"] as? Int ?? 512
    let temperature = args["temperature"] as? Double ?? 0.7
    let topP = args["topP"] as? Double ?? 0.9
    let topK = args["topK"] as? Int ?? 40
    let stopSequence = args["stopSequence"] as? String ?? ""
    
    queue.async {
      let text = TranzfortLlmBackendBridge.generateText(
        prompt: prompt,
        maxTokens: Int32(maxTokens),
        temperature: temperature,
        topP: topP,
        topK: Int32(topK),
        stopSequence: stopSequence
      )
      
      DispatchQueue.main.async {
        result(text)
      }
    }
  }
  
  private func handleCancelGeneration(result: @escaping FlutterResult) {
    TranzfortLlmBackendBridge.cancelGeneration()
    result(nil)
  }
}
