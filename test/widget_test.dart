import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_permission_manager/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump(); // Let animations start

    // The splash screen should be shown first
    expect(find.text('App Permission\nManager'), findsOneWidget);
    expect(find.text('Monitor & Analyze App Permissions'), findsOneWidget);
    expect(find.byIcon(Icons.security), findsOneWidget);
  });
}
