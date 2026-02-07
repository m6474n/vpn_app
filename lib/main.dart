import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:ds_vpn/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

final ColorManager colorManager = Get.put(ColorManager());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..backgroundColor = colorManager.primaryColor
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      // ignore: deprecated_member_use
      ..radius = 30
      ..indicatorSize = 50.0
      ..toastPosition = EasyLoadingToastPosition.bottom
      ..animationStyle = EasyLoadingAnimationStyle.scale;
    return GetMaterialApp(
      home: SplashScreen(),
      defaultTransition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      opaqueRoute: true,
      popGesture: true,
      debugShowCheckedModeBanner: false,
      title: 'DS VPN',
      theme: ThemeData(
        dialogBackgroundColor: colorManager.bgDark,
        fontFamily: 'SF Pro',
        primaryColor: colorManager.primaryColor,
        scaffoldBackgroundColor: colorManager.bgDark,
        appBarTheme: AppBarTheme(backgroundColor: colorManager.bgDark),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(colorManager.primaryColor),
            foregroundColor: WidgetStatePropertyAll(colorManager.whiteColor),
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: colorManager.primaryColor,
          background: colorManager.bgDark,
        ),
      ),

      builder: (context, child) {
        child = EasyLoading.init()(context, child);
        return GetBuilder<ColorManager>(
          builder: (controller) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(controller.fontScale)),
              child: child!,
            );
          },
        );
      },
    );
  }
}
