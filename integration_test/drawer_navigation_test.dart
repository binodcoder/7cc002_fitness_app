import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Navigate to Walks and Live Trainings via drawer',
      (WidgetTester tester) async {
    await di.init();
    await di.sl<SessionManager>().setSeenOnboarding(true);

    runApp(const MyApp());
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // We should be on Routines; open the drawer.
    final Finder menuButton = find.byTooltip('Open navigation menu');
    expect(menuButton, findsOneWidget);
    await tester.tap(menuButton);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Tap Walk (drawer item text is localized to 'Walk').
    await tester.tap(find.text('Walk'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Verify Walks page. AppBar title is 'Purposed Walks' and an item exists.
    expect(find.text('Purposed Walks'), findsOneWidget);
    // Seeded fake walk has start location 'Main Gate'.
    expect(find.text('Main Gate'), findsWidgets);

    // Open drawer again to navigate to Live Trainings.
    await tester.tap(menuButton);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Live Trainings'));
    await tester.pumpAndSettle();

    // Verify a seeded training item appears.
    expect(find.text('Morning Yoga'), findsOneWidget);
  });
}
