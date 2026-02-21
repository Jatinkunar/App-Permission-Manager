import 'package:flutter/material.dart';
import '../models/permission_info.dart';
import '../utils/constants.dart';

class PermissionChip extends StatelessWidget {
  final PermissionInfo permission;

  const PermissionChip({
    super.key,
    required this.permission,
  });

  Color _getCategoryColor() {
    switch (permission.category) {
      case PermissionCategory.dangerous:
        return AppConstants.highRiskColor;
      case PermissionCategory.special:
        return AppConstants.mediumRiskColor;
      case PermissionCategory.normal:
        return AppConstants.lowRiskColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Text(
        permission.displayName,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
