import 'package:flutter/material.dart';
import 'pages/salary_statement_report_page.dart';

/// ReportBody: Main content area for reports with tabs and content
class ReportBody extends StatefulWidget {
  const ReportBody({super.key});

  @override
  State<ReportBody> createState() => _ReportBodyState();
}

class _ReportBodyState extends State<ReportBody> {
  int _selected = 0;

  final List<String> _menu = [
    'Salary Statement',
    'Attendance Report',
    'Leave Report',
    'Payroll Report',
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
        return Icons.description_outlined;
      case 1:
        return Icons.calendar_month_outlined;
      case 2:
        return Icons.assignment_outlined;
      case 3:
        return Icons.summarize_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildPage() {
    switch (_selected) {
      case 0:
        return SalaryStatementReportPage();
      case 1:
        return Center(child: Text('Attendance Report - Coming Soon'));
      case 2:
        return Center(child: Text('Leave Report - Coming Soon'));
      case 3:
        return Center(child: Text('Payroll Report - Coming Soon'));
      default:
        return Center(child: Text('Unknown'));
    }
  }
}
