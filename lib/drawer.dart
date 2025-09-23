import 'package:fitness_app/features/live_training/presentation/live_training/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'features/appointment/presentation/appointment/get_appointments/ui/calender.dart';
import 'features/login/presentation/login/ui/login_screen.dart';
import 'features/routine/presentation/routine/get_routines/ui/routine.dart';
import 'features/walk/presentation/walk/get_walks/ui/walk.dart';
import 'package:fitness_app/widgets/app_drawer_header.dart';
import 'package:fitness_app/widgets/drawer_nav_tile.dart';

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
            DrawerNavTile(
              icon: CupertinoIcons.alarm,
              title: strings.titleRoutineLabel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RoutinePage(),
                  ),
                );
              },
            ),
            DrawerNavTile(
              icon: CupertinoIcons.calendar,
              title: strings.titleAppointmentLabel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const CalendarPage(),
                  ),
                );
              },
            ),
            sharedPreferences.getString('institutionEmail') == null ||
                    sharedPreferences.getString('institutionEmail') == ""
                ? const SizedBox()
                : DrawerNavTile(
                    icon: FontAwesomeIcons.personWalking,
                    title: strings.walk,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const WalkPage(),
                        ),
                      );
                    },
                  ),
            DrawerNavTile(
              icon: FontAwesomeIcons.towerBroadcast,
              title: strings.titleLiveTrainingLabel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LiveTrainingPage(),
                  ),
                );
              },
            ),
            const DrawerNavTile(
              icon: CupertinoIcons.video_camera,
              title: 'Meeting',
            ),
            DrawerNavTile(
              icon: Icons.logout_outlined,
              title: 'Log out',
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
            DrawerNavTile(
              icon: CupertinoIcons.building_2_fill,
              title: 'About Us',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
