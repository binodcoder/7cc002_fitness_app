import 'package:flutter/material.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';

class UserAvatarAction extends StatelessWidget {
  const UserAvatarAction({super.key});

  @override
  Widget build(BuildContext context) {
    final session = sl<SessionManager>();
    final user = session.getCurrentUser();
    final email = user?.email ?? '';
    final String initials =
        email.isNotEmpty ? email.trim()[0].toUpperCase() : '';
    return IconButton(
      onPressed: () => AppRouter.router.push(Routes.account),
      icon: CircleAvatar(
        radius: 14,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        child: initials.isEmpty
            ? const Icon(Icons.person, size: 18)
            : Text(
                initials,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
      ),
      tooltip: 'Account',
    );
  }
}
