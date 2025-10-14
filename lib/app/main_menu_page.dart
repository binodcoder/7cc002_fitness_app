import 'package:flutter/material.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/widgets/app_list_tile.dart';

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
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(strings.menu),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        children: [
          AppListTile(
            leading: const Icon(Icons.live_tv_outlined),
            title: strings.titleLiveTrainingLabel,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _go(context, Routes.liveTraining),
          ),
        ],
      ),
    );
  }
}
