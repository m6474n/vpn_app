import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomStyles {
  // Base text style (dynamic)
  static TextStyle primaryTextStyle() {
    final colorManager = Get.find<ColorManager>();
    return TextStyle(color: colorManager.textColor, fontFamily: 'SF Pro');
  }

  // Headings
  static TextStyle h1() => primaryTextStyle().copyWith(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle h2() => primaryTextStyle().copyWith(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.3,
  );

  static TextStyle h3() => primaryTextStyle().copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle h4() => primaryTextStyle().copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle h5() => primaryTextStyle().copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  static TextStyle h6() => primaryTextStyle().copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 1.3,
  );

  // Paragraph / Body text
  static TextStyle paragraph({double fontSize = 14, double height = 1.5}) =>
      primaryTextStyle().copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        height: height,
      );
}
