import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get theme => _themeMode;

  bool get isDarkTheme => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = (isDarkTheme) ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
