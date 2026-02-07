import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0B1220);
  static const Color secondary = Color(0xFF121A2F);
  static const Color accent = Color(0xFF1EC8FF);
  static const Color success = Color(0xFF2EE59D);
  static const Color warning = Color(0xFFF5B942);
  static const Color error = Color(0xFFFF5A5A);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);

  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1220), Color(0xFF000000)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1EC8FF), Color(0xFF00FFE0)],
  );
}
