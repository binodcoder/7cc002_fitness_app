import 'package:flutter/material.dart';

/// Central colour palette for the application.
class AppColors {
  const AppColors._();

  // Realistic, modern palette tuned for a fitness app
  // Primary = healthy green, Secondary = calm blue
  static const Color primary = Color(0xFF16A34A); // green-600
  static const Color darkPrimary = Color(0xFF15803D); // green-700
  static const Color primaryOpacity70 =
      Color(0xB316A34A); // 70% alpha of primary

  static const Color secondary = Color(0xFF2563EB); // blue-600
  static const Color primaryContainer = Color(0xFF22C55E); // green-500
  static const Color secondaryContainer = Color(0xFF93C5FD); // blue-300

  // Neutrals
  static const Color darkGrey = Color(0xFF374151); // gray-700
  static const Color grey = Color(0xFF6B7280); // gray-500
  static const Color lightGrey = Color(0xFF9CA3AF); // gray-400
  static const Color grey1 = Color(0xFF707070);
  static const Color grey2 = Color(0xFF797979);
  static const Color grey3 = Color(0xFFE5E7EB); // gray-200

  static const Color white = Color(0xFFFFFFFF);
  static const Color darkWhite = Color(0xFFF3F4F6); // gray-100
  static const Color redWhite = Color(0xFFF3F3F4);
  static const Color brownWhite = Color(0xFFF6F6F6);

  static const Color black = Color(0xFF000000);
  static const Color darkBlack = Color(0xFF111827); // gray-900
  static const Color blackOpacity87 = Color(0xDE000000);
  static const Color blackOpacity54 = Color(0x8A000000);
  static const Color blackOpacity38 = Color(0x61000000);
  static const Color shadow = blackOpacity38;

  // Legacy accents kept for completeness
  static const Color blue = Color(0xFF2563EB);
  static const Color lightBlue = Color(0xFF60A5FA);
  static const Color blueBright = Color(0xFF3B82F6);
  static const Color blueGrey = Color(0xFFE5E7EB);
  static const Color middleBlue = Color(0xFF93C5FD);

  static const Color orange = Color(0xFFF59E0B);
  static const Color fadeYellow = Color(0xFFFEFCE8);
  static const Color purpleLight = Color(0xFFE9D5FF);
  static const Color darkPurple = Color(0xFF6D28D9);
  static const Color deepPurple = Color(0xFF8B5CF6);
  static const Color cadiumBlue = Color(0xFF085593);

  static const Color red = Color(0xFFDC2626); // red-600
  static const Color redAccent = Color(0xFFEF4444); // red-500
  static const Color error = red;
  static const Color warning = Color(0xFFFDE68A); // amber-300
  static const Color success = primary; // success aligns with primary
  static const Color green = Color(0xFF22C55E); // green-500
  static const Color darkGreen = Color(0xFF16A34A); // green-600
  static const Color lightGreen = Color(0xFFD1FAE5); // emerald-100
  static const Color shiningGreen = Color(0xFF86EFAC); // green-300

  static const Color surface = white;
  static const Color surfaceVariant = grey3;
  static const Color background = Color(0xFFF8FAFC); // slate-50
  static const Color scaffold = white;

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
