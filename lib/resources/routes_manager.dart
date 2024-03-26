import 'package:fitness_app/resources/strings_manager.dart';
import 'package:flutter/material.dart';

import '../layers/presentation_layer/routine/ui/routine.dart';

class Routes {
  static const String homeRoute = "/";
  static const String onBordingRoute = "/home";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
          appBar: AppBar(title: const Text(AppStrings.noRouteFound)),
          body: const Center(
            child: Text(AppStrings.noRouteFound),
          )),
    );
  }
}
