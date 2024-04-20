import 'package:fitness_app/layers/presentation/live_training/get_live_trainings/ui/live_training.dart';
import 'package:fitness_app/resources/colour_manager.dart';
import 'package:fitness_app/resources/font_manager.dart';
import 'package:fitness_app/resources/strings_manager.dart';
import 'package:fitness_app/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection_container.dart';
import 'layers/presentation/appointment/get_appointments/ui/calender.dart';
import 'layers/presentation/call/call_page.dart';
import 'layers/presentation/login/ui/login_screen.dart';
import 'layers/presentation/routine/get_routines/ui/routine.dart';
import 'layers/presentation/walk/get_walks/ui/walk.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  static SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: ColorManager.darkGrey,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarColor: ColorManager.darkGrey.withOpacity(0.9),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        SystemChrome.setSystemUIOverlayStyle(overlayStyle);
        initial();
      },
    );
  }

  final SharedPreferences sharedPreferences = sl<SharedPreferences>();
  void initial() async {}

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    // Size size = MediaQuery.of(context).size;
    return Drawer(
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
              currentAccountPicture: const CircleAvatar(backgroundImage: AssetImage('assets/images/image.jpg')),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorManager.darkGrey,
                    ColorManager.darkGrey,
                  ],
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.alarm,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              AppStrings.titleRoutineLabel,
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
              color: ColorManager.darkGrey,
            ),
            title: Text(
              AppStrings.titleAppointmentLabel,
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
          ListTile(
            leading: Icon(
              CupertinoIcons.alarm,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              "Walk",
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
              CupertinoIcons.alarm,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              "Live Trainings",
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
              color: ColorManager.darkGrey,
            ),
            title: const Text(
              "Meeting",
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const CallPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: ColorManager.darkGrey,
            ),
            title: const Text(
              "Log out",
              style: TextStyle(
                color: Colors.black,
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
              color: ColorManager.darkGrey,
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
    );
  }

  void logout() {}
}
