import 'package:flutter/material.dart';

class PayrunPage extends StatelessWidget {
  const PayrunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payrun', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Generate payrun (placeholder)')),
            );
          },
          icon: Icon(Icons.playlist_add),
          label: Text('Generate Payrun'),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: Center(child: Text('Payrun list and controls go here')),
        ),
      ],
    );
  }
}
