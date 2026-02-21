import 'package:flutter_test/flutter_test.dart';
import 'package:app_permission_manager/services/risk_analyzer.dart';
import 'package:app_permission_manager/models/risk_level.dart';

void main() {
  group('RiskAnalyzer Tests', () {
    test('Low risk with no dangerous permissions', () {
      final riskLevel = RiskAnalyzer.calculateRiskLevel([
        'android.permission.INTERNET',
        'android.permission.ACCESS_NETWORK_STATE',
      ]);
      expect(riskLevel, RiskLevel.low);
    });

    test('Medium risk with location permission', () {
      final riskLevel = RiskAnalyzer.calculateRiskLevel([
        'android.permission.ACCESS_FINE_LOCATION',
      ]);
      expect(riskLevel, RiskLevel.medium);
    });

    test('High risk with multiple dangerous permissions', () {
      final riskLevel = RiskAnalyzer.calculateRiskLevel([
        'android.permission.CAMERA',
        'android.permission.RECORD_AUDIO',
        'android.permission.ACCESS_FINE_LOCATION',
        'android.permission.READ_CONTACTS',
        'android.permission.READ_SMS',
      ]);
      expect(riskLevel, RiskLevel.high);
    });

    test('High risk with location and camera', () {
      final riskLevel = RiskAnalyzer.calculateRiskLevel([
        'android.permission.CAMERA',
        'android.permission.ACCESS_FINE_LOCATION',
      ]);
      expect(riskLevel, RiskLevel.high);
    });
  });
}
