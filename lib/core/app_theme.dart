import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryBlue = Color(1469396); // #1152d4
  static const Color backgroundDark = Color(1054242); // #101622
  static const Color backgroundLight = Color(16184952); // #f6f6f8
  static const Color glassWhite = Color(805306367); // rgba(255, 255, 255, 0.03)

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundDark,
    fontFamily: 'NotoSansArabic',
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: primaryBlue,
      surface: Color(0xFF1E293B),
    ),
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: backgroundLight,
    fontFamily: 'NotoSansArabic',
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      secondary: primaryBlue,
      surface: Colors.white,
    ),
  );

}
