
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:fitness_app/firebase_options.dart';

// Pass valid credentials at runtime via:
//   --dart-define=TEST_LOGIN_EMAIL=you@example.com \
//   --dart-define=TEST_LOGIN_PASSWORD=secret \
//   --dart-define=BACKEND_FLAVOR=firebase
const String _testEmail = String.fromEnvironment('TEST_LOGIN_EMAIL');
const String _testPassword = String.fromEnvironment('TEST_LOGIN_PASSWORD');

Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
  Duration step = const Duration(milliseconds: 300),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (tester.any(finder)) return;
  }
  // One final settle attempt
  await tester.pumpAndSettle(const Duration(seconds: 1));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Firebase login E2E navigates to Routines', (tester) async {
    // If credentials not provided, no-op this test to avoid failures.
    if (_testEmail.isEmpty || _testPassword.isEmpty) {
      // Nothing to assert; treat as a pass when not configured.
      return;
    }

    // Init Firebase and DI (mirrors main() boot sequence).
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    // Launch full app
    runApp(const MyApp());
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // We should be on Login. Enter credentials.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'UserName'), _testEmail);
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), _testPassword);

    // Tap Login
    await tester.tap(find.text('Login'));
    await tester.pump(const Duration(milliseconds: 200));

    // Wait for navigation to the routines list (AppBar title 'Routines').
    await _pumpUntilFound(tester, find.text('Routines'));
    expect(find.text('Routines'), findsOneWidget);
  });
}

