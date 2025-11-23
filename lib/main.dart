import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/firebase_options.dart';
import 'package:workzen/pages/auth/login_page.dart';
import 'package:workzen/pages/auth/register_page.dart';
import 'package:workzen/pages/dashboard/dashboard_page.dart';
import 'package:workzen/pages/landing_page.dart';
import 'package:workzen/providers/attendance_provider.dart';
import 'package:workzen/providers/auth_provider.dart';
import 'package:workzen/providers/employee_provider.dart';
import 'package:workzen/providers/leave_provider.dart';
import 'package:workzen/providers/payroll_provider.dart';
import 'package:workzen/theme/provider/theme_provider.dart';
import 'package:workzen/theme/themes/light_theme.dart';
import 'package:workzen/theme/themes/dark_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Suppress Flutter web diagnostics errors during development
  developer.Timeline.instantSync('AppStart');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => LeaveProvider()),
        ChangeNotifierProvider(create: (_) => PayrollProvider()),
        ChangeNotifierProvider(create: (_) => EmployeeProvider()),
      ],
      child: const WorkZen(),
    ),
  );
}

class WorkZen extends StatelessWidget {
  const WorkZen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.theme,
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Mark initialization complete after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(context, listen: false).markInitialized();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        // Show loading while checking auth state
        if (!authProvider.isInitialized) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          );
        }

        // If user is logged in, show dashboard
        if (authProvider.isLoggedIn && authProvider.currentUser != null) {
          return const DashboardPage();
        }

        // Otherwise show landing page
        return const LandingPage();
      },
    );
  }
}
