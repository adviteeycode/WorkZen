import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/pages/dashboard/dashboard_layout.dart';
import 'package:workzen/providers/auth_provider.dart';

class HRDashboard extends StatelessWidget {
  const HRDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'HR Dashboard',
      tabs: [
        DashboardTab(
          label: 'Dashboard',
          icon: Icons.home_outlined,
          content: _buildOverview(context),
        ),
        DashboardTab(
          label: 'Leave Approvals',
          icon: Icons.checklist_outlined,
          content: _buildLeaveApprovals(context),
        ),
        DashboardTab(
          label: 'Employees',
          icon: Icons.people_outline,
          content: _buildEmployees(context),
        ),
        DashboardTab(
          label: 'Recruitment',
          icon: Icons.work_outline,
          content: _buildRecruitment(context),
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
            FutureBuilder<Map<String, int>>(
              future: _getHRStats(companyId),
              builder: (context, snapshot) {
                final stats = snapshot.data ?? {};
                final totalEmployees = stats['employees'] ?? 0;
                final leaveApplications = stats['leaves'] ?? 0;
                final openPositions = stats['positions'] ?? 0;
                final pendingActions = stats['pending'] ?? 0;

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
                          'Total Employees',
                          totalEmployees.toString(),
                          Icons.people,
                          theme.colorScheme.primary,
                        ),
                        _buildStatCard(
                          context,
                          'Leave Applications',
                          leaveApplications.toString(),
                          Icons.assignment,
                          Colors.orange,
                        ),
                        _buildStatCard(
                          context,
                          'Open Positions',
                          openPositions.toString(),
                          Icons.work,
                          Colors.blue,
                        ),
                        _buildStatCard(
                          context,
                          'Pending Actions',
                          pendingActions.toString(),
                          Icons.pending_actions,
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Recent Leave Applications',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLeaveApplicationCard(context, index),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  static Future<Map<String, int>> _getHRStats(String companyId) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .get();

      final leaveSnapshot = await FirebaseFirestore.instance
          .collection('leave')
          .where('companyId', isEqualTo: companyId)
          .where('status', isEqualTo: 'pending')
          .get();

      return {
        'employees': usersSnapshot.docs.length,
        'leaves': leaveSnapshot.docs.length,
        'positions': 0,
        'pending': leaveSnapshot.docs.length,
      };
    } catch (e) {
      return {'employees': 0, 'leaves': 0, 'positions': 0, 'pending': 0};
    }
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

  static Widget _buildLeaveApplicationCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final names = ['John Doe', 'Jane Smith', 'Bob Johnson'];
    final types = ['Casual Leave', 'Sick Leave', 'Earned Leave'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              names[index][0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  names[index],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(types[index], style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Approve')),
              const SizedBox(width: 8),
              OutlinedButton(onPressed: () {}, child: const Text('Reject')),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildLeaveApprovals(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Leave Approvals', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        ...List.generate(
          5,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildApprovalCard(context, index),
          ),
        ),
      ],
    );
  }

  static Widget _buildApprovalCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final names = [
      'John Doe',
      'Jane Smith',
      'Bob Johnson',
      'Alice Williams',
      'Charlie Brown',
    ];
    final statuses = [
      'Pending',
      'Pending',
      'Under Review',
      'Pending',
      'Under Review',
    ];
    final statusColors = [
      Colors.orange,
      Colors.orange,
      Colors.blue,
      Colors.orange,
      Colors.blue,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surface,
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                names[index],
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColors[index].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  statuses[index],
                  style: TextStyle(
                    color: statusColors[index],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Leave Type', style: theme.textTheme.bodySmall),
                  Text('Casual Leave', style: theme.textTheme.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duration', style: theme.textTheme.bodySmall),
                  Text('3 Days', style: theme.textTheme.bodyMedium),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From', style: theme.textTheme.bodySmall),
                  Text('Nov 20', style: theme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text('Approve'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Reject'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildEmployees(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Employee Directory', style: theme.textTheme.headlineMedium),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add),
              label: const Text('Add Employee'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        TextField(
          decoration: InputDecoration(
            hintText: 'Search employees...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            children: List.generate(
              5,
              (index) => _buildEmployeeRow(context, index),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildEmployeeRow(BuildContext context, int index) {
    final theme = Theme.of(context);
    final names = [
      'John Doe',
      'Jane Smith',
      'Bob Johnson',
      'Alice Williams',
      'Charlie Brown',
    ];
    final departments = ['Engineering', 'Marketing', 'Sales', 'HR', 'Finance'];
    final emails = [
      'john@example.com',
      'jane@example.com',
      'bob@example.com',
      'alice@example.com',
      'charlie@example.com',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: index != 4
            ? Border(bottom: BorderSide(color: theme.colorScheme.outline))
            : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              names[index][0],
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  names[index],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(departments[index], style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Text(emails[index], style: theme.textTheme.bodyMedium),
          const SizedBox(width: 16),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('View Profile')),
              const PopupMenuItem(child: Text('Edit')),
              const PopupMenuItem(child: Text('Remove')),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildRecruitment(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Open Positions', style: theme.textTheme.headlineMedium),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text('Create Position'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ...[
              ('Senior Software Engineer', 'Engineering', 5),
              ('Product Manager', 'Product', 2),
              ('Sales Executive', 'Sales', 3),
            ]
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPositionCard(context, e.$1, e.$2, e.$3),
              ),
            )
            .toList(),
      ],
    );
  }

  static Widget _buildPositionCard(
    BuildContext context,
    String title,
    String department,
    int applications,
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
            child: Icon(Icons.work, color: theme.colorScheme.primary),
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
                Text(department, style: theme.textTheme.bodyMedium),
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
              '$applications Applications',
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
