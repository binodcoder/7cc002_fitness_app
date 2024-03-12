import 'package:fitness_app/features/calender/presentation/calender.dart';
import 'package:fitness_app/features/call/call_page.dart';
import 'package:fitness_app/resources/colour_manager.dart';
import 'package:fitness_app/resources/font_manager.dart';
import 'package:fitness_app/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

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
              CupertinoIcons.calendar,
              color: ColorManager.darkGrey,
            ),
            title: Text(
              "Calendar",
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
            onTap: () {},
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
