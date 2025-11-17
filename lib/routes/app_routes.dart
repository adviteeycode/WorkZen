import 'package:flutter/material.dart';
import 'package:workzen/home/ui/screens/home_screen.dart';
import 'package:workzen/profile/ui/profile_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  static Map<String, WidgetBuilder> get route => {
    home: (context) => HomeScreen(),
    profile: (context) => ProfileScreen(),
  };
}
