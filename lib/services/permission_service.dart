import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/app_info.dart';
import '../models/risk_level.dart';
import 'risk_analyzer.dart';

class PermissionService {
  static const MethodChannel _channel = MethodChannel('app_permissions');

  /// Fetches all installed applications from the device
  Future<List<AppInfo>> getInstalledApps() async {
    try {
      final List<dynamic> result = await _channel.invokeMethod('getInstalledApps');
      
      List<AppInfo> apps = [];
      for (var appData in result) {
        final Map<String, dynamic> appMap = Map<String, dynamic>.from(appData);
        
        // Decode base64 icon
        Uint8List? iconData;
        if (appMap['icon'] != null) {
          try {
            iconData = base64Decode(appMap['icon']);
          } catch (e) {
            iconData = null;
          }
        }
        
        // Create basic app info (permissions will be fetched separately if needed)
        final app = AppInfo(
          appName: appMap['appName'] as String,
          packageName: appMap['packageName'] as String,
          iconData: iconData,
          permissionCount: appMap['permissionCount'] as int,
          isSystemApp: appMap['isSystemApp'] as bool,
          riskLevel: RiskLevel.low, // Will be updated when permissions are fetched
        );
        
        apps.add(app);
      }
      
      return apps;
    } catch (e) {
      throw Exception('Failed to get installed apps: $e');
    }
  }

  /// Fetches detailed permissions for a specific app
  Future<AppInfo> getAppWithPermissions(AppInfo app) async {
    try {
      final Map<dynamic, dynamic> result = await _channel.invokeMethod(
        'getAppPermissions',
        {'packageName': app.packageName},
      );
      
      final List<String> requestedPermissions = 
          (result['requestedPermissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [];
      
      final List<String> grantedPermissions = 
          (result['grantedPermissions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ?? [];
      
      // Calculate risk level based on granted permissions
      final riskLevel = RiskAnalyzer.calculateRiskLevel(grantedPermissions);
      
      return app.copyWith(
        requestedPermissions: requestedPermissions,
        grantedPermissions: grantedPermissions,
        riskLevel: riskLevel,
      );
    } catch (e) {
      throw Exception('Failed to get app permissions: $e');
    }
  }

  /// Opens the system settings page for a specific app
  Future<void> openAppSettings(String packageName) async {
    try {
      await _channel.invokeMethod('openAppSettings', {'packageName': packageName});
    } catch (e) {
      throw Exception('Failed to open app settings: $e');
    }
  }

  /// Fetches all apps with their permissions (heavy operation)
  Future<List<AppInfo>> getAllAppsWithPermissions() async {
    final apps = await getInstalledApps();
    
    List<AppInfo> appsWithPermissions = [];
    for (var app in apps) {
      try {
        final appWithPerms = await getAppWithPermissions(app);
        appsWithPermissions.add(appWithPerms);
      } catch (e) {
        // If we fail to get permissions for an app, add it with default values
        appsWithPermissions.add(app);
      }
    }
    
    return appsWithPermissions;
  }
}
