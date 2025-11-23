import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workzen/providers/auth_provider.dart';

class ReportsPage extends StatefulWidget {
  final String reportType;

  const ReportsPage({super.key, required this.reportType});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  int? _selectedMonth;
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = now.month;
    _selectedYear = now.year;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text('${widget.reportType} Report'), elevation: 0),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final companyId = authProvider.currentUser?.companyId;

          if (companyId == null) {
            return Center(
              child: Text(
                'Company information not available',
                style: theme.textTheme.bodyMedium,
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFiltersSection(context),
                const SizedBox(height: 32),
                _buildReportContent(context, companyId),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context) {
    final theme = Theme.of(context);
    final months = List.generate(
      12,
      (index) => '${index + 1} - ${_getMonthName(index + 1)}',
    );
    final years = List.generate(5, (index) => DateTime.now().year - index);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Month', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: _selectedMonth,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() => _selectedMonth = value);
                  },
                  items: List.generate(
                    12,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text(months[index]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Year', style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                DropdownButton<int>(
                  value: _selectedYear,
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() => _selectedYear = value);
                  },
                  items: years
                      .map(
                        (year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportContent(BuildContext context, String companyId) {
    switch (widget.reportType) {
      case 'Attendance Report':
        return _buildAttendanceReport(context, companyId);
      case 'Payroll Report':
        return _buildPayrollReport(context, companyId);
      case 'Leave Report':
        return _buildLeaveReport(context, companyId);
      case 'User Activity Log':
        return _buildUserActivityLog(context, companyId);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildAttendanceReport(BuildContext context, String companyId) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchAttendanceData(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }

        final attendanceData = snapshot.data ?? [];

        if (attendanceData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No attendance data available',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        }

        // Calculate summary
        int totalDays = attendanceData.length;
        int presentDays = attendanceData
            .where((a) => a['status'] == 'present')
            .length;
        int absentDays = attendanceData
            .where((a) => a['status'] == 'absent')
            .length;
        int halfDays = attendanceData
            .where((a) => a['status'] == 'halfDay')
            .length;

        double attendance = totalDays > 0 ? (presentDays / totalDays * 100) : 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attendance Summary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildSummaryCard(
                  context,
                  'Present',
                  presentDays.toString(),
                  Colors.green,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Absent',
                  absentDays.toString(),
                  Colors.red,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Half Days',
                  halfDays.toString(),
                  Colors.orange,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Percentage',
                  '${attendance.toStringAsFixed(1)}%',
                  Colors.blue,
                  theme,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Detailed Attendance',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildAttendanceTable(context, attendanceData, theme),
          ],
        );
      },
    );
  }

  Widget _buildPayrollReport(BuildContext context, String companyId) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPayrollData(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }

        final payrollData = snapshot.data ?? [];

        if (payrollData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No payroll data available',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        }

        // Calculate totals
        double totalGross = payrollData.fold(
          0.0,
          (sum, e) => sum + (e['grossSalary'] ?? 0),
        );
        double totalDeductions = payrollData.fold(
          0.0,
          (sum, e) => sum + (e['totalDeductions'] ?? 0),
        );
        double totalNet = payrollData.fold(
          0.0,
          (sum, e) => sum + (e['netSalary'] ?? 0),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payroll Summary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildSummaryCard(
                  context,
                  'Total Gross',
                  '₹${totalGross.toStringAsFixed(2)}',
                  Colors.green,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Total Deductions',
                  '₹${totalDeductions.toStringAsFixed(2)}',
                  Colors.red,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Total Net',
                  '₹${totalNet.toStringAsFixed(2)}',
                  Colors.blue,
                  theme,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Employee Payslips',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildPayrollTable(context, payrollData, theme),
          ],
        );
      },
    );
  }

  Widget _buildLeaveReport(BuildContext context, String companyId) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchLeaveData(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }

        final leaveData = snapshot.data ?? [];

        if (leaveData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No leave data available',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        }

        // Calculate summary
        int approved = leaveData.where((l) => l['status'] == 'approved').length;
        int pending = leaveData.where((l) => l['status'] == 'pending').length;
        int rejected = leaveData.where((l) => l['status'] == 'rejected').length;
        int totalDays = leaveData.fold<int>(
          0,
          (sum, l) => sum + ((l['days'] as int?) ?? 0),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave Summary',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildSummaryCard(
                  context,
                  'Approved',
                  approved.toString(),
                  Colors.green,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Pending',
                  pending.toString(),
                  Colors.orange,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Rejected',
                  rejected.toString(),
                  Colors.red,
                  theme,
                ),
                _buildSummaryCard(
                  context,
                  'Total Days',
                  totalDays.toString(),
                  Colors.blue,
                  theme,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Leave Applications',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildLeaveTable(context, leaveData, theme),
          ],
        );
      },
    );
  }

  Widget _buildUserActivityLog(BuildContext context, String companyId) {
    final theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchUserActivityData(companyId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red),
            ),
          );
        }

        final activityData = snapshot.data ?? [];

        if (activityData.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'No activity data available',
                style: theme.textTheme.bodyLarge,
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Activity Log',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityTable(context, activityData, theme),
          ],
        );
      },
    );
  }

  // Helper methods for data fetching
  Future<List<Map<String, dynamic>>> _fetchAttendanceData(
    String companyId,
  ) async {
    try {
      final startDate = DateTime(_selectedYear ?? 2024, _selectedMonth ?? 1, 1);
      final endDate = DateTime(
        _selectedYear ?? 2024,
        (_selectedMonth ?? 1) + 1,
        0,
      );

      final snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('companyId', isEqualTo: companyId)
          .get();

      // Filter and sort in memory to avoid index requirement
      final filtered = snapshot.docs.where((doc) {
        final date =
            (doc.data()['date'] as Timestamp?)?.toDate() ?? DateTime.now();
        return date.isAfter(startDate) &&
            date.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      filtered.sort((a, b) {
        final dateA =
            (a.data()['date'] as Timestamp?)?.toDate() ?? DateTime.now();
        final dateB =
            (b.data()['date'] as Timestamp?)?.toDate() ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

      return filtered.map((doc) {
        final data = doc.data();
        return {
          'employeeName': data['employeeName'] ?? 'N/A',
          'date': (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'status': data['status'] ?? 'unmarked',
          'checkIn': (data['checkInTime'] as Timestamp?)?.toDate(),
          'checkOut': (data['checkOutTime'] as Timestamp?)?.toDate(),
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchPayrollData(String companyId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('payslips')
          .where('companyId', isEqualTo: companyId)
          .where('month', isEqualTo: _selectedMonth ?? 1)
          .where('year', isEqualTo: _selectedYear ?? 2024)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'employeeName': data['employeeName'] ?? 'N/A',
          'basicSalary': (data['basicSalary'] ?? 0).toDouble(),
          'grossSalary': (data['grossSalary'] ?? 0).toDouble(),
          'pfDeduction': (data['pfDeduction'] ?? 0).toDouble(),
          'ptDeduction': (data['ptDeduction'] ?? 0).toDouble(),
          'otherDeductions': (data['otherDeductions'] ?? 0).toDouble(),
          'totalDeductions':
              ((data['pfDeduction'] ?? 0) +
                      (data['ptDeduction'] ?? 0) +
                      (data['otherDeductions'] ?? 0))
                  .toDouble(),
          'netSalary': (data['netSalary'] ?? 0).toDouble(),
          'status': data['status'] ?? 'draft',
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchLeaveData(String companyId) async {
    try {
      final startDate = DateTime(_selectedYear ?? 2024, _selectedMonth ?? 1, 1);
      final endDate = DateTime(
        _selectedYear ?? 2024,
        (_selectedMonth ?? 1) + 1,
        0,
      );

      final snapshot = await FirebaseFirestore.instance
          .collection('leaves')
          .where('companyId', isEqualTo: companyId)
          .get();

      // Filter and sort in memory to avoid index requirement
      final filtered = snapshot.docs.where((doc) {
        final startDateField =
            (doc.data()['startDate'] as Timestamp?)?.toDate() ?? DateTime.now();
        return startDateField.isAfter(startDate) &&
            startDateField.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      filtered.sort((a, b) {
        final dateA =
            (a.data()['startDate'] as Timestamp?)?.toDate() ?? DateTime.now();
        final dateB =
            (b.data()['startDate'] as Timestamp?)?.toDate() ?? DateTime.now();
        return dateB.compareTo(dateA);
      });

      return filtered.map((doc) {
        final data = doc.data();
        return {
          'employeeName': data['employeeName'] ?? 'N/A',
          'leaveType': data['leaveType'] ?? 'Leave',
          'startDate':
              (data['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'endDate':
              (data['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'days': data['numberOfDays'] ?? 0,
          'status': data['status'] ?? 'pending',
          'reason': data['reason'] ?? 'N/A',
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserActivityData(
    String companyId,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('companyId', isEqualTo: companyId)
          .get();

      // Sort and limit in memory to avoid index requirement
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'name': '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}',
          'email': data['email'] ?? 'N/A',
          'role': data['role'] ?? 'employee',
          'lastActive':
              (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          'status': data['isActive'] == true ? 'Active' : 'Inactive',
        };
      }).toList();

      // Sort by lastActive descending
      users.sort((a, b) {
        final dateA = a['lastActive'] as DateTime;
        final dateB = b['lastActive'] as DateTime;
        return dateB.compareTo(dateA);
      });

      // Limit to 50 records
      return users.take(50).toList();
    } catch (e) {
      rethrow;
    }
  }

  // UI Builders
  Widget _buildSummaryCard(
    BuildContext context,
    String label,
    String value,
    Color color,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(
    BuildContext context,
    List<Map<String, dynamic>> data,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Employee', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Date', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Status', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Check-In', style: theme.textTheme.bodySmall)),
          DataColumn(
            label: Text('Check-Out', style: theme.textTheme.bodySmall),
          ),
        ],
        rows: data
            .map(
              (row) => DataRow(
                cells: [
                  DataCell(Text(row['employeeName'] ?? 'N/A')),
                  DataCell(Text(DateFormat('dd/MM/yyyy').format(row['date']))),
                  DataCell(_buildStatusBadge(row['status'], theme)),
                  DataCell(
                    Text(
                      row['checkIn'] != null
                          ? DateFormat('HH:mm').format(row['checkIn'])
                          : 'N/A',
                    ),
                  ),
                  DataCell(
                    Text(
                      row['checkOut'] != null
                          ? DateFormat('HH:mm').format(row['checkOut'])
                          : 'N/A',
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildPayrollTable(
    BuildContext context,
    List<Map<String, dynamic>> data,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Employee', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Basic', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Gross', style: theme.textTheme.bodySmall)),
          DataColumn(
            label: Text('Deductions', style: theme.textTheme.bodySmall),
          ),
          DataColumn(label: Text('Net', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Status', style: theme.textTheme.bodySmall)),
        ],
        rows: data
            .map(
              (row) => DataRow(
                cells: [
                  DataCell(Text(row['employeeName'] ?? 'N/A')),
                  DataCell(
                    Text('₹${(row['basicSalary'] ?? 0).toStringAsFixed(2)}'),
                  ),
                  DataCell(
                    Text('₹${(row['grossSalary'] ?? 0).toStringAsFixed(2)}'),
                  ),
                  DataCell(
                    Text(
                      '₹${(row['totalDeductions'] ?? 0).toStringAsFixed(2)}',
                    ),
                  ),
                  DataCell(
                    Text('₹${(row['netSalary'] ?? 0).toStringAsFixed(2)}'),
                  ),
                  DataCell(_buildStatusBadge(row['status'], theme)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildLeaveTable(
    BuildContext context,
    List<Map<String, dynamic>> data,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Employee', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Type', style: theme.textTheme.bodySmall)),
          DataColumn(
            label: Text('Start Date', style: theme.textTheme.bodySmall),
          ),
          DataColumn(label: Text('End Date', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Days', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Status', style: theme.textTheme.bodySmall)),
        ],
        rows: data
            .map(
              (row) => DataRow(
                cells: [
                  DataCell(Text(row['employeeName'] ?? 'N/A')),
                  DataCell(Text(row['leaveType'] ?? 'Leave')),
                  DataCell(
                    Text(DateFormat('dd/MM/yyyy').format(row['startDate'])),
                  ),
                  DataCell(
                    Text(DateFormat('dd/MM/yyyy').format(row['endDate'])),
                  ),
                  DataCell(Text('${row['days'] ?? 0}')),
                  DataCell(_buildStatusBadge(row['status'], theme)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildActivityTable(
    BuildContext context,
    List<Map<String, dynamic>> data,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Name', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Email', style: theme.textTheme.bodySmall)),
          DataColumn(label: Text('Role', style: theme.textTheme.bodySmall)),
          DataColumn(
            label: Text('Last Active', style: theme.textTheme.bodySmall),
          ),
          DataColumn(label: Text('Status', style: theme.textTheme.bodySmall)),
        ],
        rows: data
            .map(
              (row) => DataRow(
                cells: [
                  DataCell(Text(row['name'] ?? 'N/A')),
                  DataCell(Text(row['email'] ?? 'N/A')),
                  DataCell(Text(row['role'] ?? 'employee')),
                  DataCell(
                    Text(
                      row['lastActive'] != null
                          ? DateFormat(
                              'dd/MM/yyyy HH:mm',
                            ).format(row['lastActive'] as DateTime)
                          : 'N/A',
                    ),
                  ),
                  DataCell(_buildStatusBadge(row['status'] ?? 'N/A', theme)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildStatusBadge(String status, ThemeData theme) {
    Color backgroundColor;
    Color textColor;

    switch (status.toLowerCase()) {
      case 'present':
      case 'approved':
      case 'active':
        backgroundColor = Colors.green.withOpacity(0.2);
        textColor = Colors.green;
        break;
      case 'absent':
      case 'rejected':
      case 'inactive':
        backgroundColor = Colors.red.withOpacity(0.2);
        textColor = Colors.red;
        break;
      case 'pending':
        backgroundColor = Colors.orange.withOpacity(0.2);
        textColor = Colors.orange;
        break;
      case 'halfday':
        backgroundColor = Colors.blue.withOpacity(0.2);
        textColor = Colors.blue;
        break;
      default:
        backgroundColor = Colors.grey.withOpacity(0.2);
        textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getMonthName(int month) {
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
}
