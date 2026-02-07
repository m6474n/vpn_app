import 'package:ds_vpn/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

showErrorMessage({required String message}) {
  EasyLoading.instance.backgroundColor = Colors.red;
  EasyLoading.instance.textColor = Colors.white;
  EasyLoading.showError(message);
}

showSuccessMessage({required String message}) {
  EasyLoading.instance.backgroundColor = Colors.green;
  EasyLoading.instance.textColor = Colors.white;
  EasyLoading.showSuccess(message);
}

showToast({required String message}) {
  EasyLoading.instance.backgroundColor = Colors.red;
  EasyLoading.instance.textColor = Colors.white;
  EasyLoading.showToast(message);
}

showLoading({required String message}) {
  EasyLoading.instance.backgroundColor = colorManager.primaryColor;
  EasyLoading.instance.textColor = Colors.white;
  EasyLoading.showToast(message);
}
