import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/core/assets/app_assets.dart';
import 'package:fitness_app/core/navigation/app_router.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  _goNext() {
    final seen = sharedPreferences.getBool('seen_onboarding') == true;
    if (!seen) {
      Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
      return;
    }
    // Fake login/session defaults for demo mode
    sharedPreferences.setBool('login', true);
    sharedPreferences.setInt('user_id', sharedPreferences.getInt('user_id') ?? 1);
    sharedPreferences.setString('role', sharedPreferences.getString('role') ?? 'trainer');
    sharedPreferences.setString('institutionEmail',
        sharedPreferences.getString('institutionEmail') ?? 'demo@fit.com');
    Navigator.pushReplacementNamed(context, Routes.routineRoute);
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

