import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(strings.account)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(strings.account),
            subtitle: const Text('Manage your profile and preferences'),
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: const Text('Profile'),
            subtitle: const Text('View and update your profile'),
            onTap: () => context.push(Routes.profile),
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            subtitle: const Text('Units, notifications, and more'),
            onTap: () => context.push(Routes.settings),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: scheme.error),
            title: Text(strings.logOut),
            onTap: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}
