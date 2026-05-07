import 'package:flutter/material.dart';

class AppTheme {
  static const Color whitePure = Color(0xFFFFFFFF);
  static const Color redBright = Color(0xFFE53935);
  static const Color redDark = Color(0xFF8B0000);
  static const Color redCherry = Color(0xFFC62828);
  static const Color redCrimson = Color(0xFFDC143C);
  static const Color burgundy = Color(0xFF800020);
  static const Color purpleRed = Color(0xFF6B0F1A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color diagonalLines = Color(0x0D000000);

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: redBright,
      scaffoldBackgroundColor: whitePure,
      colorScheme: ColorScheme.light(
        primary: redBright,
        secondary: redCherry,
        surface: whitePure,
      ),
      fontFamily: 'Cairo',
    );
  }
}
