import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';

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
    return Scaffold(
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
            icon: const _ChatBadgeIcon(selected: false),
            selectedIcon: const _ChatBadgeIcon(selected: true),
            label: strings.chat,
          ),
        ],
      ),
    );
  }
}

class _ChatBadgeIcon extends StatelessWidget {
  const _ChatBadgeIcon({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final userId = sl<SessionManager>().getCurrentUser()?.id;
    final baseIcon = Icon(
      selected ? Icons.chat_bubble : Icons.chat_bubble_outline,
    );
    if (userId == null) return baseIcon;

    final stream = FirebaseFirestore.instance
        .collection('chatRooms')
        .where('unreadFor', arrayContains: userId)
        .snapshots();

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final hasUnread = (snapshot.data?.docs.length ?? 0) > 0;
        if (!hasUnread) return baseIcon;
        return Badge(
          child: baseIcon,
        );
      },
    );
  }
}
