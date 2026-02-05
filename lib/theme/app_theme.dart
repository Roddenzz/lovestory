import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFE91E63); // Pink 500
  static const Color accentColor = Color(0xFFFF4081); // Pink A200
  static const Color darkRed = Color(0xFFA00030); // Deep Love Red
  static const Color softPink = Color(0xFFFFC1E3);
  static const Color background = Color(0xFFFFF0F5); // Lavender Blush
  static const Color cream = Color(0xFFFFFDD0);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: accentColor,
        surface: Colors.white,
      ),
      textTheme: GoogleFonts.montserratTextTheme().copyWith(
        displayLarge: GoogleFonts.greatVibes(
          fontSize: 48,
          color: darkRed,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.lato(
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      useMaterial3: true,
    );
  }
}
