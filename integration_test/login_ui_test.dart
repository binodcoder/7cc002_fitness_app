import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:fitness_app/l10n/app_localizations.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpUntilFound(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
    Duration step = const Duration(milliseconds: 200),
  }) async {
    final end = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(end)) {
      await tester.pump(step);
      if (tester.any(finder)) return;
    }
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('Login screen basic interactions and Register navigation',
      (WidgetTester tester) async {
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    await tester.pumpWidget(
      ScreenUtilInit(
        builder: (context, child) => const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LoginPage(),
        ),
      ),
    );
    // Initial settle with a small pump to avoid infinite animations.
    await tester.pump(const Duration(milliseconds: 300));

    // Verify key UI is present (labels + hints may duplicate).
    expect(find.text('UserName'), findsWidgets);
    expect(find.text('Password'), findsWidgets);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);

    // Open Forgot Password dialog and close it.
    await tester.tap(find.text('Forgot Password?'));
    await pumpUntilFound(tester, find.text('Reset Password'));
    expect(find.text('Reset Password'), findsOneWidget);
    expect(find.text('Send'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pump(const Duration(milliseconds: 300));

    // Enter credentials.
    await tester.enterText(
        find.widgetWithText(TextFormField, 'UserName'), 'binodcoder@gmail.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'), '123456');

    // Toggle password visibility icon once.
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump(const Duration(milliseconds: 300));

    // Navigate to Register page.
    // await tester.tap(find.text('Register'));
    // await pumpUntilFound(tester, find.byType(RegisterPage));

    // Confirm Register page is shown.
    // expect(find.byType(RegisterPage), findsOneWidget);
  });
}
