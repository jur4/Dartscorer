import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color.fromARGB(255, 73, 149, 201);
  static const Color darkBlue = Color.fromARGB(255, 16, 49, 92);
  static const Color mediumBlue = Color.fromARGB(255, 24, 73, 138);
  static const Color lightBlue = Color.fromARGB(255, 10, 31, 59);
  static const Color backgroundDark = Color.fromARGB(255, 28, 36, 48);
  static const Color surfaceDark = Color.fromARGB(255, 41, 52, 70);
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBlue, mediumBlue, lightBlue],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, primaryBlue],
  );

  static final List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black26,
      spreadRadius: 5,
      blurRadius: 5,
      offset: const Offset(0, 1),
    ),
  ];

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: mediumBlue,
        surface: backgroundDark,
        background: backgroundDark,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: backgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: primaryBlue,
            width: 2,
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static BorderRadius get defaultBorderRadius => BorderRadius.circular(12);
  
  static BorderRadius get buttonBorderRadius => BorderRadius.circular(8);
  
  static BorderRadius get cardBorderRadius => BorderRadius.circular(16);
}