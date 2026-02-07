import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:secure_flow_vpn/services/api_service.dart';
import 'core/app_theme.dart';
import 'views/main_navigation_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Set status bar style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SecureFlowApp());
}

final api = ApiServices();

class SecureFlowApp extends StatelessWidget {
  const SecureFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'SecureFlow VPN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigationWrapper(),
    );
  }
}
