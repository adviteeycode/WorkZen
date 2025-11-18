import 'package:flutter/material.dart';

class PayrollDashboardPage extends StatelessWidget {
  const PayrollDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payroll Dashboard',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(4, (i) => _statCard(context, i)),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Center(child: Text('Payroll charts and lists go here')),
        ),
      ],
    );
  }

  Widget _statCard(BuildContext context, int i) {
    final labels = ['Employees', 'Employer Cost', 'Gross Wage', 'Net Wage'];
    final values = ['120', '₹ 1,250,000', '₹ 980,000', '₹ 700,000'];
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(labels[i], style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          Text(
            values[i],
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
