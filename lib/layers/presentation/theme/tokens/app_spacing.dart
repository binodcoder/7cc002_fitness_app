import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  const AppSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
}

class AppRadiusTokens {
  const AppRadiusTokens._();

  static BorderRadius get sm => BorderRadius.circular(8.r);
  static BorderRadius get md => BorderRadius.circular(12.r);
  static BorderRadius get lg => BorderRadius.circular(16.r);
}

class AppSizeTokens {
  const AppSizeTokens._();

  static const double elevation = 4;
}
