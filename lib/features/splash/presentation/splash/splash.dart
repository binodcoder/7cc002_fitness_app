import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/assets/app_assets.dart';
import 'package:fitness_app/core/navigation/app_router.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() {
    sharedPreferences.getBool("login") == null
        ? Navigator.pushReplacementNamed(context, Routes.onBoardingRoute)
        : Navigator.pushNamed(context, Routes.routineRoute);
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Center(
        child: Image.asset(ImageAssets.splashLogo),
      ),
    );
  }
}
