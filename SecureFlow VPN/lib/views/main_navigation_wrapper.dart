import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import '../core/app_colors.dart';
import '../controllers/navigation_controller.dart';
import 'home_screen.dart';
import 'server_selection_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';

class MainNavigationWrapper extends StatelessWidget {
  const MainNavigationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navCtrl = Get.put(NavigationController());

    final List<Widget> screens = [
      const HomeScreen(),
      const ServerSelectionScreen(),
      const SettingsScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: navCtrl.pageController,
        onPageChanged: navCtrl.onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: _buildBottomBar(navCtrl),
    );
  }

  Widget _buildBottomBar(NavigationController navCtrl) {
    return Container(
      margin: const EdgeInsets.all(24),
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  navCtrl,
                  0,
                  HugeIcons.strokeRoundedHome01,
                  "Home",
                ),
                _buildNavItem(navCtrl, 1, HugeIcons.strokeRoundedGlobe, "VPN"),
                _buildNavItem(
                  navCtrl,
                  2,
                  HugeIcons.strokeRoundedSettings02,
                  "Settings",
                ),
                _buildNavItem(
                  navCtrl,
                  3,
                  HugeIcons.strokeRoundedUser,
                  "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    NavigationController navCtrl,
    int index,
    IconData icon,
    String label,
  ) {
    final isSelected = navCtrl.selectedIndex == index;

    return GestureDetector(
      onTap: () => navCtrl.changeIndex(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.accent : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.accent : AppColors.textSecondary,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
