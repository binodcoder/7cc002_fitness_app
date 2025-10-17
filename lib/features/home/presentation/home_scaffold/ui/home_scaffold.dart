import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/home/presentation/home_scaffold/cubit/home_scaffold_cubit.dart';
import 'package:fitness_app/features/home/presentation/home_scaffold/widgets/chat_badge_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // If tapping the current tab, pop to initial location
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return BlocProvider(
      create: (_) => sl<HomeScaffoldCubit>()..startListening(),
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          indicatorColor: ColorManager.primary.withAlpha(84),
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: const Icon(Icons.home),
              selectedIcon: const Icon(Icons.home),
              label: strings.titleRoutineLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.calendar_today_outlined),
              selectedIcon: const Icon(Icons.calendar_today),
              label: strings.titleAppointmentLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.directions_walk_outlined),
              selectedIcon: const Icon(Icons.directions_walk),
              label: strings.walk,
            ),
            NavigationDestination(
              icon: const ChatBadgeIcon(selected: false),
              selectedIcon: const ChatBadgeIcon(selected: true),
              label: strings.chat,
            ),
          ],
        ),
      ),
    );
  }
}
