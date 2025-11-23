import 'package:flutter/material.dart';
import 'package:workzen/pages/dashboard/dashboard_layout.dart';

class PayrollDashboard extends StatelessWidget {
  const PayrollDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Payroll Dashboard',
      tabs: [
        DashboardTab(
          label: 'Dashboard',
          icon: Icons.home_outlined,
          content: _buildOverview(context),
        ),
        DashboardTab(
          label: 'Payslips',
          icon: Icons.receipt_outlined,
          content: _buildPayslips(context),
        ),
        DashboardTab(
          label: 'Payrun',
          icon: Icons.payments_outlined,
          content: _buildPayrun(context),
        ),
        DashboardTab(
          label: 'Reports',
          icon: Icons.bar_chart_outlined,
          content: _buildReports(context),
        ),
      ],
    );
  }

  static Widget _buildOverview(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
              'Total Payroll',
              '₹12.5L',
              Icons.payments,
              theme.colorScheme.primary,
            ),
            _buildStatCard(
              context,
              'Employees Paid',
              '124',
              Icons.people,
              Colors.blue,
            ),
            _buildStatCard(
              context,
              'Pending Payroll',
              '3',
              Icons.pending_actions,
              Colors.orange,
            ),
            _buildStatCard(
              context,
              'This Month Total',
              '₹85.2L',
              Icons.trending_up,
              Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text('Recent Payroll Activity', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        _buildActivityCard(
          context,
          'November Payroll Processed',
          'All employees paid successfully',
          Icons.check_circle,
          Colors.green,
        ),
        const SizedBox(height: 12),
        _buildActivityCard(
          context,
          'October Payslips Generated',
          '124 payslips created',
          Icons.receipt,
          Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildActivityCard(
          context,
          'Tax Compliance Report',
          'Submitted to authorities',
          Icons.description,
          Colors.purple,
        ),
      ],
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

  static Widget _buildPayslips(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Payslip Management', style: theme.textTheme.headlineMedium),
            DropdownButton<String>(
              value: 'November 2024',
              items: ['November 2024', 'October 2024', 'September 2024'].map((
                month,
              ) {
                return DropdownMenuItem(value: month, child: Text(month));
              }).toList(),
              onChanged: (value) {},
            ),
          ],
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
              (index) => _buildPayslipRow(context, index),
            ),
          ),
        ),
      ],
    );
  }

  static Widget _buildPayslipRow(BuildContext context, int index) {
    final theme = Theme.of(context);
    final names = [
      'John Doe',
      'Jane Smith',
      'Bob Johnson',
      'Alice Williams',
      'Charlie Brown',
    ];
    final salaries = ['₹50,000', '₹55,000', '₹60,000', '₹65,000', '₹52,000'];
    final statuses = ['Paid', 'Paid', 'Pending', 'Paid', 'Paid'];
    final statusColors = [
      Colors.green,
      Colors.green,
      Colors.orange,
      Colors.green,
      Colors.green,
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
                Text(salaries[index], style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
          const SizedBox(width: 8),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(child: Text('View')),
              const PopupMenuItem(child: Text('Download')),
              const PopupMenuItem(child: Text('Send Email')),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _buildPayrun(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payrun Processing', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
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
                'Create New Payrun',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Select Month',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Payrun Name',
                  hintText: 'e.g., November 2024 Regular Payrun',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Calculate Payrun'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Preview'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Text('Recent Payruns', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        ...[
              ('November 2024', 'Processed', Colors.green),
              ('October 2024', 'Completed', Colors.blue),
              ('September 2024', 'Completed', Colors.blue),
            ]
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPayrunCard(context, e.$1, e.$2, e.$3),
              ),
            )
            .toList(),
      ],
    );
  }

  static Widget _buildPayrunCard(
    BuildContext context,
    String month,
    String status,
    Color statusColor,
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
            child: Icon(Icons.payments, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '124 employees included',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
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
        Text('Payroll Reports', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        ...[
              (
                'Salary Register',
                'Complete salary details of all employees',
                Icons.table_chart,
              ),
              (
                'Tax Summary',
                'Income tax and deductions summary',
                Icons.receipt,
              ),
              (
                'Attendance Summary',
                'Attendance-based deductions',
                Icons.calendar_today,
              ),
              (
                'Compliance Report',
                'EPF, ESI and other statutory compliance',
                Icons.verified,
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
          ElevatedButton(onPressed: () {}, child: const Text('Generate')),
        ],
      ),
    );
  }
}
