import 'package:flutter/material.dart';
import '../models/app_info.dart';
import '../models/risk_level.dart';
import '../services/risk_analyzer.dart';
import '../utils/constants.dart';

class DashboardScreen extends StatelessWidget {
  final List<AppInfo> apps;

  const DashboardScreen({super.key, required this.apps});

  @override
  Widget build(BuildContext context) {
    final stats = RiskAnalyzer.getPermissionStatistics(apps);
    final highRiskApps = apps.where((app) => app.riskLevel == RiskLevel.high).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Privacy Overview',
            style: TextStyle(
              color: AppConstants.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Risk Distribution Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'High Risk',
                  stats['highRiskApps'].toString(),
                  AppConstants.highRiskColor,
                  Icons.error,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Medium Risk',
                  stats['mediumRiskApps'].toString(),
                  AppConstants.mediumRiskColor,
                  Icons.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Low Risk',
                  stats['lowRiskApps'].toString(),
                  AppConstants.lowRiskColor,
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Permission Statistics
          Card(
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
                  const Text(
                    'Common Permissions',
                    style: TextStyle(
                      color: AppConstants.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildPermissionStat(
                    'Camera Access',
                    stats['appsWithCamera']!,
                    stats['totalApps']!,
                    Icons.camera_alt,
                  ),
                  _buildPermissionStat(
                    'Location Access',
                    stats['appsWithLocation']!,
                    stats['totalApps']!,
                    Icons.location_on,
                  ),
                  _buildPermissionStat(
                    'Microphone Access',
                    stats['appsWithMicrophone']!,
                    stats['totalApps']!,
                    Icons.mic,
                  ),
                  _buildPermissionStat(
                    'Contacts Access',
                    stats['appsWithContacts']!,
                    stats['totalApps']!,
                    Icons.contacts,
                  ),
                  _buildPermissionStat(
                    'Storage Access',
                    stats['appsWithStorage']!,
                    stats['totalApps']!,
                    Icons.storage,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // High Risk Apps
          if (highRiskApps.isNotEmpty) ...[
            const Text(
              'High Risk Apps',
              style: TextStyle(
                color: AppConstants.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AppConstants.surfaceColor,
              elevation: AppConstants.cardElevation,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: Column(
                children: highRiskApps.take(5).map((app) {
                  return ListTile(
                    leading: app.iconData != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              app.iconData!,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(
                            Icons.android,
                            color: AppConstants.primaryColor,
                            size: 40,
                          ),
                    title: Text(
                      app.appName,
                      style: const TextStyle(
                        color: AppConstants.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      '${app.grantedPermissions.length} dangerous permissions',
                      style: const TextStyle(
                        color: AppConstants.highRiskColor,
                        fontSize: 12,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppConstants.textSecondary,
                      size: 16,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
          
          const SizedBox(height: 24),
          
          // Privacy Tips
          Card(
            color: AppConstants.primaryColor.withValues(alpha: 0.1),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              side: BorderSide(color: AppConstants.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: AppConstants.primaryColor,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Privacy Tip',
                        style: TextStyle(
                          color: AppConstants.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Regularly review app permissions and revoke access that apps don\'t need. Apps requesting camera, microphone, and location together pose the highest privacy risk.',
                    style: TextStyle(
                      color: AppConstants.textSecondary,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Card(
      color: AppConstants.surfaceColor,
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppConstants.textSecondary,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionStat(String label, int count, int total, IconData icon) {
    final percentage = total > 0 ? (count / total * 100).toInt() : 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppConstants.primaryColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: AppConstants.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$count apps ($percentage%)',
                style: TextStyle(
                  color: AppConstants.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: total > 0 ? count / total : 0,
              backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}
