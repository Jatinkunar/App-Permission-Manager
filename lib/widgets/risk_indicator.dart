import 'package:flutter/material.dart';
import '../models/risk_level.dart';
import '../utils/constants.dart';

class RiskIndicator extends StatelessWidget {
  final RiskLevel riskLevel;
  final bool showLabel;
  final double size;

  const RiskIndicator({
    super.key,
    required this.riskLevel,
    this.showLabel = true,
    this.size = 24.0,
  });

  Color _getRiskColor() {
    switch (riskLevel) {
      case RiskLevel.low:
        return AppConstants.lowRiskColor;
      case RiskLevel.medium:
        return AppConstants.mediumRiskColor;
      case RiskLevel.high:
        return AppConstants.highRiskColor;
    }
  }

  IconData _getRiskIcon() {
    switch (riskLevel) {
      case RiskLevel.low:
        return Icons.check_circle;
      case RiskLevel.medium:
        return Icons.warning;
      case RiskLevel.high:
        return Icons.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRiskColor();
    
    if (!showLabel) {
      return Icon(
        _getRiskIcon(),
        color: color,
        size: size,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius / 2),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getRiskIcon(), color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            riskLevel.label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
