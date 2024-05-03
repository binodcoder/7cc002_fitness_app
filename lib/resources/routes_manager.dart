import 'package:fitness_app/layers/presentation/login/ui/login_screen.dart';
import 'package:fitness_app/layers/presentation/register/ui/register_page.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import '../layers/presentation/onboarding/onboarding.dart';
import '../layers/presentation/routine/get_routines/ui/routine.dart';
import '../layers/presentation/splash/splash.dart';

class Routes {
  static const String splashRoute = "/";
  static const String onBoardingRoute = "/onboarding";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailRoute = "/storeDetails";
  static const String routineRoute = "/routine";
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
