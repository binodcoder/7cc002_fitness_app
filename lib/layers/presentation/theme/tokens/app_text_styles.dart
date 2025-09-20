import 'package:flutter/material.dart';

import 'app_typography.dart';

TextStyle _textStyle(
  double fontSize,
  FontWeight fontWeight,
  Color color,
) {
  return TextStyle(
    fontSize: fontSize,
    fontFamily: AppTypography.fontFamily,
    fontWeight: fontWeight,
    color: color,
  );
}

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle regular({required double fontSize, required Color color}) {
    return _textStyle(fontSize, AppTypography.regular, color);
  }

  static TextStyle medium({required double fontSize, required Color color}) {
    return _textStyle(fontSize, AppTypography.medium, color);
  }

  static TextStyle semiBold({required double fontSize, required Color color}) {
    return _textStyle(fontSize, AppTypography.semiBold, color);
  }

  static TextStyle bold({required double fontSize, required Color color}) {
    return _textStyle(fontSize, AppTypography.bold, color);
  }

  static TextStyle light({required double fontSize, required Color color}) {
    return _textStyle(fontSize, AppTypography.light, color);
  }
}
