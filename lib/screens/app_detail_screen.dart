import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../models/permission_info.dart';
import '../services/permission_database.dart';
import '../services/permission_service.dart';
import '../services/risk_analyzer.dart';
import '../widgets/risk_indicator.dart';
import '../utils/constants.dart';

class AppDetailScreen extends StatelessWidget {
  final AppInfo app;

  const AppDetailScreen({super.key, required this.app});

  void _openSettings(BuildContext context) async {
    try {
      await PermissionService().openAppSettings(app.packageName);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dangerousPerms = app.grantedPermissions
        .where((p) => PermissionDatabase.getDangerousPermissions().contains(p))
        .toList();
    
    final normalPerms = app.grantedPermissions
        .where((p) => !PermissionDatabase.getDangerousPermissions().contains(p))
        .toList();

    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('App Details'),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              color: AppConstants.surfaceColor,
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    ),
                    child: app.iconData != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(
                              app.iconData!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.android,
                            color: AppConstants.primaryColor,
                            size: 48,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    app.appName,
                    style: const TextStyle(
                      color: AppConstants.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    app.packageName,
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Risk Score Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Card(
                color: AppConstants.surfaceColor,
                elevation: AppConstants.cardElevation,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Risk Assessment',
                            style: TextStyle(
                              color: AppConstants.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          RiskIndicator(riskLevel: app.riskLevel),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        RiskAnalyzer.getRiskExplanation(app.riskLevel, app.grantedPermissions),
                        style: TextStyle(
                          color: AppConstants.textSecondary,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildStatItem(
                            'Total',
                            app.grantedPermissions.length.toString(),
                            Icons.list,
                          ),
                          const SizedBox(width: 24),
                          _buildStatItem(
                            'Dangerous',
                            dangerousPerms.length.toString(),
                            Icons.warning,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),

            // Permission Management Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Card(
                color: AppConstants.primaryColor.withValues(alpha: 0.1),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                  side: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppConstants.primaryColor),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'To add or revoke permissions, you must use the system settings.',
                          style: TextStyle(
                            color: AppConstants.textPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Dangerous Permissions
            if (dangerousPerms.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dangerous Permissions (${dangerousPerms.length})',
                      style: const TextStyle(
                        color: AppConstants.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openSettings(context), 
                      child: const Text('Manage'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...dangerousPerms.map((perm) {
                final permInfo = PermissionDatabase.getPermissionInfo(perm);
                return _buildPermissionTile(permInfo);
              }),
              const SizedBox(height: 24),
            ],
            
            // Normal Permissions
            if (normalPerms.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                child: Text(
                  'Normal Permissions (${normalPerms.length})',
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...normalPerms.map((perm) {
                final permInfo = PermissionDatabase.getPermissionInfo(perm);
                return _buildPermissionTile(permInfo);
              }),
            ],
            
            const SizedBox(height: 32),
            
            // Open Settings Button
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _openSettings(context),
                  icon: const Icon(Icons.settings),
                  label: const Text(
                    'Manage Permissions in Settings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppConstants.primaryColor, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: AppConstants.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPermissionTile(PermissionInfo permInfo) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: 6,
      ),
      color: AppConstants.surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: 4,
        ),
        title: Text(
          permInfo.displayName,
          style: const TextStyle(
            color: AppConstants.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          permInfo.category.label,
          style: TextStyle(
            color: permInfo.category == PermissionCategory.dangerous
                ? AppConstants.highRiskColor
                : AppConstants.textSecondary,
            fontSize: 12,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  permInfo.description,
                  style: const TextStyle(
                    color: AppConstants.textPrimary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Privacy Risk:',
                  style: TextStyle(
                    color: AppConstants.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  permInfo.riskExplanation,
                  style: TextStyle(
                    color: permInfo.category == PermissionCategory.dangerous
                        ? AppConstants.highRiskColor
                        : AppConstants.textPrimary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
