import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/core/services/session_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Add a new routine via form and verify it appears',
      (WidgetTester tester) async {
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    runApp(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Tap the FAB to open the add routine form.
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Fill in the form fields using their hints.
    await tester.enterText(find.widgetWithText(TextFormField, 'Routine Name'),
        'Integration Routine');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'), 'Test description');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Difficulty'), 'Medium');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Duration (minutes)'), '15');
    await tester.enterText(find.widgetWithText(TextFormField, 'Source'), 'App');

    // Submit by tapping the gradient button's child text.
    await tester.tap(find.text('Add Routine'));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // Back on list screen; new routine should be displayed.
    expect(find.text('Integration Routine'), findsOneWidget);
  });
}
