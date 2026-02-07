import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:ds_vpn/controller/vpn_controller.dart';
import 'package:ds_vpn/utility/custom_text_styles.dart';
import 'package:ds_vpn/view/app_settings.dart';
import 'package:ds_vpn/view/shared_prefs_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String appVersion = '1.0.0';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  void _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vpnController = Get.find<VpnController>();

    return GetBuilder<ColorManager>(
      builder: (colorController) {
        return Drawer(
          backgroundColor: colorController.bgDark,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Column(
            children: [
              // Header Section
              Obx(() => _buildHeader(colorController, vpnController)),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    // Premium Card
                    _buildPremiumCard(colorController),

                    _buildSectionHeader(colorController, "GENERAL"),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedHome01,
                      title: "Dashboard",
                      onTap: () => Get.back(),
                    ),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedGlobe,
                      title: "Servers List",
                      onTap: () {
                        Get.back();
                      },
                    ),

                    _buildSectionHeader(colorController, "SUPPORT"),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedInformationCircle,
                      title: "FAQ",
                      onTap: () {
                        Get.snackbar(
                          "FAQ",
                          "Frequently Asked Questions coming soon!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedCustomerService,
                      title: "Support",
                      onTap: () {
                        Get.snackbar(
                          "Support",
                          "Customer Support coming soon!",
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),

                    _buildSectionHeader(colorController, "LEGAL"),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedFile02,
                      title: "Privacy Policy",
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedNote01,
                      title: "Terms of Service",
                      onTap: () {},
                    ),

                    _buildSectionHeader(colorController, "APP"),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedSettings01,
                      title: "Settings",
                      onTap: () => Get.to(() => AppSettingScreen()),
                    ),

                    // Dark Mode Toggle inside Drawer
                    ListTile(
                      leading: HugeIcon(
                        icon: HugeIcons.strokeRoundedMoon02,
                        color: colorController.textColor.withOpacity(0.7),
                        size: 22,
                      ),
                      title: Text(
                        "Dark Mode",
                        style: CustomStyles.paragraph().copyWith(
                          color: colorController.textColor,
                        ),
                      ),
                      trailing: Switch.adaptive(
                        value: colorController.isDark,
                        activeColor: colorController.primaryColor,
                        onChanged: (val) => colorController.toggleTheme(),
                      ),
                    ),

                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedShare01,
                      title: "Share App",
                      onTap: () {},
                    ),
                    _buildDrawerItem(
                      colorController,
                      icon: HugeIcons.strokeRoundedStar,
                      title: "Rate Us",
                      onTap: () {},
                    ),

                    if (kDebugMode) ...[
                      _buildSectionHeader(colorController, "DEBUG"),
                      _buildDrawerItem(
                        colorController,
                        icon: HugeIcons.strokeRoundedDatabase,
                        title: "Shared Prefs",
                        onTap: () => Get.to(() => SharePrefScreen()),
                      ),
                    ],

                    SizedBox(height: 20),
                  ],
                ),
              ),

              // Footer Version Info
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Version $appVersion",
                  style: TextStyle(
                    color: colorController.textColor.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    ColorManager colorController,
    VpnController vpnController,
  ) {
    final isConnected = vpnController.isConnected;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 60, 20, 30),
      decoration: BoxDecoration(
        color: colorController.primaryColor.withOpacity(0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorController.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  "assets/icon.png",
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.vpn_lock_rounded,
                    color: colorController.primaryColor,
                    size: 30,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isConnected
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isConnected ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      isConnected ? "PROTECTED" : "UNPROTECTED",
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "DS VPN",
            style: CustomStyles.h4().copyWith(color: colorController.textColor),
          ),
          SizedBox(height: 4),
          Text(
            "Secure & Anonymous",
            style: TextStyle(
              color: colorController.textColor.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(ColorManager colorController) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorController.primaryColor,
            colorController.primaryColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorController.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedCrown,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Go Premium",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "Get faster servers & ad-free",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ColorManager colorController, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Text(
        title,
        style: TextStyle(
          color: colorController.textColor.withOpacity(0.4),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    ColorManager colorController, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: HugeIcon(
        icon: icon,
        color: colorController.textColor.withOpacity(0.7),
        size: 22,
      ),
      title: Text(
        title,
        style: CustomStyles.paragraph().copyWith(
          color: colorController.textColor.withOpacity(0.8),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: colorController.textColor.withOpacity(0.2),
        size: 14,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      visualDensity: VisualDensity.compact,
    );
  }
}
