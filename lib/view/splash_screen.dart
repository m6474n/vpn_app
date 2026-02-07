// ignore_for_file: file_names

import 'package:ds_vpn/utility/custom_text_styles.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:ds_vpn/service/splash_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? appVersion, requiredVersion, platform;
  // var updateCont = Get.put(UpdateController());
  SplashService service = SplashService();

  @override
  void initState() {
    super.initState();
    service.isLogin(context);
  }

  // updateApp() async {
  //   print('AppUpdaet');
  //   appVersion = await updateCont.getAppVersion();
  //   requiredVersion = await updateCont.getRequiredVersion();
  //   platform = await updateCont.checkPlatform();

  //   updateCont.showUpdateMessage().then((value) {
  //     value
  //         ? Future.delayed(const Duration(seconds: 5), () {
  //             showBottomSheet();
  //           })
  //         : null;
  //   });
  //   setState(() {});
  // }

  // showBottomSheet() async {
  //   await Get.bottomSheet(
  //     Container(
  //       height: 190,
  //       decoration: BoxDecoration(
  //         color: colorManager.bgDark,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       width: double.infinity,
  //       child: Padding(
  //         padding: const EdgeInsets.only(top: 28.0, left: 28),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             const Text(
  //               'Update Available',
  //               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               'You are using App version $appVersion. New Version $requiredVersion is available on ${platform == "android_app" ? "PlayStore" : "AppStore"}',
  //             ),
  //             const SizedBox(height: 12),
  //             Row(
  //               children: [
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Get.back();
  //                     updateCont.LaunchURL();
  //                   },
  //                   child: Text(
  //                     'Update',
  //                     style: TextStyle(color: colorManager.primaryColor),
  //                   ),
  //                 ),
  //                 const SizedBox(width: 18),
  //                 ElevatedButton(
  //                   onPressed: () {
  //                     Get.back();
  //                   },
  //                   child: Text(
  //                     'Cancel',
  //                     style: TextStyle(color: colorManager.primaryColor),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: ColorManager(),
      builder: (cont) {
        return Scaffold(
          backgroundColor: cont.bgDark,
          body: Center(child: Text('DS VPN', style: CustomStyles.h1())),
          // body: Center(child: Image.asset(appLogo, height: 150, width: 150)),
        );
      },
    );
  }
}
