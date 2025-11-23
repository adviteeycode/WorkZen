import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFF5F5F7),

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF6B63FF),
    secondary: Color(0xFF8F85FF),
    surface: Colors.white,
    surfaceVariant: Color(0xFFF0F0F4),
    background: Color(0xFFF5F5F7),
    outline: Color(0xFFCED0D6),
    outlineVariant: Color(0xFFE2E4E8),
    onSurface: Colors.black,
    onBackground: Colors.black,
    onPrimary: Colors.white,
  ),

  // ---------------- TEXT ----------------
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
  ),

  // ---------------- APPBAR ----------------
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),

  // ---------------- INPUT ----------------
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFD6D6D6)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF6B63FF), width: 1.4),
    ),
    labelStyle: const TextStyle(color: Colors.black54),
  ),

  // ---------------- BUTTONS ----------------
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6B63FF),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      elevation: 3,
      shadowColor: const Color(0xFF6B63FF).withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),

  // ---------------- CARD ----------------
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.07),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);
