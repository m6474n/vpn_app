// ignore_for_file: file_names

import 'dart:async';
import 'dart:developer';

import 'package:ds_vpn/view/dashboard.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SplashService {
  isLogin(BuildContext context, {String? userRole}) async {
    Timer(const Duration(seconds: 3), () async {
      // if (await AuthService.isUserLoggedIn()) {
      //   Get.offAllNamed(AppRoutes.dashboard);
      // }
      // //  else if (await AuthService.isSubdomainAvailable()) {
      // //   log("User Session is Not  Found!");
      // //   Get.offAll(const LoginScreen());
      // // }
      // else {
      // log("Session Not Found!");
      Get.offAll(Dashboard());
      // }
    });
  }
}
