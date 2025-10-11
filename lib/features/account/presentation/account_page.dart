import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      backgroundColor: ColorManager.darkWhite,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        title: Text(strings.account),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(strings.account),
            subtitle: const Text('Manage your profile and preferences'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout_outlined, color: Colors.redAccent),
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

