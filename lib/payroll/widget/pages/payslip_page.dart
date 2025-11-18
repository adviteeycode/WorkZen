import 'package:flutter/material.dart';

class PayslipPage extends StatelessWidget {
  const PayslipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payslips', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Expanded(child: Center(child: Text('Payslip viewer and export UI'))),
      ],
    );
  }
}
