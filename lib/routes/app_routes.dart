import 'package:flutter/material.dart';
import 'package:workzen/home/ui/home_screen.dart';

class AppRoutes {
  static const String home = '/';

  static Map<String, WidgetBuilder> get route => {
    home: (context) => HomeScreen(),
  };
}
