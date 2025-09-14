import 'package:fitness_app/layers/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/layers/presentation/register/ui/register_page.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../layers/presentation/appointment/add_update_appointment/ui/add_appointment.dart';
import '../layers/presentation/appointment/get_appointments/ui/appointment_details.dart';
import '../layers/presentation/appointment/get_appointments/ui/calender.dart';
import '../layers/presentation/live_training/add_update_live_training/ui/add_live_training.dart';
import '../layers/presentation/live_training/get_live_trainings/ui/live_training.dart';
import '../layers/presentation/live_training/get_live_trainings/ui/live_training_details.dart';
import '../layers/presentation/onboarding/onboarding.dart';
import '../layers/presentation/routine/add_update_routine/ui/add_routine_page.dart';
import '../layers/presentation/routine/get_routines/ui/routine.dart';
import '../layers/presentation/routine/get_routines/ui/routine_details.dart';
import '../layers/presentation/splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onboarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String routineRoute = "/routine";
  static const String routineDetails = "/routineDetails";
  static const String addRoutine = "/addRoutine";
  static const String liveTraining = "/liveTraining";
  static const String liveTrainingDetails = "/liveTrainingDetails";
  static const String addLiveTraining = "/addLiveTraining";
  static const String call = "/call";
  static const String calendar = "/calendar";
  static const String appointmentDetails = "/appointmentDetails";
  static const String addAppointment = "/addAppointment";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.routineRoute:
        return MaterialPageRoute(builder: (context) => const RoutinePage());
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (context) => const OnBoardingView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case Routes.registerRoute:
        return MaterialPageRoute(builder: (context) => const RegisterPage());
      case Routes.addRoutine:
        return MaterialPageRoute(builder: (context) => const AddRoutinePage());
      case Routes.liveTraining:
        return MaterialPageRoute(
            builder: (context) => const LiveTrainingPage());
      case Routes.liveTrainingDetails:
        return MaterialPageRoute(
            builder: (context) => const LiveTrainingDetailsPage());
      case Routes.addLiveTraining:
        return MaterialPageRoute(
            builder: (context) => const AddLiveTrainingDialog());
      // case Routes.call:
      //   return MaterialPageRoute(builder: (context) => CallPage());
      case Routes.calendar:
        return MaterialPageRoute(builder: (context) => const CalendarPage());
      case Routes.appointmentDetails:
        return MaterialPageRoute(
            builder: (context) => const AppointmentDetailsPage());
      case Routes.addAppointment:
        return MaterialPageRoute(
            builder: (context) => const AddAppointmentDialog());
      case Routes.routineDetails:
        return MaterialPageRoute(
            builder: (context) => const RoutineDetailsPage());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text(
              AppStrings.noRouteFound,
            ),
          ),
          body: const Center(
            child: Text(AppStrings.noRouteFound),
          )),
    );
  }
}
