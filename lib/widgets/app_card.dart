import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../widgets/risk_indicator.dart';
import '../utils/constants.dart';

class AppCard extends StatelessWidget {
  final AppInfo app;
  final VoidCallback onTap;

  const AppCard({
    super.key,
    required this.app,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      color: AppConstants.surfaceColor,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // App Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                ),
                child: app.iconData != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          app.iconData!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Icon(
                        Icons.android,
                        color: AppConstants.primaryColor,
                        size: 32,
                      ),
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              
              // App Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.appName,
                      style: const TextStyle(
                        color: AppConstants.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${app.permissionCount} permissions',
                      style: const TextStyle(
                        color: AppConstants.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Risk Indicator
              RiskIndicator(
                riskLevel: app.riskLevel,
                showLabel: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
