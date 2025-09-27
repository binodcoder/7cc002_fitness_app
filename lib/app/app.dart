import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/theme/app_theme.dart';
import 'package:fitness_app/l10n/app_localizations.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/auth/presentation/auth/bloc/auth_bloc.dart';
import 'package:fitness_app/features/auth/presentation/auth/bloc/auth_state.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>(),
          child: BlocListener<AuthBloc, AuthState>(
            listenWhen: (prev, curr) => curr is AuthActionState,
            listener: (context, state) async {
              if (state is AuthLoggedOutActionState) {
                // Clear session while preserving onboarding flag
                final prefs = sl<SharedPreferences>();
                final seen = prefs.getBool('seen_onboarding') ?? false;
                await prefs.clear();
                if (seen) {
                  await prefs.setBool('seen_onboarding', true);
                }
                // Close any imperatively pushed routes first
                final nav = AppRouter.rootNavigatorKey.currentState;
                nav?.popUntil((route) => route.isFirst);
                // Navigate using router instance (listener is above router context)
                AppRouter.router.go(Routes.loginRoute);
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
