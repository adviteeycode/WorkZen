import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D0D0D),

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF716BFF),
    secondary: Color(0xFF8F85FF),
    surface: Color(0xFF121212),
    surfaceVariant: Color(0xFF1B1B1B),
    background: Color(0xFF0D0D0D),
    outline: Color(0xFF2C2C2C),
    outlineVariant: Color(0xFF3A3A3A),
    onSurface: Colors.white,
    onBackground: Colors.white,
    onPrimary: Colors.white,
  ),

  // ---------------- TEXT TYPOGRAPHY ----------------
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
  ),

  // ---------------- APPBAR ----------------
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Color(0xFF111111),
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),

  // ---------------- INPUT FIELDS ----------------
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF181818),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF2F2F2F)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF716BFF), width: 1.4),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white38),
  ),

  // ---------------- BUTTONS ----------------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      backgroundColor: const Color(0xFF716BFF),
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: const Color(0xFF716BFF).withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  // ---------------- CARD ----------------
  cardTheme: CardThemeData(
    color: const Color(0xFF161616),
    elevation: 6,
    shadowColor: Colors.black.withOpacity(0.2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
