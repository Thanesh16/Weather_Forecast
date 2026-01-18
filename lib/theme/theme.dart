import 'package:flutter/material.dart';

final ThemeData LightTheme = ThemeData(
  brightness: Brightness.light,

  // Background color used by Scaffold & AppBar
  primaryColor: const Color(0xFFF5F5F5),

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2196F3),   // Accent / logo / icons
    secondary: Colors.black,      // Main text
    surface: Colors.black54,      // Borders / hint text
    onPrimary: Colors.black,      // Text on background
  ),
);

final ThemeData DarkTheme = ThemeData(
  brightness: Brightness.dark,

  // Dark background 
  primaryColor: const Color(0xFF121212),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF90CAF9),   // Accent / logo / icons
    secondary: Colors.white,      // Main text
    surface: Colors.white70,      //  Borders / hint text
    onPrimary: Colors.white,      // Text on background
  ),
);
