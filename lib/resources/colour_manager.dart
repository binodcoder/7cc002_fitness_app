import 'package:flutter/material.dart';

class ColorManager {
  static Color primary = HexColor.fromHex("#ED9728");
  static Color darkGrey = HexColor.fromHex("#525252");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#B39E9E9E");
  static Color blackOpacity87 = HexColor.fromHex("#000000").withOpacity(0.87);

   static Color secondary = HexColor.fromHex("#5c3fbc");
   static Color darkPrimary = HexColor.fromHex("#D17D11");


  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color grey3 = HexColor.fromHex("#D3D3D3");

  static Color blue = HexColor.fromHex("#0074E3");
  static Color lightBlue = HexColor.fromHex("#23C6C8");
  static Color blueBright = HexColor.fromHex("#FF0096FF");
  static Color blueGrey = HexColor.fromHex("#FFECEFF1");
  static Color middleBlue = HexColor.fromHex("#59BED4");


  //new colors

  static Color white = HexColor.fromHex("#FFFFFF");
  static Color error = HexColor.fromHex("#e61f34"); //red color

   static Color darkWhite = HexColor.fromHex("#FFE6E6E6");
  static Color redWhite = HexColor.fromHex("#FFF3F3F4");
  static Color brownWhite = HexColor.fromHex("#F6F6F6");

  static Color black = HexColor.fromHex("#000000");
  static Color red = HexColor.fromHex("#FF0000");
  static Color redAccent = HexColor.fromHex("#ED5565");
   static Color warning = HexColor.fromHex("#ffd6cc");
  static Color success = HexColor.fromHex("#198754");

  static Color green = HexColor.fromHex("#FF00C897");
  static Color darkGreen = HexColor.fromHex("#09B44D");
  static Color lightGreen = HexColor.fromHex("#D0F1DD");
  static Color shiningGreen = HexColor.fromHex("#7AF176");

  static Color darkPurple = HexColor.fromHex("#240046");
  static Color deepPurple = HexColor.fromHex("#8A2BE2");

   static Color blackOpacity54 = HexColor.fromHex("#000000").withOpacity(0.54);
  static Color blackOpacity38 = HexColor.fromHex("#000000").withOpacity(0.38);
  static Color darkBlack = HexColor.fromHex("#262626");

  static Color skyBlue = HexColor.fromHex("#34A6D5");
  static Color purpleLight = HexColor.fromHex("#FF00E5");
  static Color orange = HexColor.fromHex("#f57224");

  static Color fadeYellow = HexColor.fromHex("#F9F8F2");
  static Color cadiumBlue = HexColor.fromHex("#085593");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString"; //8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}