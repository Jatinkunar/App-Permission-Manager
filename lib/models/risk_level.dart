enum RiskLevel {
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case RiskLevel.low:
        return 'Low Risk';
      case RiskLevel.medium:
        return 'Medium Risk';
      case RiskLevel.high:
        return 'High Risk';
    }
  }

  String get color {
    switch (this) {
      case RiskLevel.low:
        return '#4CAF50'; // Green
      case RiskLevel.medium:
        return '#FF9800'; // Orange
      case RiskLevel.high:
        return '#F44336'; // Red
    }
  }
}
