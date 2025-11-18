import 'package:flutter/material.dart';
import 'package:workzen/theme/widget/animated_theme_toggle.dart';
import 'package:workzen/user_role.dart';

class SettingHeader extends StatelessWidget {
  final UserRole role;
  final Widget searchBar;

  const SettingHeader({super.key, required this.role, required this.searchBar});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'User Settings',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),

          if (role == UserRole.admin)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: searchBar,
              ),
            ),
        ],
      ),
    );
  }
}

class SettingBody extends StatefulWidget {
  final UserRole role;

  const SettingBody({super.key, required this.role});

  @override
  State<SettingBody> createState() => _SettingBodyState();
}

class _SettingBodyState extends State<SettingBody> {
  List<String> roles = ["Admin", "HR Officer", "Payroll", "Employee"];
  String selectedRole = "Employee";

  bool get isAdmin => widget.role == UserRole.admin;
  bool get isEmployee => widget.role == UserRole.employee;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: isAdmin
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Toggle Theme"),
                    SizedBox(width: 16),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedThemeToggle(),
                    ),
                  ],
                ),
                _tableHeader(),
                Expanded(child: _userSettingsList()),
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Toggle Theme"),
                  SizedBox(height: 16),
                  AnimatedThemeToggle(),
                ],
              ),
            ),
    );
  }

  // ---------------- TABLE HEADER ----------------
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.withOpacity(0.1),
      child: const Row(
        children: [
          Expanded(flex: 1, child: Center(child: Text("User Name"))),
          Expanded(flex: 1, child: Center(child: Text("Login ID"))),
          Expanded(flex: 1, child: Center(child: Text("Email"))),
          Expanded(flex: 2, child: Center(child: Text("Role"))),
        ],
      ),
    );
  }

  // ---------------- TABLE ROWS ----------------
  Widget _userSettingsList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Username (non-editable)
              const Expanded(
                flex: 1,
                child: Center(child: Text("[Employee Name]")),
              ),

              // Login ID (non-editable)
              const Expanded(flex: 1, child: Center(child: Text("login123"))),

              // Email (editable)
              const Expanded(
                flex: 1,
                child: Center(child: Text("abcd@gmail.com")),
              ),

              // Role dropdown
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedRole,
                      items: roles.map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
