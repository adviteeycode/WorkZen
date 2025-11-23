import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/pages/dashboard/dashboard_layout.dart';
import 'package:workzen/pages/dashboard/employee_detail_page.dart'
    show EmployeeDetailPage;
import 'package:workzen/pages/dashboard/reports_page.dart' show ReportsPage;
import 'package:workzen/pages/settings_page.dart' show SettingsPage;
import 'package:workzen/providers/auth_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Admin Dashboard',
      tabs: [
        DashboardTab(
          label: 'Overview',
          icon: Icons.home_outlined,
          content: _buildOverview(context),
        ),
        DashboardTab(
          label: 'Users',
          icon: Icons.people_outline,
          content: _buildUsers(context),
        ),
        DashboardTab(
          label: 'Reports',
          icon: Icons.bar_chart_outlined,
          content: _buildReports(context),
        ),
        DashboardTab(
          label: 'Settings',
          icon: Icons.settings_outlined,
          content: _buildSettings(context),
        ),
      ],
    );
  }

  static Widget _buildOverview(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUser;
        final companyId = currentUser?.companyId;

        if (companyId == null) {
          return Center(
            child: Text(
              'Company information not available',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('companyId', isEqualTo: companyId)
                  .snapshots(),
              builder: (context, snapshot) {
                int totalUsers = snapshot.data?.docs.length ?? 0;

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('companies')
                      .doc(companyId)
                      .snapshots(),
                  builder: (context, companySnapshot) {
                    final companyData =
                        companySnapshot.data?.data() as Map<String, dynamic>?;
                    final companyName = companyData?['name'] ?? 'Company';

                    return Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 4,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            _buildStatCard(
                              context,
                              'Total Users',
                              totalUsers.toString(),
                              Icons.people,
                              theme.colorScheme.primary,
                            ),
                            _buildStatCard(
                              context,
                              'Company',
                              companyName,
                              Icons.business,
                              Colors.blue,
                            ),
                            _buildStatCard(
                              context,
                              'System Health',
                              '100%',
                              Icons.health_and_safety,
                              Colors.green,
                            ),
                            _buildStatCard(
                              context,
                              'Pending Approvals',
                              '0',
                              Icons.pending_actions,
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'System Activity',
                          style: theme.textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        _buildActivityCard(
                          context,
                          'System Status',
                          'All systems operational',
                          Icons.check_circle,
                          Colors.green,
                        ),
                        const SizedBox(height: 12),
                        _buildActivityCard(
                          context,
                          'Last Sync',
                          'Just now',
                          Icons.cloud_done,
                          Colors.blue,
                        ),
                        const SizedBox(height: 12),
                        _buildActivityCard(
                          context,
                          'Database',
                          'Connected and synced',
                          Icons.storage,
                          Colors.purple,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineLarge?.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  static Widget _buildActivityCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildUsers(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUser;
        final companyId = currentUser?.companyId;

        if (companyId == null) {
          return Center(
            child: Text(
              'Company information not available',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('User Management', style: theme.textTheme.headlineMedium),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('companyId', isEqualTo: companyId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No users found',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ),
                  );
                }

                final users = snapshot.data!.docs;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    children: List.generate(
                      users.length,
                      (index) => _buildUserRow(
                        context,
                        users[index],
                        index,
                        users.length,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _buildUserRow(
    BuildContext context,
    DocumentSnapshot userDoc,
    int index,
    int totalUsers,
  ) {
    final theme = Theme.of(context);
    final userData = userDoc.data() as Map<String, dynamic>;
    final userId = userDoc.id;
    final firstName = userData['firstName'] ?? 'User';
    final lastName = userData['lastName'] ?? '';
    final email = userData['email'] ?? 'N/A';
    final role = userData['role'] ?? 'employee';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: index != totalUsers - 1
            ? Border(bottom: BorderSide(color: theme.colorScheme.outline))
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              firstName[0].toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$firstName $lastName',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(email, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              role,
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeDetailPage(employeeId: userId),
                ),
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('View/Edit'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReports(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Reports', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        ...[
              (
                'Attendance Report',
                'Monthly attendance summary',
                Icons.calendar_today,
              ),
              ('Payroll Report', 'Salary distribution records', Icons.receipt),
              ('Leave Report', 'Leave application trends', Icons.event),
              (
                'User Activity Log',
                'System access and activities',
                Icons.history,
              ),
            ]
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildReportCard(context, e.$1, e.$2, e.$3),
              ),
            )
            .toList(),
      ],
    );
  }

  static Widget _buildReportCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportsPage(reportType: title),
                ),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  static Widget _buildSettings(BuildContext context) {
    return const SettingsPage();
  }
}
