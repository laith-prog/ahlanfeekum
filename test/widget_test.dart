// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ahlanfeekum/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Initialize EasyLocalization for testing
    await EasyLocalization.ensureInitialized();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the app starts without crashing
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
