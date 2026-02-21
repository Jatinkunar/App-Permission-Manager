enum PermissionCategory {
  normal,
  dangerous,
  special;

  String get label {
    switch (this) {
      case PermissionCategory.normal:
        return 'Normal';
      case PermissionCategory.dangerous:
        return 'Dangerous';
      case PermissionCategory.special:
        return 'Special';
    }
  }
}

class PermissionInfo {
  final String name;
  final String displayName;
  final PermissionCategory category;
  final String description;
  final String riskExplanation;

  PermissionInfo({
    required this.name,
    required this.displayName,
    required this.category,
    required this.description,
    required this.riskExplanation,
  });

  factory PermissionInfo.fromPermissionName(String permissionName) {
    // This will be populated by the permission database
    return PermissionInfo(
      name: permissionName,
      displayName: permissionName.split('.').last,
      category: PermissionCategory.normal,
      description: 'Permission description',
      riskExplanation: 'Risk explanation',
    );
  }
}
