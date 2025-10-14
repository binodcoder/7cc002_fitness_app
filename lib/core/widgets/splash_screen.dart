import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fitness_app/features/auth/domain/services/session_manager.dart';
import 'package:fitness_app/features/auth/domain/entities/user.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/core/assets/app_assets.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness_app/core/config/backend_config.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final SessionManager sessionManager = sl<SessionManager>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  void _goNext() async {
    final seen = sessionManager.hasSeenOnboarding();
    if (!seen) {
      if (!mounted) return;
      context.go(Routes.onBoardingRoute);
      return;
    }
    // If using Firebase backend, send unauthenticated users to login
    if (BackendConfig.isFirebase) {
      final current = fb.FirebaseAuth.instance.currentUser;
      if (current == null) {
        if (!mounted) return;
        context.go(Routes.loginRoute);
        return;
      }
    } else if (BackendConfig.isFake) {
      final cachedUser = sessionManager.getCurrentUser();
      if (cachedUser == null) {
        const demoUser = User(
          id: 1,
          email: 'demo@fit.com',
          password: '',
          role: 'trainer',
        );
        await sessionManager.persistUser(demoUser);
      }
    } else {
      final loggedIn = await sessionManager.isLoggedIn();
      if (!loggedIn) {
        if (!mounted) return;
        context.go(Routes.loginRoute);
        return;
      }
    }
    if (!mounted) return;
    context.go(Routes.routineRoute);
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
