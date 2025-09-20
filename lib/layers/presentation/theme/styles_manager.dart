import 'package:flutter/material.dart';

import 'tokens/app_text_styles.dart';
import 'tokens/layout_tokens.dart';

TextStyle getRegularStyle(
    {double fontSize = AppSize.s12, required Color color}) {
  return AppTextStyles.regular(fontSize: fontSize, color: color);
}

TextStyle getLightStyle({double fontSize = AppSize.s12, required Color color}) {
  return AppTextStyles.light(fontSize: fontSize, color: color);
}

TextStyle getBoldStyle({double fontSize = AppSize.s12, required Color color}) {
  return AppTextStyles.bold(fontSize: fontSize, color: color);
}

TextStyle getSemiBoldStyle(
    {double fontSize = AppSize.s12, required Color color}) {
  return AppTextStyles.semiBold(fontSize: fontSize, color: color);
}

TextStyle getMediumStyle(
    {double fontSize = AppSize.s12, required Color color}) {
  return AppTextStyles.medium(fontSize: fontSize, color: color);
}
