import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';
import 'package:fitness_app/core/widgets/app_list_tile.dart';
import 'package:fitness_app/features/walk/presentation/walk_list/ui/my_walks_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final scheme = Theme.of(context).colorScheme;
    final prefs = sl<SharedPreferences>();
    final role = (prefs.getString('role') ?? 'standard').trim();

    return Scaffold(
      appBar: AppBar(title: Text(strings.account)),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        children: [
          AppListTile(
            leading: const Icon(Icons.person),
            title: strings.account,
            subtitle: 'Manage your profile and preferences',
          ),
          if (role == 'admin')
            AppListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: 'Admin Dashboard',
              subtitle: 'Manage users and view all data',
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(Routes.admin),
            ),
          AppListTile(
            leading: const Icon(Icons.badge_outlined),
            title: 'Profile',
            subtitle: 'View and update your profile',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.profile),
          ),
          AppListTile(
            leading: const Icon(Icons.directions_walk_outlined),
            title: 'My Walks',
            subtitle: 'Create, edit, and delete your walks',
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyWalksPage(),
                  fullscreenDialog: true,
                ),
              );
            },
          ),
          AppListTile(
            leading: const Icon(Icons.settings_outlined),
            title: 'Settings',
            subtitle: 'Units, notifications, and more',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.settings),
          ),
          AppListTile(
            leading: Icon(Icons.logout_outlined, color: scheme.error),
            title: strings.logOut,
            trailing: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            onTap: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
    );
  }
}
