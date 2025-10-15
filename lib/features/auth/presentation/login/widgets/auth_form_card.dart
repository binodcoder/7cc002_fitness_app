import 'package:flutter/material.dart';

import 'package:fitness_app/core/theme/values_manager.dart';

class AuthFormCard extends StatelessWidget {
  const AuthFormCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(
          Radius.circular(AppRadius.r25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppWidth.w20),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppWidth.w20,
            vertical: AppHeight.h20,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
          child: child,
        ),
      ),
    );
  }
}

