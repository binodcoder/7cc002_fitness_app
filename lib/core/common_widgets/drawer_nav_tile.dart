import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';

class DrawerNavTile extends StatelessWidget {
  const DrawerNavTile({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    this.iconColor = ColorManager.primary,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        textScaler: const TextScaler.linear(1.2),
        style: getSemiBoldStyle(
          color: ColorManager.darkGrey,
          fontSize: FontSize.s14,
        ),
      ),
      onTap: onTap,
    );
  }
}
