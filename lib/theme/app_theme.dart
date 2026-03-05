import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFFA1FF00);
  static const Color secondary = Color(0xFF00D4FF);

  static const Color backgroundLight = Color(0xFFF7F8F5);
  static const Color backgroundDark = Color(0xFF0A0F1D); // Deep navy variant
  static const Color backgroundDarkMap = Color(0xFF1C230F);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDarkMap,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        background: backgroundDarkMap,
        surface: Color(0xFF1E293B),
      ),
      textTheme: GoogleFonts.splineSansTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      ).apply(
        bodyColor: const Color(0xFFF1F5F9), // slate-100
        displayColor: const Color(0xFFF1F5F9),
      ),
      iconTheme: const IconThemeData(color: primary),
    );
  }
}
