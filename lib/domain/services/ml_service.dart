/// Machine Learning Service
/// Provides ML-based categorization and classification
/// Currently uses rule-based approach, ready for TFLite model integration
class MlService {
  bool _isInitialized = false;

  /// Initialize ML service
  Future<bool> initialize() async {
    try {
      // TODO: Load TFLite models when available
      // await _loadExpenseCategorizerModel();
      // await _loadIntentClassifierModel();
      
      _isInitialized = true;
      return true;
    } catch (e) {
      print('ML Service initialization error (non-critical): $e');
      return false;
    }
  }

  /// Check if ML service is initialized
  bool get isInitialized => _isInitialized;

  /// Categorize expense using ML
  /// Currently uses rule-based approach, will use TFLite model when available
  Future<ExpenseCategoryPrediction> categorizeExpense(String description) async {
    // TODO: Use TFLite model for prediction
    // For now, use rule-based categorization
    final category = _ruleBasedCategorization(description);
    
    return ExpenseCategoryPrediction(
      category: category,
      confidence: 0.85, // Rule-based confidence
      method: 'rule-based',
    );
  }

  /// Classify intent using ML
  /// Currently uses rule-based approach, will use TFLite model when available
  Future<IntentClassificationResult> classifyIntent(String text) async {
    // TODO: Use TFLite model for prediction
    // For now, use rule-based classification
    final intent = _ruleBasedIntentClassification(text);
    
    return IntentClassificationResult(
      intent: intent,
      confidence: 0.80, // Rule-based confidence
      method: 'rule-based',
    );
  }

  /// Rule-based expense categorization
  String _ruleBasedCategorization(String description) {
    final lower = description.toLowerCase();
    
    if (lower.contains('fuel') || lower.contains('diesel') || lower.contains('petrol')) {
      return 'FUEL';
    }
    if (lower.contains('toll')) {
      return 'TOLL';
    }
    if (lower.contains('food') || lower.contains('lunch') || lower.contains('dinner')) {
      return 'FOOD';
    }
    if (lower.contains('maintenance') || lower.contains('repair')) {
      return 'MAINTENANCE';
    }
    if (lower.contains('parking')) {
      return 'PARKING';
    }
    if (lower.contains('loading') || lower.contains('unloading')) {
      return 'LOADING_UNLOADING';
    }
    
    return 'OTHER';
  }

  /// Rule-based intent classification
  String _ruleBasedIntentClassification(String text) {
    final lower = text.toLowerCase();
    
    if (lower.contains('show') || lower.contains('find') || lower.contains('search')) {
      return 'query';
    }
    if (lower.contains('add') || lower.contains('create') || lower.contains('update')) {
      return 'command';
    }
    if (lower.contains('how much') || lower.contains('how many') || lower.contains('what')) {
      return 'question';
    }
    
    return 'query';
  }

  /// Dispose resources
  void dispose() {
    // TODO: Dispose TFLite models when available
    _isInitialized = false;
  }
}

/// Expense category prediction result
class ExpenseCategoryPrediction {
  final String category;
  final double confidence;
  final String method;

  ExpenseCategoryPrediction({
    required this.category,
    required this.confidence,
    required this.method,
  });
}

/// Intent classification result
class IntentClassificationResult {
  final String intent;
  final double confidence;
  final String method;

  IntentClassificationResult({
    required this.intent,
    required this.confidence,
    required this.method,
  });
}
