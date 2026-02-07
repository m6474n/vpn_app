import 'dart:convert';
import 'dart:developer';

import 'package:ds_vpn/component/custom_button.dart';
import 'package:ds_vpn/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns just the file name (e.g., "document.pdf") from a full file path.

const String darkTSLogo = 'assets/images/ts_logo_dark.png';
const String lightTSLogo = 'assets/images/ts_logo_light.png';

const String membershipKey = 'membership';
const String userDetailsKey = 'user_details';
const String sessionToken = 'token';
const String deviceToken = 'device_token';

String androidAppId = "com.twinspider.ds_vpn";
String iosAppId = "6751182325";

bool isPhoneNumber(String input) {
  final phoneRegex = kDebugMode ? RegExp(r'^\d{4,14}$') : RegExp(r'^\d{9,14}$');
  return phoneRegex.hasMatch(input);
}

// TextStyle

TextStyle primaryTextStyle = TextStyle(
  fontSize: 14,
  color: colorManager.textColor,
  fontWeight: FontWeight.w400,
  fontFamily: 'Inter',
);

defaultPopup(
  BuildContext context, {
  Widget? child,
  String? msg,
  bool closeBtn = true,
  Function? onAccept,
  Function? onCancel,
}) async {
  await showDialog(
    barrierDismissible: false,
    context: context,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        contentPadding: EdgeInsets.all(0),
        backgroundColor: colorManager.bgDark,
        content: SingleChildScrollView(
          child: Stack(
            children: [
              if (msg != null)
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text(
                    msg,
                    style: primaryTextStyle.copyWith(
                      color: colorManager.textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (child != null) child,
              if (closeBtn)
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      onCancel?.call();
                    },
                    child: Icon(Icons.close),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            height: 35,
            width: 85,
            child: CustomButton(
              labelSize: 14,
              label: "Confirm",
              onTap: () {
                onAccept?.call();
              },
            ),
          ),
          SizedBox(
            height: 35,
            width: 85,
            child: CustomButton(
              backgroundColor: Colors.grey.shade300,
              labelSize: 14,
              label: "Cancel",
              onTap: () {
                Get.back();
                onCancel?.call();
              },
            ),
          ),
          // CustomBut
        ],
      );
    },
  );
}

tsWatermark() {
  // return InkWell(
  //   onTap: () async {
  //     await launchCustomURL('https://www.twinspider.com/');
  //   },
  //   child: Image.asset(
  //     colorManager.isDark ? darkTSLogo : lightTSLogo,
  //     width: 200,
  //   ),
  // );
}
toggleDrawer(GlobalKey<ScaffoldState> key) {
  key.currentState!.isDrawerOpen
      ? key.currentState!.closeDrawer()
      : key.currentState!.openDrawer();
}
