import 'package:fitness_app/features/live_training/presentation/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'features/appointment/presentation/get_appointments/ui/calendar.dart';
import 'features/chat/chat_page.dart';
import 'features/login/presentation/ui/login_screen.dart';
import 'features/routine/presentation/get_routines/ui/routine.dart';
import 'features/walk/presentation/walk_list/ui/walk_list_page.dart';
import 'package:fitness_app/core/widgets/app_drawer_header.dart';
import 'package:fitness_app/core/widgets/app_slidable_list_tile.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const ChatPage(),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RoutinePage(),
                  ),
                );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const CalendarPage(),
                  ),
                );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const WalkListPage(),
                        ),
                      );
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LiveTrainingPage(),
                  ),
                );
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
              onTap: () {
                sharedPreferences.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LoginPage(),
                    fullscreenDialog: true,
                  ),
                );
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
