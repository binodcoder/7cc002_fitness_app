import 'package:fitness_app/features/chat/chat_users_page.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/ui/walk_list_page.dart';
import 'package:fitness_app/app/home_scaffold.dart';
import 'package:fitness_app/features/account/presentation/account_page.dart';
import 'package:fitness_app/app/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:fitness_app/features/appointment/presentation/appointment_form/ui/appointment_form_dialog.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/appointment_details.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/calendar.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/ui/add_live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training_details.dart';
import 'package:fitness_app/features/auth/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/features/onboarding/pages/onboarding_screen.dart';
import 'package:fitness_app/features/auth/presentation/register/ui/register_page.dart';
import 'package:fitness_app/features/routine/presentation/routine_form/ui/routine_form_page.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine_details.dart';
import 'package:fitness_app/core/widgets/splash_screen.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
// App-wide router configuration using GoRouter.
import 'package:fitness_app/core/navigation/routes.dart';

// Route path constants are defined in core/navigation/routes.dart

class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'rootNavigator');

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splashRoute,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: Routes.onBoardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: Routes.loginRoute,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: Routes.registerRoute,
        builder: (context, state) => const RegisterPage(),
      ),
      // Bottom navigation shell with persistent state
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return HomeScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.routineRoute,
                builder: (context, state) => const RoutinePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.calendar,
                builder: (context, state) => const CalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.walkList,
                builder: (context, state) => const WalkListPage(),
              ),
            ],
          ),
        ],
      ),
      // Detail / dialog routes remain outside the shell
      GoRoute(
        path: Routes.liveTraining,
        builder: (context, state) => const LiveTrainingPage(),
      ),
      GoRoute(
        path: Routes.chat,
        builder: (context, state) => const ChatUsersPage(),
      ),
      GoRoute(
        path: Routes.mainMenu,
        builder: (context, state) => const MainMenuPage(),
      ),
      GoRoute(
        path: Routes.account,
        builder: (context, state) => const AccountPage(),
      ),
      GoRoute(
        path: Routes.routineDetails,
        builder: (context, state) => const RoutineDetailsPage(),
      ),
      GoRoute(
        path: Routes.addRoutine,
        builder: (context, state) => const RoutineFormPage(),
      ),
      GoRoute(
        path: Routes.liveTrainingDetails,
        builder: (context, state) => const LiveTrainingDetailsPage(),
      ),
      GoRoute(
        path: Routes.addLiveTraining,
        builder: (context, state) => const AddLiveTrainingDialog(),
      ),
      GoRoute(
        path: Routes.appointmentDetails,
        builder: (context, state) => const AppointmentDetailsPage(),
      ),
      GoRoute(
        path: Routes.addAppointment,
        builder: (context, state) => const AppointmentFormDialog(),
      ),
    ],
    errorBuilder: (context, state) => const _RouteNotFoundView(),
  );
}

class _RouteNotFoundView extends StatelessWidget {
  const _RouteNotFoundView();

  @override
  Widget build(BuildContext context) {
    final appStrings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.noRouteFound),
      ),
      body: Center(
        child: Text(appStrings.noRouteFound),
      ),
    );
  }
}
