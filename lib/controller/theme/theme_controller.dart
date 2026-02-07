// import 'package:firebase_auth/firebase_auth.dart';
import 'package:ds_vpn/utility/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorManager extends GetxController {
  Color primaryColor = const Color(0xFF9d85ff);
  Color secondaryColor = const Color(0xFF9d85ff);
  Color textColor = const Color.fromRGBO(22, 22, 22, 1);

  Color whiteColor = Colors.white;
  Color darkBlue = const Color(0xff1F1D2B);

  Color greyText = Colors.grey.shade200;
  Color bgLight = const Color.fromARGB(255, 244, 244, 244);
  Color bgDark = const Color.fromARGB(255, 255, 255, 255);
  Color borderColor = const Color.fromARGB(255, 237, 237, 237);
  double fontScale = 1.0;

  lightTheme() {
    textColor = const Color(0xff161616);
    greyText = Colors.grey.shade200;

    secondaryColor = const Color(0xFF9d85ff);
    bgLight = const Color.fromARGB(255, 244, 244, 244);
    bgDark = const Color.fromARGB(255, 255, 255, 255);

    Get.changeTheme(
      ThemeData.light().copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
    );

    borderColor = const Color.fromARGB(255, 217, 217, 217);
    update();
  }

  darkTheme() {
    textColor = Colors.white;
    // greyText = primaryColor;
    secondaryColor = Colors.white;
    bgLight = const Color.fromARGB(255, 67, 67, 67);
    bgDark = const Color.fromARGB(255, 39, 39, 39);

    Get.changeTheme(
      ThemeData.dark().copyWith(
        primaryColor: primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      ),
    );
    borderColor = const Color.fromARGB(255, 217, 217, 217);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPreferences();
    // getUserRole();
  }

  bool isDark = false;
  void toggleTheme() {
    isDark = !isDark;

    isDark ? darkTheme() : lightTheme();
    saveThemeToPreferences(isDark);
    Get.forceAppUpdate();
  }

  void setPrimaryColor(Color color) {
    primaryColor = color;
    isDark ? darkTheme() : lightTheme();
    saveColorToPreferences(color);
    update();
  }

  void setFontScale(double scale) {
    fontScale = scale;
    saveFontScaleToPreferences(scale);
    update();
  }

  void loadThemeFromPreferences() async {
    await SharedPreferences.getInstance().then((v) {
      isDark = v.getBool('isDarkTheme') ?? false;

      String? colorHex = v.getString('color');
      if (colorHex != null) {
        primaryColor = Color(int.parse(hexToColor(colorHex)));
      }

      fontScale = v.getDouble('fontScale') ?? 1.0;

      isDark ? darkTheme() : lightTheme();
      update();
    });
  }

  void saveThemeToPreferences(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkTheme', isDarkTheme);
    update();
  }

  void saveColorToPreferences(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    // Assuming color is opaque, we want the implementation to work with hexToColor logic
    String hex =
        "#${color.value.toRadixString(16).padLeft(8, '0').substring(2)}";
    prefs.setString('color', hex);
  }

  void saveFontScaleToPreferences(double scale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('fontScale', scale);
  }
}
