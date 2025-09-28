import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitness_app/core/widgets/app_drawer_header.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_bloc.dart';
import 'package:fitness_app/features/auth/application/auth/auth_event.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  // final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    // Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Drawer(
        backgroundColor: ColorManager.white,
        child: ListView(
          children: [
            const AppDrawerHeader(),
            AppSlidableListTile(
              leading:
                  const Icon(Icons.chat_outlined, color: ColorManager.primary),
              title: strings.chat,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () async {
                // Close drawer first so back brings you here
                await Navigator.of(context).maybePop();
                if (!context.mounted) return;
                // Push so a back arrow appears
                AppRouter.router.push(Routes.chat);
              },
            ),
            AppSlidableListTile(
              leading:
                  const Icon(CupertinoIcons.alarm, color: ColorManager.primary),
              title: strings.titleRoutineLabel,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () {
                AppRouter.router.go(Routes.routineRoute);
              },
            ),
            AppSlidableListTile(
              leading: const Icon(CupertinoIcons.calendar,
                  color: ColorManager.primary),
              title: strings.titleAppointmentLabel,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () {
                AppRouter.router.go(Routes.calendar);
              },
            ),
            AppSlidableListTile(
              leading: const Icon(FontAwesomeIcons.personWalking,
                  color: ColorManager.primary),
              title: strings.walk,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () {
                AppRouter.router.go(Routes.walkList);
              },
            ),
            AppSlidableListTile(
              leading: const Icon(FontAwesomeIcons.towerBroadcast,
                  color: ColorManager.primary),
              title: strings.titleLiveTrainingLabel,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () {
                AppRouter.router.go(Routes.liveTraining);
              },
            ),
            AppSlidableListTile(
              leading: const Icon(CupertinoIcons.video_camera,
                  color: ColorManager.primary),
              title: strings.meeting,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
            ),
            AppSlidableListTile(
              leading: const Icon(Icons.logout_outlined,
                  color: ColorManager.primary),
              title: strings.logOut,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () async {
                // Close drawer first
                await Navigator.of(context).maybePop();
                if (!context.mounted) return;
                // Sign out via use case (handles Firebase or no-op for REST)
                context.read<AuthBloc>().add(const AuthLogoutRequested());
              },
            ),
            AppSlidableListTile(
              leading: const Icon(CupertinoIcons.building_2_fill,
                  color: ColorManager.primary),
              title: strings.aboutUs,
              titleStyle: getSemiBoldStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSize.s14,
              ),
              titleScaler: const TextScaler.linear(1.2),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
