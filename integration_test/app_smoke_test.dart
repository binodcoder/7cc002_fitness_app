import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/core/services/session_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App launches and shows routines (fake backend)',
      (WidgetTester tester) async {
    // Initialize DI and mark onboarding as seen so we skip onboarding.
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    // Start the app widget.
    runApp(const MyApp());

    // Allow splash timer and routing to complete.
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Verify at least one seeded routine from fake repo is visible.
    expect(find.text('Full Body Beginner'), findsOneWidget);
  });
}
