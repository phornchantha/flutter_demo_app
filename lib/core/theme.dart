import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors matching "Cooking" design
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkCardSurface = Color(0xFF1E1E22);
  static const Color darkInputFill = Color(0xFF27272A);
  static const Color darkBorderColor = Color(0xFF3F3F46);

  // Accent Colors
  static const Color brandGold = Color(0xFFD97706); // Orange-Gold Chef Badge
  static const Color brandGoldBackground = Color(0xFF3D2005);
  static const Color primaryBlue = Color(0xFF0284C7); // Add to shopping list blue
  static const Color pillWhite = Color(0xFFF4F4F5);

  // Status Colors
  static const Color successGreen = Color(0xFF22C55E);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color textSecondary = Color(0xFFA1A1AA);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: brandGold,
        secondary: primaryBlue,
        surface: darkCardSurface,
        background: darkBackground,
        error: errorRed,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: brandGold, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 1.5),
        ),
        hintStyle: const TextStyle(color: textSecondary, fontSize: 14),
        labelStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}
