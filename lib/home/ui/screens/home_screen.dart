import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/attendance/ui/widgets/attendance.dart';
import 'package:workzen/employee/ui/widgets/employee.dart';
import 'package:workzen/home/ui/widgets/check_in_and_out.dart';
import 'package:workzen/home/ui/widgets/company_logo.dart';
import 'package:workzen/home/ui/widgets/custom_searchbar.dart';
import 'package:workzen/home/ui/widgets/profile_icon.dart';
import 'package:workzen/home/ui/widgets/tab_card.dart';
import 'package:workzen/theme/provider/theme_provider.dart';
import 'package:workzen/timeoff/ui/widgets/time_off.dart';
import 'package:workzen/user_role.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  bool checkedIn = false;

  final List<String> tabs = [
    'Employees',
    'Attendance',
    'Time Off',
    'Payroll',
    'Reports',
    'Settings',
  ];

  int selectedTabIndex = 0;

  Widget header(int selectedTabIndex) {
    switch (selectedTabIndex) {
      case 0:
        return EmployeeHeader(
          searchBar: CustomSearchbar(
            controller: searchController,
            onChanged: (val) {
              val = searchController.text;
              setState(() {});
            },
            onClear: () {
              searchController.clear();
              setState(() {});
            },
          ),
        );
      case 1:
        return AttendanceHeader(
          role: UserRole.admin,
          searchBar: CustomSearchbar(
            controller: searchController,
            onChanged: (val) {
              val = searchController.text;
              setState(() {});
            },
            onClear: () {
              searchController.clear();
              setState(() {});
            },
          ),
        );
      case 2:
        return TimeOffHeader(
          role: UserRole.admin,
          searchBar: CustomSearchbar(
            controller: searchController,
            onChanged: (val) {
              val = searchController.text;
              setState(() {});
            },
            onClear: () {
              searchController.clear();
              setState(() {});
            },
          ),
        );
      case 3:
        return Expanded(child: Center(child: Text('Payroll Header')));
      case 4:
        return Expanded(child: Center(child: Text('Reports Header')));
      case 5:
        return Expanded(child: Center(child: Text('Settings Header')));
      default:
        return Expanded(child: SizedBox());
    }
    // Return an empty widget for other tabs
  }

  Widget buildTabContent(int index) {
    switch (index) {
      case 0:
        return EmployeeBody();
      case 1:
        return AttendanceBody(role: UserRole.admin);
      case 2:
        return TimeOffBody(role: UserRole.employee);
      case 3:
        return Center(child: Text('Payroll Content'));
      case 4:
        return Center(child: Text('Reports Content'));
      case 5:
        return Center(child: Text('Settings Content'));
      default:
        return Center(child: Text('Unknown Tab'));
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: Provider.of<ThemeProvider>(context).toggleTheme,
        child: Icon(Icons.dark_mode),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SizedBox(
              child: Row(
                children: [
                  CompanyLogo(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: VerticalDivider(
                      color: theme.dividerColor,
                      thickness: 1.15,
                      radius: BorderRadius.circular(2),
                    ),
                  ),
                  header(selectedTabIndex),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      onPressed: () async {
                        final result = await showDialog<bool>(
                          context: context,
                          builder: (context) => CheckInAndOutDialog(
                            isCheckedIn: checkedIn,
                            checkInTime: checkedIn
                                ? DateTime.now().subtract(
                                    const Duration(hours: 2, minutes: 30),
                                  )
                                : null,
                          ),
                        );
                        if (!mounted) return;
                        if (result != null) {
                          setState(() {
                            checkedIn = result;
                          });
                        }
                      },
                      icon: Icon(
                        checkedIn
                            ? Icons.circle_rounded
                            : Icons.circle_outlined,
                        color: checkedIn ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),
                  ProfileIcon(
                    checkedIn: checkedIn,
                    imageUrl:
                        "https://avatars.githubusercontent.com/u/46230344?v=4",
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: 150,
                  child: ListView.builder(
                    itemCount: tabs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedTabIndex = index;
                          });
                        },
                        child: TabCard(
                          name: tabs[index],
                          isSelected: selectedTabIndex == index,
                        ),
                      );
                    },
                  ),
                ),
                buildTabContent(selectedTabIndex),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
