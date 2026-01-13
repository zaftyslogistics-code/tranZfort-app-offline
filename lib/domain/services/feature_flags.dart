import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Feature flags service for controlling app features
class FeatureFlags {
  static final FeatureFlags _instance = FeatureFlags._();
  static FeatureFlags get instance => _instance;
  
  FeatureFlags._();

  SharedPreferences? _prefs;
  final Map<String, bool> _cache = {};

  /// Initialize feature flags
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadCache();
  }

  /// Check if a feature is enabled
  bool isEnabled(Feature feature) {
    // Check cache first
    if (_cache.containsKey(feature.key)) {
      return _cache[feature.key]!;
    }

    // Check SharedPreferences
    final value = _prefs?.getBool(feature.key);
    if (value != null) {
      _cache[feature.key] = value;
      return value;
    }

    // Return default value
    _cache[feature.key] = feature.defaultValue;
    return feature.defaultValue;
  }

  /// Enable a feature
  Future<void> enable(Feature feature) async {
    await _setFlag(feature.key, true);
  }

  /// Disable a feature
  Future<void> disable(Feature feature) async {
    await _setFlag(feature.key, false);
  }

  /// Toggle a feature
  Future<void> toggle(Feature feature) async {
    final current = isEnabled(feature);
    await _setFlag(feature.key, !current);
  }

  /// Reset a feature to its default value
  Future<void> reset(Feature feature) async {
    await _setFlag(feature.key, feature.defaultValue);
  }

  /// Reset all features to defaults
  Future<void> resetAll() async {
    for (final feature in Feature.values) {
      await reset(feature);
    }
  }

  /// Get all feature states
  Map<String, bool> getAllStates() {
    final states = <String, bool>{};
    for (final feature in Feature.values) {
      states[feature.key] = isEnabled(feature);
    }
    return states;
  }

  Future<void> _setFlag(String key, bool value) async {
    _cache[key] = value;
    await _prefs?.setBool(key, value);
    
    if (kDebugMode) {
      print('[FeatureFlags] $key = $value');
    }
  }

  void _loadCache() {
    for (final feature in Feature.values) {
      final value = _prefs?.getBool(feature.key);
      if (value != null) {
        _cache[feature.key] = value;
      }
    }
  }
}

enum Feature {
  // LLM Features
  enableLlm(
    key: 'feature_enable_llm',
    defaultValue: true,
    description: 'Enable on-device LLM inference',
  ),
  enableStreaming(
    key: 'feature_enable_streaming',
    defaultValue: true,
    description: 'Enable streaming token generation',
  ),
  enableGpuAcceleration(
    key: 'feature_enable_gpu',
    defaultValue: true,
    description: 'Enable GPU acceleration (Metal/Vulkan)',
  ),
  
  // Tool Features
  enableToolCalls(
    key: 'feature_enable_tool_calls',
    defaultValue: true,
    description: 'Enable AI tool calling',
  ),
  requireToolConfirmation(
    key: 'feature_require_tool_confirmation',
    defaultValue: true,
    description: 'Require user confirmation for tool executions',
  ),
  
  // Voice Features
  enableVoiceInput(
    key: 'feature_enable_voice_input',
    defaultValue: true,
    description: 'Enable voice input',
  ),
  enableTts(
    key: 'feature_enable_tts',
    defaultValue: false,
    description: 'Enable text-to-speech for responses',
  ),
  
  // Analytics Features
  enableInsightsHub(
    key: 'feature_enable_insights_hub',
    defaultValue: true,
    description: 'Enable Insights Hub',
  ),
  enableAnalytics(
    key: 'feature_enable_analytics',
    defaultValue: true,
    description: 'Enable analytics tracking',
  ),
  
  // Performance Features
  enablePerformanceMonitoring(
    key: 'feature_enable_performance_monitoring',
    defaultValue: true,
    description: 'Enable performance monitoring',
  ),
  enableAuditLogging(
    key: 'feature_enable_audit_logging',
    defaultValue: true,
    description: 'Enable audit logging',
  ),
  
  // Debug Features
  enableDebugMode(
    key: 'feature_enable_debug_mode',
    defaultValue: kDebugMode,
    description: 'Enable debug mode with verbose logging',
  ),
  enableDevTools(
    key: 'feature_enable_dev_tools',
    defaultValue: kDebugMode,
    description: 'Enable developer tools',
  ),
  
  // Experimental Features
  enableExperimentalFeatures(
    key: 'feature_enable_experimental',
    defaultValue: false,
    description: 'Enable experimental features',
  ),
  enableBetaFeatures(
    key: 'feature_enable_beta',
    defaultValue: false,
    description: 'Enable beta features',
  );

  const Feature({
    required this.key,
    required this.defaultValue,
    required this.description,
  });

  final String key;
  final bool defaultValue;
  final String description;
}
