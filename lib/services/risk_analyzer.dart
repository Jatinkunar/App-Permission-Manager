import '../models/app_info.dart';
import '../models/risk_level.dart';
import 'permission_database.dart';

class RiskAnalyzer {
  static RiskLevel calculateRiskLevel(List<String> grantedPermissions) {
    final dangerousPermissions = PermissionDatabase.getDangerousPermissions();
    
    // Count how many dangerous permissions are granted
    int dangerousCount = 0;
    bool hasLocation = false;
    bool hasCamera = false;
    bool hasMicrophone = false;
    bool hasSms = false;
    bool hasContacts = false;
    
    for (String permission in grantedPermissions) {
      if (dangerousPermissions.contains(permission)) {
        dangerousCount++;
        
        // Check for specific high-risk permissions
        if (permission.contains('LOCATION')) hasLocation = true;
        if (permission.contains('CAMERA')) hasCamera = true;
        if (permission.contains('RECORD_AUDIO')) hasMicrophone = true;
        if (permission.contains('SMS')) hasSms = true;
        if (permission.contains('CONTACTS')) hasContacts = true;
      }
    }
    
    // High risk criteria
    if (dangerousCount >= 5) return RiskLevel.high;
    if ((hasLocation && hasCamera) || (hasLocation && hasMicrophone)) return RiskLevel.high;
    if (hasSms && hasContacts) return RiskLevel.high;
    
    // Medium risk criteria
    if (dangerousCount >= 2) return RiskLevel.medium;
    if (hasLocation || hasCamera || hasMicrophone) return RiskLevel.medium;
    
    // Low risk
    return RiskLevel.low;
  }

  static String getRiskExplanation(RiskLevel riskLevel, List<String> grantedPermissions) {
    switch (riskLevel) {
      case RiskLevel.high:
        return 'This app has access to multiple sensitive permissions that could significantly impact your privacy. Review carefully.';
      case RiskLevel.medium:
        return 'This app has access to some sensitive permissions. Consider whether these are necessary for the app\'s functionality.';
      case RiskLevel.low:
        return 'This app has minimal access to sensitive data. It appears to follow good privacy practices.';
    }
  }

  static Map<String, int> getPermissionStatistics(List<AppInfo> apps) {
    int totalApps = apps.length;
    int highRiskApps = apps.where((app) => app.riskLevel == RiskLevel.high).length;
    int mediumRiskApps = apps.where((app) => app.riskLevel == RiskLevel.medium).length;
    int lowRiskApps = apps.where((app) => app.riskLevel == RiskLevel.low).length;
    
    // Count most common dangerous permissions
    Map<String, int> permissionCounts = {};
    final dangerousPermissions = PermissionDatabase.getDangerousPermissions();
    
    for (var app in apps) {
      for (var permission in app.grantedPermissions) {
        if (dangerousPermissions.contains(permission)) {
          permissionCounts[permission] = (permissionCounts[permission] ?? 0) + 1;
        }
      }
    }
    
    return {
      'totalApps': totalApps,
      'highRiskApps': highRiskApps,
      'mediumRiskApps': mediumRiskApps,
      'lowRiskApps': lowRiskApps,
      'appsWithCamera': permissionCounts['android.permission.CAMERA'] ?? 0,
      'appsWithLocation': (permissionCounts['android.permission.ACCESS_FINE_LOCATION'] ?? 0) +
          (permissionCounts['android.permission.ACCESS_COARSE_LOCATION'] ?? 0),
      'appsWithMicrophone': permissionCounts['android.permission.RECORD_AUDIO'] ?? 0,
      'appsWithContacts': permissionCounts['android.permission.READ_CONTACTS'] ?? 0,
      'appsWithStorage': (permissionCounts['android.permission.READ_EXTERNAL_STORAGE'] ?? 0) +
          (permissionCounts['android.permission.WRITE_EXTERNAL_STORAGE'] ?? 0),
    };
  }
}
