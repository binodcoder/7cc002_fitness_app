import 'package:flutter/material.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/theme/font_manager.dart';
import 'package:fitness_app/core/theme/styles_manager.dart';

class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({
    super.key,
    this.name = 'Binod Bhandari',
    this.email = 'binodcoder@wlv.ac.uk',
    this.imageAssetPath = 'assets/images/image.jpg',
  });

  final String name;
  final String email;
  final String imageAssetPath;

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.zero,
      child: UserAccountsDrawerHeader(
        accountEmail: Text(
          email,
          style: getRegularStyle(
            color: ColorManager.white,
            fontSize: FontSize.s12,
          ),
        ),
        margin: EdgeInsets.zero,
        accountName: Text(
          name,
          maxLines: 2,
          style: getBoldStyle(
            color: ColorManager.white,
            fontSize: FontSize.s12,
          ),
        ),
        currentAccountPicture:
            CircleAvatar(backgroundImage: AssetImage(imageAssetPath)),
        decoration: const BoxDecoration(
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
    );
  }
}
