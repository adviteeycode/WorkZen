import 'package:flutter/material.dart';

class SalaryStatementReportPage extends StatefulWidget {
  const SalaryStatementReportPage({Key? key}) : super(key: key);

  @override
  State<SalaryStatementReportPage> createState() =>
      _SalaryStatementReportPageState();
}

class _SalaryStatementReportPageState extends State<SalaryStatementReportPage> {
  String? selectedEmployee;
  String? selectedYear;

  final List<String> employees = [
    'John Doe',
    'Jane Smith',
    'Robert Johnson',
    'Emily Davis',
  ];

  final List<String> years = ['2024', '2023', '2022', '2021'];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and Print button in a Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Salary Statement Report',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: (selectedEmployee != null && selectedYear != null)
                  ? () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Generating report for $selectedEmployee - $selectedYear',
                          ),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.print),
              label: const Text('Print'),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Filters: responsive - column on small screens, horizontal row otherwise
        if (isSmall)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 56,
                child: DropdownButtonFormField<String>(
                  value: selectedEmployee,
                  hint: const Text('Select Employee'),
                  items: employees
                      .map(
                        (emp) => DropdownMenuItem(value: emp, child: Text(emp)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedEmployee = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 56,
                child: DropdownButtonFormField<String>(
                  value: selectedYear,
                  hint: const Text('Select Year'),
                  items: years
                      .map(
                        (year) =>
                            DropdownMenuItem(value: year, child: Text(year)),
                      )
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedYear = val;
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: selectedEmployee,
                    hint: const Text('Select Employee'),
                    items: employees
                        .map(
                          (emp) =>
                              DropdownMenuItem(value: emp, child: Text(emp)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedEmployee = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: selectedYear,
                    hint: const Text('Select Year'),
                    items: years
                        .map(
                          (year) =>
                              DropdownMenuItem(value: year, child: Text(year)),
                        )
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedYear = val;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        const SizedBox(height: 24),

        // Report Content
        if (selectedEmployee != null && selectedYear != null)
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Text(
                      '[Company]',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.red),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Salary Statement Report',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    Divider(),

                    // Employee Info
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Employee Name',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            Text(selectedEmployee!),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Date Of Joining',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            Text('01/01/$selectedYear'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Designation',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            Text('Senior Developer'),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Salary Effective From',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            Text('01/01/$selectedYear'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(),

                    // Salary Components Table
                    _buildSalaryTable(context),
                  ],
                ),
              ),
            ),
          )
        else
          Expanded(
            child: Center(
              child: Text('Select employee and year to generate report'),
            ),
          ),
      ],
    );
  }

  Widget _buildSalaryTable(BuildContext context) {
    return Column(
      children: [
        // Header Row
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Salary Components',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Monthly Amount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Yearly Amount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Earnings Section
        Text(
          'Earnings',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _salaryRow(context, 'Basic', '₹ 50,000', '₹ 6,00,000'),
        _salaryRow(context, 'HRA', '₹ 12,233', '₹ 1,46,800'),
        _salaryRow(context, 'DA', '₹ 5,000', '₹ 60,000'),
        const SizedBox(height: 16),

        // Deductions Section
        Text(
          'Deductions',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _salaryRow(context, 'PF', '₹ 5,500', '₹ 66,000'),
        _salaryRow(context, 'IT', '₹ 2,000', '₹ 24,000'),
        const SizedBox(height: 16),

        // Net Salary
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Net Salary',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₹ 59,733',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '₹ 7,16,800',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _salaryRow(
    BuildContext context,
    String label,
    String monthly,
    String yearly,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(
            flex: 2,
            child: Text(
              monthly,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              yearly,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
