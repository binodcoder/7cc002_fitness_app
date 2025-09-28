import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login screen basic interactions and Register navigation',
      (WidgetTester tester) async {
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    await tester.pumpWidget(
      ScreenUtilInit(
        builder: (context, child) => const MaterialApp(home: LoginPage()),
      ),
    );
    // Avoid waiting on infinite animations (e.g., Flare). Limit settle time.
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify key UI is present (robust selectors).
    expect(find.text('UserName'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Open Forgot Password dialog and close it.
    await tester.tap(find.text('Forgot Password?'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Enter credentials.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'UserName'), 'binodcoder@gmail.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123456');

    // Toggle password visibility icon once.
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Navigate to Register page.
    await tester.tap(find.text('Register'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Confirm Register page is shown (by its AppBar title).
    expect(find.text('Register'), findsWidgets);
  });
}
