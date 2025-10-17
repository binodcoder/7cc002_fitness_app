import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/admin/presentation/cubit/admin_cubit.dart';
import 'package:fitness_app/features/admin/presentation/cubit/admin_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminManageUsersPage extends StatefulWidget {
  const AdminManageUsersPage({super.key});

  @override
  State<AdminManageUsersPage> createState() => _AdminManageUsersPageState();
}

class _AdminManageUsersPageState extends State<AdminManageUsersPage> {
  final _roles = const ['standard', 'trainer', 'admin'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminCubit>()..startListening(),
      child: Scaffold(
          appBar: AppBar(title: const Text('Manage Users')),
          body: BlocBuilder<AdminCubit, AdminState>(
            builder: (context, state) {
              if (state is AdminLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminLoadedState) {
                final users = state.users;
                return ListView.separated(
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, i) {
                    final title = (users[i].name as String?) ?? '';
                    final email = (users[i].email as String?) ?? '';
                    final currentRole =
                        (users[i].role as String?) ?? 'standard';
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(title),
                      subtitle: Text(email),
                      trailing: DropdownButton<String>(
                        value: currentRole,
                        items: _roles
                            .map((r) => DropdownMenuItem(
                                  value: r,
                                  child:
                                      Text(r[0].toUpperCase() + r.substring(1)),
                                ))
                            .toList(),
                        onChanged: (val) async {
                          if (val == null) return;
                          try {
                            //todo: call updateUser method of cubit
                            await context.read<AdminCubit>().updateUser(
                                  users[i].id!,
                                  val,
                                );
                            // if (mounted) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //         content: Text('Updated role to "$val"')),
                            //   );
                            // }
                          } catch (e) {
                            // if (mounted) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //         content: Text(
                            //             'Failed to update role: ${e.toString()}')),
                            //   );
                            // }
                          }
                        },
                      ),
                    );
                  },
                );
              } else if (state is AdminErrorState) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          )),
    );
  }
}
