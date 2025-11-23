import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/models/user.dart';
import 'package:workzen/pages/dashboard/admin_dashboard.dart';
import 'package:workzen/pages/dashboard/employee_dashboard.dart';
import 'package:workzen/pages/dashboard/hr_dashboard.dart';
import 'package:workzen/pages/dashboard/payroll_dashboard.dart';
import 'package:workzen/providers/auth_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUser = authProvider.currentUser;

    // Show loading state
    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Container(
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
        ),
      );
    }

    if (currentUser == null) {
      // User is not logged in, redirect to landing page
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      });
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

    switch (currentUser.role) {
      case UserRole.admin:
        return const AdminDashboard();
      case UserRole.employee:
        return const EmployeeDashboard();
      case UserRole.hrOfficer:
        return const HRDashboard();
      case UserRole.payrollOfficer:
        return const PayrollDashboard();
    }
  }
}
