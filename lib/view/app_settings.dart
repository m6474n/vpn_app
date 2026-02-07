import 'package:ds_vpn/component/custom_appbar.dart';
import 'package:ds_vpn/component/custom_switch.dart';
import 'package:ds_vpn/controller/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:tution_manager/main.dart';

class AppSettingScreen extends StatelessWidget {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "App Settings"),
      body: GetBuilder<ColorManager>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Theme Mode", controller),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    "Dark Mode",
                    style: TextStyle(color: controller.textColor),
                  ),
                  trailing: CustomSwitch(
                    value: controller.isDark,
                    onChanged: (val) => controller.toggleTheme(),
                    inactiveIcon: Icon(
                      Icons.dark_mode_outlined,
                      color: controller.primaryColor,
                      size: 14,
                    ),
                    activeIcon: Icon(
                      Icons.light_mode_outlined,
                      color: controller.primaryColor,
                      size: 14,
                    ),
                  ),

                  //  CustomTo Switch(
                  //   value: controller.isDark,
                  //   onChanged: (val) => controller.toggleTheme(),
                  //   activeColor: controller.primaryColor,
                  // ),
                ),
                const Divider(),
                const SizedBox(height: 20),

                _buildSectionTitle("Primary Color", controller),
                const SizedBox(height: 15),
                _buildColorPicker(controller),
                const SizedBox(height: 30),
                const Divider(),

                const SizedBox(height: 20),
                _buildSectionTitle("Font Size", controller),
                const SizedBox(height: 10),
                _buildFontScaleSlider(controller),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorManager controller) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: controller.textColor,
      ),
    );
  }

  Widget _buildColorPicker(ColorManager controller) {
    final List<Color> colors = [
      const Color(0xFF9d85ff), // Default
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.teal,
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.cyan,
    ];

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: colors.map((color) {
        bool isSelected = controller.primaryColor.value == color.value;
        return GestureDetector(
          onTap: () => controller.setPrimaryColor(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: controller.textColor, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 28)
                : null,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFontScaleSlider(ColorManager controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Small", style: TextStyle(color: controller.greyText)),
            Text("Large", style: TextStyle(color: controller.greyText)),
          ],
        ),
        Slider(
          value: controller.fontScale,
          min: 0.8,
          max: 1.4,
          divisions: 6,
          label: "${controller.fontScale.toStringAsFixed(1)}x",
          activeColor: controller.primaryColor,
          onChanged: (value) {
            controller.setFontScale(value);
          },
        ),
        Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: controller.bgLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Preview Text Size",
              style: TextStyle(color: controller.textColor, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
