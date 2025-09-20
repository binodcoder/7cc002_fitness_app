import 'package:fitness_app/layers/presentation/live_training/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/layers/presentation/localization/app_strings.dart';
import 'package:fitness_app/layers/presentation/theme/colour_manager.dart';
import 'package:fitness_app/layers/presentation/theme/font_manager.dart';
import 'package:fitness_app/layers/presentation/theme/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'layers/presentation/appointment/get_appointments/ui/calender.dart';
import 'layers/presentation/login/ui/login_screen.dart';
import 'layers/presentation/routine/get_routines/ui/routine.dart';
import 'layers/presentation/walk/get_walks/ui/walk.dart';

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
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                accountEmail: Text(
                  'binodcoder@wlv.ac.uk',
                  style: getRegularStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                  ),
                ),
                margin: EdgeInsets.zero,
                accountName: Text(
                  'Binod Bhandari',
                  maxLines: 2,
                  style: getBoldStyle(
                    color: ColorManager.white,
                    fontSize: FontSize.s12,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/image.jpg')),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorManager.white,
                      ColorManager.primary,
                      ColorManager.primary,
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.alarm,
                color: ColorManager.primary,
              ),
              title: Text(
                strings.titleRoutineLabel,
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const RoutinePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.calendar,
                color: ColorManager.primary,
              ),
              title: Text(
                strings.titleAppointmentLabel,
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
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
                : ListTile(
                    leading: Icon(
                      FontAwesomeIcons.personWalking,
                      color: ColorManager.primary,
                    ),
                    title: Text(
                      strings.walk,
                      textScaleFactor: 1.2,
                      style: getSemiBoldStyle(
                        color: ColorManager.darkGrey,
                        fontSize: FontSize.s14,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const WalkPage(),
                        ),
                      );
                    },
                  ),
            ListTile(
              leading: Icon(
                FontAwesomeIcons.towerBroadcast,
                color: ColorManager.primary,
              ),
              title: Text(
                strings.titleLiveTrainingLabel,
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const LiveTrainingPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.video_camera,
                color: ColorManager.primary,
              ),
              title: Text(
                "Meeting",
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
              // onTap: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (BuildContext context) => CallPage(),
              //     ),
              //   );
              // },
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color: ColorManager.primary,
              ),
              title: Text(
                "Log out",
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
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
            ListTile(
              leading: Icon(
                CupertinoIcons.building_2_fill,
                color: ColorManager.primary,
              ),
              title: Text(
                "About Us",
                textScaleFactor: 1.2,
                style: getSemiBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s14,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
