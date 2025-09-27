// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/injection_container.dart' as di;
import 'package:fitness_app/app/app.dart';
import 'package:fitness_app/core/widgets/splash_screen.dart';

void main() {
  testWidgets('MyApp builds and shows SplashScreen', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    // Minimal DI needed for SplashScreen
    if (!di.sl.isRegistered<SharedPreferences>()) {
      di.sl.registerLazySingleton<SharedPreferences>(() => prefs);
    }

    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
