import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_state.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthStatusRequested()),
          child: BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) async {
              // Do not override initial Splash -> Onboarding flow
              // Let SplashScreen decide routing until onboarding is seen
              final hasSeenOnboarding =
                  sl<SessionManager>().hasSeenOnboarding();
              if (!hasSeenOnboarding) {
                return;
              }

              final nav = AppRouter.rootNavigatorKey.currentState;
              nav?.popUntil((route) => route.isFirst);
              if (state.status == AuthStatus.unauthenticated) {
                AppRouter.router.go(Routes.loginRoute);
              } else if (state.status == AuthStatus.authenticated) {
                AppRouter.router.go(Routes.routineRoute);
              }
            },
            child: MaterialApp.router(
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              title: AppStringsEn.appTitle,
              theme: AppTheme.light(),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        );
      },
    );
  }
}
