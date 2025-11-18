import 'package:flutter/material.dart';

class SalaryBreakdownPage extends StatelessWidget {
  const SalaryBreakdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salary Breakdown',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Center(child: Text('Salary structures and components')),
        ),
      ],
    );
  }
}
