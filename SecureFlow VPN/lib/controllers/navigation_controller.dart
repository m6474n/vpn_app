import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final _selectedIndex = 0.obs;
  int get selectedIndex => _selectedIndex.value;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: _selectedIndex.value);
  }

  void changeIndex(int index) {
    _selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  void onPageChanged(int index) {
    _selectedIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
