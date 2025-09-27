import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/injection_container.dart' as di;
import 'package:fitness_app/core/widgets/splash_screen.dart';

void main() {
  testWidgets('unknown route shows No Route Found screen', (tester) async {
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: AppRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    // Navigate to an unknown location
    AppRouter.router.go('/this-route-does-not-exist');
    await tester.pumpAndSettle();
    expect(find.text(AppStringsEn.noRouteFound), findsWidgets);
  });

  testWidgets('splash route builds SplashScreen via AppRouter', (tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    if (!di.sl.isRegistered<SharedPreferences>()) {
      di.sl.registerLazySingleton<SharedPreferences>(() => prefs);
    }

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: AppRouter.router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pump();
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
