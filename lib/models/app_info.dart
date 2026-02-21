import 'dart:typed_data';
import 'risk_level.dart';

class AppInfo {
  final String appName;
  final String packageName;
  final Uint8List? iconData;
  final int permissionCount;
  final bool isSystemApp;
  final List<String> grantedPermissions;
  final List<String> requestedPermissions;
  final RiskLevel riskLevel;

  AppInfo({
    required this.appName,
    required this.packageName,
    this.iconData,
    required this.permissionCount,
    required this.isSystemApp,
    this.grantedPermissions = const [],
    this.requestedPermissions = const [],
    required this.riskLevel,
  });

  factory AppInfo.fromMap(Map<String, dynamic> map) {
    return AppInfo(
      appName: map['appName'] as String,
      packageName: map['packageName'] as String,
      iconData: map['iconData'] as Uint8List?,
      permissionCount: map['permissionCount'] as int,
      isSystemApp: map['isSystemApp'] as bool,
      grantedPermissions: map['grantedPermissions'] as List<String>? ?? [],
      requestedPermissions: map['requestedPermissions'] as List<String>? ?? [],
      riskLevel: map['riskLevel'] as RiskLevel? ?? RiskLevel.low,
    );
  }

  AppInfo copyWith({
    String? appName,
    String? packageName,
    Uint8List? iconData,
    int? permissionCount,
    bool? isSystemApp,
    List<String>? grantedPermissions,
    List<String>? requestedPermissions,
    RiskLevel? riskLevel,
  }) {
    return AppInfo(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      iconData: iconData ?? this.iconData,
      permissionCount: permissionCount ?? this.permissionCount,
      isSystemApp: isSystemApp ?? this.isSystemApp,
      grantedPermissions: grantedPermissions ?? this.grantedPermissions,
      requestedPermissions: requestedPermissions ?? this.requestedPermissions,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }
}
