import 'package:flutter/material.dart';

import 'package:fitness_app/features/appointment/presentation/add_update_appointment/ui/add_appointment.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/appointment_details.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/calender.dart';
import 'package:fitness_app/features/live_training/presentation/add_update_live_training/ui/add_live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training_details.dart';
import 'package:fitness_app/features/login/presentation/ui/login_screen.dart';
import 'package:fitness_app/features/onboarding/pages/onboarding_screen.dart';
import 'package:fitness_app/features/register/presentation/ui/register_page.dart';
import 'package:fitness_app/features/routine/presentation/add_update_routine/ui/add_routine_page.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine.dart';
import 'package:fitness_app/features/routine/presentation/get_routines/ui/routine_details.dart';
import 'package:fitness_app/core/widgets/splash_screen.dart';
import '../localization/app_strings.dart';

class Routes {
  const Routes._();

  static const String splashRoute = '/';
  static const String onBoardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String forgotPasswordRoute = '/forgotPassword';
  static const String mainRoute = '/main';
  static const String routineRoute = '/routine';
  static const String routineDetails = '/routineDetails';
  static const String addRoutine = '/addRoutine';
  static const String liveTraining = '/liveTraining';
  static const String liveTrainingDetails = '/liveTrainingDetails';
  static const String addLiveTraining = '/addLiveTraining';
  static const String call = '/call';
  static const String calendar = '/calendar';
  static const String appointmentDetails = '/appointmentDetails';
  static const String addAppointment = '/addAppointment';
}

class AppRouter {
  const AppRouter._();

  static final Map<String, WidgetBuilder> _routeTable = <String, WidgetBuilder>{
    Routes.splashRoute: (_) => const SplashScreen(),
    Routes.onBoardingRoute: (_) => const OnboardingScreen(),
    Routes.loginRoute: (_) => const LoginPage(),
    Routes.registerRoute: (_) => const RegisterPage(),
    Routes.routineRoute: (_) => const RoutinePage(),
    Routes.routineDetails: (_) => const RoutineDetailsPage(),
    Routes.addRoutine: (_) => const AddRoutinePage(),
    Routes.liveTraining: (_) => const LiveTrainingPage(),
    Routes.liveTrainingDetails: (_) => const LiveTrainingDetailsPage(),
    Routes.addLiveTraining: (_) => const AddLiveTrainingDialog(),
    Routes.calendar: (_) => const CalendarPage(),
    Routes.appointmentDetails: (_) => const AppointmentDetailsPage(),
    Routes.addAppointment: (_) => const AddAppointmentDialog(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = _routeTable[settings.name];
    if (builder != null) {
      return MaterialPageRoute<dynamic>(
        builder: builder,
        settings: settings,
      );
    }
    return unknownRoute(settings);
  }

  static Route<dynamic> unknownRoute([RouteSettings? settings]) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => const _RouteNotFoundView(),
      settings: settings,
    );
  }
}

class RouteGenerator {
  const RouteGenerator._();

  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    return AppRouter.onGenerateRoute(routeSettings);
  }

  static Route<dynamic> unDefinedRoute() {
    return AppRouter.unknownRoute(const RouteSettings(name: 'unknown'));
  }
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
