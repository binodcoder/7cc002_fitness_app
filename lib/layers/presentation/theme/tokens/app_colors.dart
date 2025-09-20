import 'package:flutter/material.dart';

/// Central colour palette for the application.
class AppColors {
  const AppColors._();

  static const Color primary = Color(0xFFED9728);
  static const Color darkPrimary = Color(0xFFD17D11);
  static const Color primaryOpacity70 = Color(0xB39E9E9E);

  static const Color secondary = Color(0xFF5C3FBC);
  static const Color primaryContainer = Color(0xFFF57224);
  static const Color secondaryContainer = Color(0xFF59BED4);

  static const Color darkGrey = Color(0xFF525252);
  static const Color grey = Color(0xFF737477);
  static const Color lightGrey = Color(0xFF9E9E9E);
  static const Color grey1 = Color(0xFF707070);
  static const Color grey2 = Color(0xFF797979);
  static const Color grey3 = Color(0xFFD3D3D3);

  static const Color white = Color(0xFFFFFFFF);
  static const Color darkWhite = Color(0xFFE6E6E6);
  static const Color redWhite = Color(0xFFF3F3F4);
  static const Color brownWhite = Color(0xFFF6F6F6);

  static const Color black = Color(0xFF000000);
  static const Color darkBlack = Color(0xFF262626);
  static const Color blackOpacity87 = Color(0xDE000000);
  static const Color blackOpacity54 = Color(0x8A000000);
  static const Color blackOpacity38 = Color(0x61000000);
  static const Color shadow = blackOpacity38;

  static const Color blue = Color(0xFF0074E3);
  static const Color lightBlue = Color(0xFF23C6C8);
  static const Color blueBright = Color(0xFF0096FF);
  static const Color blueGrey = Color(0xFFECEFF1);
  static const Color middleBlue = Color(0xFF59BED4);

  static const Color orange = Color(0xFFF57224);
  static const Color fadeYellow = Color(0xFFF9F8F2);
  static const Color purpleLight = Color(0xFFFF00E5);
  static const Color darkPurple = Color(0xFF240046);
  static const Color deepPurple = Color(0xFF8A2BE2);
  static const Color cadiumBlue = Color(0xFF085593);

  static const Color red = Color(0xFFFF0000);
  static const Color redAccent = Color(0xFFED5565);
  static const Color error = Color(0xFFE61F34);
  static const Color warning = Color(0xFFFFD6CC);
  static const Color success = Color(0xFF198754);
  static const Color green = Color(0xFF00C897);
  static const Color darkGreen = Color(0xFF09B44D);
  static const Color lightGreen = Color(0xFFD0F1DD);
  static const Color shiningGreen = Color(0xFF7AF176);

  static const Color surface = white;
  static const Color surfaceVariant = grey3;
  static const Color background = brownWhite;
  static const Color scaffold = fadeYellow;

  static const Color onPrimary = white;
  static const Color onPrimaryContainer = darkBlack;
  static const Color onSecondary = white;
  static const Color onSecondaryContainer = darkBlack;
  static const Color onSurface = darkGrey;
  static const Color onSurfaceVariant = grey;
  static const Color onBackground = darkBlack;
  static const Color outline = grey1;
  static const Color outlineVariant = grey3;
}

/// Backwards compatible alias for existing usages.
typedef ColorManager = AppColors;
