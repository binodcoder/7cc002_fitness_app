import 'package:flutter/material.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';

class MainMenuButton extends StatelessWidget {
  const MainMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Menu',
      onPressed: () => AppRouter.router.push(Routes.mainMenu),
    );
  }
}
