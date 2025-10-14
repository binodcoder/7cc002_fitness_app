import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fitness_app/core/theme/values_manager.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../application/settings_cubit.dart';
import '../application/settings_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingsCubit(sl<SharedPreferences>())..load(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppWidth.w30),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final cubit = context.read<SettingsCubit>();
                final textTheme = Theme.of(context).textTheme;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppHeight.h20),
                    Text('Units & Region', style: textTheme.titleLarge),
                    SizedBox(height: AppHeight.h10),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              decoration:
                                  const InputDecoration(labelText: 'Distance'),
                              value: state.distanceUnit,
                              items: const [
                                DropdownMenuItem(
                                    value: 'km',
                                    child: Text('Kilometers (km)')),
                                DropdownMenuItem(
                                    value: 'mi', child: Text('Miles (mi)')),
                              ],
                              onChanged: (v) =>
                                  v != null ? cubit.setDistanceUnit(v) : null,
                            ),
                            const SizedBox(height: 12),
                            DropdownButtonFormField<String>(
                              decoration:
                                  const InputDecoration(labelText: 'Weight'),
                              value: state.weightUnit,
                              items: const [
                                DropdownMenuItem(
                                    value: 'kg', child: Text('Kilograms (kg)')),
                                DropdownMenuItem(
                                    value: 'lb', child: Text('Pounds (lb)')),
                              ],
                              onChanged: (v) =>
                                  v != null ? cubit.setWeightUnit(v) : null,
                            ),
                            const SizedBox(height: 12),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('24-hour time'),
                              value: state.time24h,
                              onChanged: cubit.setTime24h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: AppHeight.h20),
                    Text('Notifications', style: textTheme.titleLarge),
                    SizedBox(height: AppHeight.h10),
                    Card(
                      child: SwitchListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 12.0),
                        title: const Text('Push notifications'),
                        value: state.pushEnabled,
                        onChanged: cubit.setPushEnabled,
                      ),
                    ),
                    SizedBox(height: AppHeight.h20),
                    Text('About', style: textTheme.titleLarge),
                    SizedBox(height: AppHeight.h10),
                    Card(
                      child: Column(
                        children: const [
                          ListTile(
                            leading: Icon(Icons.privacy_tip_outlined),
                            title: Text('Privacy policy'),
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Icon(Icons.description_outlined),
                            title: Text('Terms of service'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppHeight.h20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
