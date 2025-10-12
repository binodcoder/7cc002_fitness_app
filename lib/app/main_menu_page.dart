import 'package:flutter/material.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({super.key});

  void _go(BuildContext context, String route) {
    // Pop the menu, ensure base is Home, then push destination
    AppRouter.rootNavigatorKey.currentState?.pop();
    AppRouter.router.go(Routes.routineRoute);
    Future.microtask(() => AppRouter.router.push(route));
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return Scaffold(
      backgroundColor: ColorManager.darkWhite,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(strings.menu),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.live_tv_outlined),
            title: Text(strings.titleLiveTrainingLabel),
            onTap: () => _go(context, Routes.liveTraining),
            trailing: const Icon(Icons.chevron_right),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.chat_outlined),
            title: Text(strings.chat),
            onTap: () => _go(context, Routes.chat),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
