import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/widgets/app_list_tile.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // final strings = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 12),
        children: [
          const AppListTile(
            leading: Icon(Icons.admin_panel_settings_outlined),
            title: 'Administration',
            subtitle: 'Manage users and monitor activities',
          ),
          AppListTile(
            leading: const Icon(Icons.badge_outlined),
            title: 'Manage Users',
            subtitle: 'Assign roles (standard, trainer, admin)',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(Routes.adminManageUsers),
          ),
        ],
      ),
    );
  }
}
