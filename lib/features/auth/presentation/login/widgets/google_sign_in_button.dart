import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';
import 'package:fitness_app/core/theme/values_manager.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: const FaIcon(
        FontAwesomeIcons.google,
        size: 20,
        color: Color(0xFF4285F4),
      ),
      label: Text(
        'Google',
        style: getRegularStyle(
          fontSize: FontSize.s16,
          color: const Color(0xFF3C4043),
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFDADCE0)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(
          vertical: AppHeight.h10,
          horizontal: AppWidth.w20,
        ),
        minimumSize: Size(double.infinity, AppHeight.h30),
      ),
      onPressed: onPressed,
    );
  }
}
