import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTypography {
  const AppTypography._();

  static const String fontFamily = 'Montserrat';

  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
}

class FontConstants {
  const FontConstants._();
  static const String fontFamily = AppTypography.fontFamily;
}

class FontWeightManager {
  const FontWeightManager._();
  static const FontWeight light = AppTypography.light;
  static const FontWeight regular = AppTypography.regular;
  static const FontWeight medium = AppTypography.medium;
  static const FontWeight semiBold = AppTypography.semiBold;
  static const FontWeight bold = AppTypography.bold;
}

class FontSizeTokens {
  const FontSizeTokens._();

  static double get xs => 10.spMin;
  static const double sm = 12;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 18;
  static const double xxl = 20;
  static double get display => 30.spMin;
}

class FontSize {
  const FontSize._();

  static double s10 = 10.spMin;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static double s15 = 15.spMin;
  static const double s16 = 16.0;
  static const double s17 = 17.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static double s30 = 30.spMin;
}
