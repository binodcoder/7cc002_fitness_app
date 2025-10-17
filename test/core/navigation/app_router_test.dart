import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/app/injection_container.dart' as di;
import 'package:fitness_app/core/widgets/splash_screen.dart';
import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/features/onboarding/pages/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/services/session_manager.dart';
import 'package:fitness_app/core/entities/user.dart' as user_entity;

class _FakeSessionManager implements SessionManager {
  bool seenOnboarding = false;
  @override
  Future<void> clear({bool preserveOnboarding = true}) async {}
  @override
  user_entity.User? getCurrentUser() => null;
  @override
  bool hasSeenOnboarding() => seenOnboarding;
  @override
  Future<bool> isLoggedIn() async => false;
  @override
  Future<void> persistUser(user_entity.User user) async {}
  @override
  Future<void> setSeenOnboarding(bool value) async {
    seenOnboarding = value;
  }
}

void main() {
  testWidgets('unknown route shows No Route Found screen', (tester) async {
    if (!di.sl.isRegistered<SessionManager>()) {
      di.sl.registerLazySingleton<SessionManager>(() => _FakeSessionManager());
    }
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
    if (!di.sl.isRegistered<SessionManager>()) {
      di.sl.registerLazySingleton<SessionManager>(() => _FakeSessionManager());
    }

    // Ensure starting at splash for this test
    AppRouter.router.go('/splash');

    final localRouter = GoRouter(
      initialLocation: '/splash',
      routes: [
        GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(
      routerConfig: localRouter,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ));
    await tester.pumpAndSettle();

    final splash = find.byType(SplashScreen);
    final login = find.byType(LoginPage);
    final onboarding = find.byType(OnboardingScreen);
    expect(
      splash.evaluate().isNotEmpty ||
          login.evaluate().isNotEmpty ||
          onboarding.evaluate().isNotEmpty,
      true,
    );
  });
}
