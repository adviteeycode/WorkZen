import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/routes/app_routes.dart';
import 'package:workzen/theme/provider/theme_provider.dart';
import 'package:workzen/theme/themes/dark_theme.dart';
import 'package:workzen/theme/themes/light_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: WorkZen(),
    ),
  );
}

class WorkZen extends StatelessWidget {
  const WorkZen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.theme,
      initialRoute: AppRoutes.home,
      routes: AppRoutes.route,
    );
  }
}
