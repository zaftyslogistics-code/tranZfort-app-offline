enum AlertType {
  unusualExpense,
  creditRisk,
  maintenanceDue,
  lowProfitRoute,
  highFuelCost,
}

enum AlertSeverity {
  info,
  warning,
  critical,
}

class Alert {
  final String id;
  final AlertType type;
  final AlertSeverity severity;
  final String title;
  final String message;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;
  final bool isRead;

  Alert({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.message,
    required this.timestamp,
    this.metadata = const {},
    this.isRead = false,
  });

  Alert copyWith({
    String? id,
    AlertType? type,
    AlertSeverity? severity,
    String? title,
    String? message,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    bool? isRead,
  }) {
    return Alert(
      id: id ?? this.id,
      type: type ?? this.type,
      severity: severity ?? this.severity,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'severity': severity.name,
        'title': title,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
        'isRead': isRead,
      };

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'] as String,
      type: AlertType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AlertType.unusualExpense,
      ),
      severity: AlertSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => AlertSeverity.info,
      ),
      title: json['title'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
      isRead: json['isRead'] as bool? ?? false,
    );
  }
}

class AlertThresholds {
  final double unusualExpenseMultiplier;
  final double creditLimitPercentage;
  final int maintenanceMileageInterval;
  final double lowProfitThreshold;
  final double highFuelCostPercentage;

  const AlertThresholds({
    this.unusualExpenseMultiplier = 2.0,
    this.creditLimitPercentage = 80.0,
    this.maintenanceMileageInterval = 10000,
    this.lowProfitThreshold = 1000.0,
    this.highFuelCostPercentage = 20.0,
  });

  AlertThresholds copyWith({
    double? unusualExpenseMultiplier,
    double? creditLimitPercentage,
    int? maintenanceMileageInterval,
    double? lowProfitThreshold,
    double? highFuelCostPercentage,
  }) {
    return AlertThresholds(
      unusualExpenseMultiplier: unusualExpenseMultiplier ?? this.unusualExpenseMultiplier,
      creditLimitPercentage: creditLimitPercentage ?? this.creditLimitPercentage,
      maintenanceMileageInterval: maintenanceMileageInterval ?? this.maintenanceMileageInterval,
      lowProfitThreshold: lowProfitThreshold ?? this.lowProfitThreshold,
      highFuelCostPercentage: highFuelCostPercentage ?? this.highFuelCostPercentage,
    );
  }

  Map<String, dynamic> toJson() => {
        'unusualExpenseMultiplier': unusualExpenseMultiplier,
        'creditLimitPercentage': creditLimitPercentage,
        'maintenanceMileageInterval': maintenanceMileageInterval,
        'lowProfitThreshold': lowProfitThreshold,
        'highFuelCostPercentage': highFuelCostPercentage,
      };

  factory AlertThresholds.fromJson(Map<String, dynamic> json) {
    return AlertThresholds(
      unusualExpenseMultiplier: (json['unusualExpenseMultiplier'] as num?)?.toDouble() ?? 2.0,
      creditLimitPercentage: (json['creditLimitPercentage'] as num?)?.toDouble() ?? 80.0,
      maintenanceMileageInterval: json['maintenanceMileageInterval'] as int? ?? 10000,
      lowProfitThreshold: (json['lowProfitThreshold'] as num?)?.toDouble() ?? 1000.0,
      highFuelCostPercentage: (json['highFuelCostPercentage'] as num?)?.toDouble() ?? 20.0,
    );
  }
}
