import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workzen/pages/dashboard/dashboard_layout.dart';
import 'package:workzen/providers/auth_provider.dart';

class EmployeeDashboard extends StatelessWidget {
  const EmployeeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Employee Dashboard',
      tabs: [
        DashboardTab(
          label: 'Overview',
          icon: Icons.home_outlined,
          content: _buildOverview(context),
        ),
        DashboardTab(
          label: 'Attendance',
          icon: Icons.check_circle_outline,
          content: _buildAttendance(context),
        ),
        DashboardTab(
          label: 'Leave',
          icon: Icons.calendar_today_outlined,
          content: _buildLeave(context),
        ),
        DashboardTab(
          label: 'Payslip',
          icon: Icons.receipt_outlined,
          content: _buildPayslip(context),
        ),
      ],
    );
  }

  static Widget _buildOverview(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUser;
        if (currentUser == null) {
          return Center(
            child: Text('Not logged in', style: theme.textTheme.bodyMedium),
          );
        }

        final now = DateTime.now();
        return FutureBuilder<Map<String, dynamic>>(
          future: _getAttendanceSummary(
            currentUser.userId,
            now.month,
            now.year,
          ),
          builder: (context, attendanceSnapshot) {
            int presentDays = 0;
            int absentDays = 0;

            if (attendanceSnapshot.hasData) {
              presentDays = attendanceSnapshot.data?['present'] ?? 0;
              absentDays = attendanceSnapshot.data?['absent'] ?? 0;
            }

            return FutureBuilder<int>(
              future: _getLeaveBalance(currentUser.userId),
              builder: (context, leaveSnapshot) {
                int leaveBalance = 0;
                if (leaveSnapshot.hasData) {
                  leaveBalance = leaveSnapshot.data ?? 0;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildStatCard(
                          context,
                          'Present Days',
                          '$presentDays',
                          Icons.check_circle,
                          theme.colorScheme.primary,
                        ),
                        _buildStatCard(
                          context,
                          'Absent Days',
                          '$absentDays',
                          Icons.cancel,
                          Colors.red,
                        ),
                        _buildStatCard(
                          context,
                          'Leave Balance',
                          '$leaveBalance',
                          Icons.event,
                          Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Recent Activity',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),
                    _buildRecentActivityStream(context, currentUser.userId),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  static Future<Map<String, dynamic>> _getAttendanceSummary(
    String userId,
    int month,
    int year,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .where(
            'date',
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime(year, month, 1),
            ),
          )
          .where(
            'date',
            isLessThan: Timestamp.fromDate(DateTime(year, month + 1, 1)),
          )
          .get();

      int present = 0;
      int absent = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'unmarked';
        if (status == 'present') present++;
        if (status == 'absent') absent++;
      }

      return {'present': present, 'absent': absent};
    } catch (e) {
      return {'present': 0, 'absent': 0};
    }
  }

  static Future<int> _getLeaveBalance(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('leave')
          .where('userId', isEqualTo: userId)
          .get();

      int balance = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['status'] == 'approved') {
          final days = (data['numberOfDays'] ?? 0) as num;
          balance += days.toInt();
        }
      }
      return balance;
    } catch (e) {
      return 0;
    }
  }

  static Widget _buildRecentActivityStream(
    BuildContext context,
    String userId,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('attendance')
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: true)
          .limit(3)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No recent activity',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final date = (data['date'] as Timestamp).toDate();
            final status = data['status'] ?? 'unmarked';

            final formattedDate = _formatDate(date);
            final icon = status == 'present'
                ? Icons.check_circle
                : status == 'absent'
                ? Icons.cancel
                : Icons.help;
            final color = status == 'present'
                ? Colors.green
                : status == 'absent'
                ? Colors.red
                : Colors.orange;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildActivityCard(
                context,
                'Attendance - ${status.toUpperCase()}',
                formattedDate,
                icon,
                color,
              ),
            );
          }).toList(),
        );
      },
    );
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return 'Yesterday at ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      final diff = today.difference(dateOnly).inDays;
      return '$diff days ago';
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

  static Widget _buildAttendance(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.surface,
            border: Border.all(color: theme.colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mark Attendance',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.calendar_today),
                label: const Text('Select Date & Mark Present'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text('Attendance History', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final currentUser = authProvider.currentUser;
            if (currentUser == null) {
              return Text('Not logged in', style: theme.textTheme.bodyMedium);
            }

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendance')
                  .where('userId', isEqualTo: currentUser.userId)
                  .orderBy('date', descending: true)
                  .limit(10)
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
                        'No attendance records',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                return Column(
                  children: snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final date = (data['date'] as Timestamp).toDate();
                    final status = data['status'] ?? 'unmarked';

                    final statusColor = status == 'present'
                        ? Colors.green
                        : status == 'absent'
                        ? Colors.red
                        : Colors.orange;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: theme.colorScheme.surface,
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  status.toUpperCase(),
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  static Widget _buildLeave(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Apply for Leave'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 32),
        Text('Leave Balance', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            final currentUser = authProvider.currentUser;
            if (currentUser == null) {
              return Text('Not logged in', style: theme.textTheme.bodyMedium);
            }

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _getLeaveTypes(currentUser.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No leave data available',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                return Column(
                  children: snapshot.data!.map((leaveData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _buildLeaveBalanceCard(
                        context,
                        leaveData['type'],
                        leaveData['total'],
                        leaveData['used'],
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }

  static Future<List<Map<String, dynamic>>> _getLeaveTypes(
    String userId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('leave')
          .where('userId', isEqualTo: userId)
          .get();

      Map<String, int> leaveCounts = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final type = data['leaveType'] ?? 'Leave';
        final status = data['status'] ?? '';
        final days = (data['numberOfDays'] ?? 0) as num;

        if (!leaveCounts.containsKey(type)) {
          leaveCounts[type] = 0;
        }

        if (status == 'approved') {
          leaveCounts[type] = (leaveCounts[type] ?? 0) + days.toInt();
        }
      }

      // Default leave types with their total allocations
      const defaultLeaves = {
        'Casual Leave': 8,
        'Sick Leave': 10,
        'Earned Leave': 12,
      };

      List<Map<String, dynamic>> result = [];
      defaultLeaves.forEach((type, total) {
        final used = leaveCounts[type] ?? 0;
        result.add({'type': type, 'total': total, 'used': used});
      });

      return result;
    } catch (e) {
      return [];
    }
  }

  static Widget _buildLeaveBalanceCard(
    BuildContext context,
    String type,
    int total,
    int used,
  ) {
    final remaining = total - used;
    final percent = remaining / total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                '$remaining/$total',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPayslip(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final currentUser = authProvider.currentUser;
        if (currentUser == null) {
          return Center(
            child: Text('Not logged in', style: theme.textTheme.bodyMedium),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('payroll')
                  .where('userId', isEqualTo: currentUser.userId)
                  .orderBy('month', descending: true)
                  .limit(1)
                  .get()
                  .then((snapshot) {
                    if (snapshot.docs.isEmpty) {
                      throw Exception('No payroll records found');
                    }
                    return snapshot.docs.first;
                  }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'No payslip records available',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                final month = data['month'] ?? DateTime.now().month;
                final year = data['year'] ?? DateTime.now().year;
                final status = data['status'] ?? 'pending';

                final basicSalary = data['basicSalary'] ?? 0;
                final hra = data['hra'] ?? 0;
                final da = data['da'] ?? 0;
                final pfDeduction = data['pfDeduction'] ?? 0;
                final incomeTax = data['incomeTax'] ?? 0;
                final otherDeductions = data['otherDeductions'] ?? 0;

                final grossSalary = basicSalary + hra + da;
                final netSalary =
                    grossSalary - pfDeduction - incomeTax - otherDeductions;

                final monthName = _getMonthName(month);

                return Container(
                  padding: const EdgeInsets.all(20),
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
                            '$monthName $year',
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
                              color:
                                  (status == 'paid'
                                          ? Colors.green
                                          : Colors.orange)
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: status == 'paid'
                                    ? Colors.green
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildSalaryRow(
                        context,
                        'Basic Salary',
                        '₹${basicSalary.toStringAsFixed(0)}',
                      ),
                      _buildSalaryRow(
                        context,
                        'HRA',
                        '₹${hra.toStringAsFixed(0)}',
                      ),
                      _buildSalaryRow(
                        context,
                        'Dearness Allowance',
                        '₹${da.toStringAsFixed(0)}',
                      ),
                      Divider(color: theme.colorScheme.outline, height: 24),
                      _buildSalaryRow(
                        context,
                        'Gross Salary',
                        '₹${grossSalary.toStringAsFixed(0)}',
                        isTotal: true,
                      ),
                      Divider(color: theme.colorScheme.outline, height: 24),
                      _buildSalaryRow(
                        context,
                        'PF Deduction',
                        '-₹${pfDeduction.toStringAsFixed(0)}',
                        isDeduction: true,
                      ),
                      _buildSalaryRow(
                        context,
                        'Income Tax',
                        '-₹${incomeTax.toStringAsFixed(0)}',
                        isDeduction: true,
                      ),
                      _buildSalaryRow(
                        context,
                        'Other Deductions',
                        '-₹${otherDeductions.toStringAsFixed(0)}',
                        isDeduction: true,
                      ),
                      Divider(color: theme.colorScheme.outline, height: 24),
                      _buildSalaryRow(
                        context,
                        'Net Salary',
                        '₹${netSalary.toStringAsFixed(0)}',
                        isTotal: true,
                        isFinal: true,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.download),
                          label: const Text('Download'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  static String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  static Widget _buildSalaryRow(
    BuildContext context,
    String label,
    String amount, {
    bool isTotal = false,
    bool isFinal = false,
    bool isDeduction = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              fontSize: isFinal ? 16 : 14,
            ),
          ),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
              color: isDeduction ? Colors.red : null,
              fontSize: isFinal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
