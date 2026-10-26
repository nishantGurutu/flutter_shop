import 'package:flutter/material.dart';

class AppColors {
  static const Color gradientStart = Color(0xFFdc72f2);
  static const Color primaryColor = Color(0xFFa36be2);
  static const Color unselectedButtonColor = Color(0xFFf7ecff);
  static const Color lightBackground = Colors.white;
  static const Color lightText = Color(0xFF2D2D2D);
  static const Color lightCard = Color(0xFFF7F7F7);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE0E0E0);
  static const Color darkBackground = Color(0xFF121212);
  static const Color backgroundColor = Color(0xFFf5f6f9);
  static const Color darkText = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF1E1E1E);
  static const Color darkBorder = Color(0xFF2C2C2C);
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color warning = Colors.orangeAccent;

  static LinearGradient get appGradient => const LinearGradient(
    colors: [gradientStart, primaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
