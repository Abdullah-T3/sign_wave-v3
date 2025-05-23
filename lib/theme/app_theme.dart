import 'package:flutter/material.dart';

class AppTheme {
  // Define the primary color
  static const Color primaryGridColor = Color(0xFF03A9F4);
  static const Color secondaryGridColor = Color(0xFF40C4FF);
  static const Color backgroundColor = Color(0xFF292929);
  static const Color lightBlue = Color(0xFF40C4FF);
  static const Color lightBlue2 = Color(0xFF03A9F4);
  static const Color inChatBackground = Color(0xff2C2D3A);
  static const Color primaryTextColor = Color(0xffECF9FF);
  static const primaryColor = Color(0xFF135CAF);
  static const darkBackgroundColor = Color(0xFF121212);
  static const darkSurfaceColor = Color(0xFF1E1E1E);
  
  // Get theme based on mode
  static ThemeData getTheme(ThemeMode mode) {
    return mode == ThemeMode.light ? lightTheme : darkTheme;
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Colors
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Color(0xFF8E8E93),
      surface: Colors.white,
      onSurface: Colors.black,
      tertiary: Color(0xFF7CBEC2),
      onPrimary:
          Colors.black87, // Dark text on primary color for better contrast
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColor.withOpacity(0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
    ),

    // Message Bubbles
    cardTheme: CardThemeData(
      color: primaryColor.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Icons
    iconTheme: const IconThemeData(color: Colors.black87, size: 24),

    // Text Themes
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      labelMedium: TextStyle(fontSize: 12, color: Colors.grey),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Colors
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: Color(0xFF8E8E93),
      surface: darkSurfaceColor,
      background: darkBackgroundColor,
      onSurface: Colors.white,
      tertiary: Color(0xFF7CBEC2),
      onPrimary: Colors.white,
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackgroundColor,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(style: BorderStyle.solid , color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(style: BorderStyle.solid , color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: primaryColor),
      ),
      
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
    ),

    // Message Bubbles
    cardTheme: CardThemeData(
      color: darkSurfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Icons
    iconTheme: const IconThemeData(color: Colors.white, size: 24),

    // Text Themes
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
      labelMedium: TextStyle(fontSize: 12, color: Colors.grey),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
