import 'package:flutter/material.dart';
import 'pages/payroll_dashboard_page.dart';
import 'pages/payrun_page.dart';
import 'pages/payslip_page.dart';
import 'pages/salary_breakdown_page.dart';

/// PayrollBody: primary content area for payroll. Shows horizontal tabs and
/// content area for the selected payroll subpage.
class PayrollBody extends StatefulWidget {
  const PayrollBody({super.key});

  @override
  State<PayrollBody> createState() => _PayrollBodyState();
}

class _PayrollBodyState extends State<PayrollBody> {
  int _selected = 0;

  final List<String> _menu = [
    'Dashboard',
    'Payrun',
    'Payslips',
    'Salary Breakdown',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // small: <500 (icon only), medium: 500-800 (name only), large: >800 (both)
    final showIcon = screenWidth < 500 || screenWidth >= 800;
    final showName = screenWidth >= 500;

    return Expanded(
      flex: 9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_menu.length, (index) {
                final selected = index == _selected;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selected = index;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: showName ? 16 : 12,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: selected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showIcon)
                          Icon(
                            _iconFor(index),
                            size: 20,
                            color: selected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).hintColor,
                          ),
                        if (showIcon && showName) const SizedBox(width: 8),
                        if (showName)
                          Text(
                            _menu[index],
                            style: TextStyle(
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: selected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          Divider(height: 1),
          // Content area below tabs
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildPage(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(int index) {
    switch (index) {
      case 0:
        return Icons.dashboard_outlined;
      case 1:
        return Icons.payments_outlined;
      case 2:
        return Icons.receipt_long_outlined;
      case 3:
        return Icons.account_balance_wallet_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildPage() {
    switch (_selected) {
      case 0:
        return PayrollDashboardPage();
      case 1:
        return PayrunPage();
      case 2:
        return PayslipPage();
      case 3:
        return SalaryBreakdownPage();
      default:
        return Center(child: Text('Unknown'));
    }
  }
}
