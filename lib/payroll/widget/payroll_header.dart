import 'package:flutter/material.dart';

/// PayrollHeader: used in `home_screen.dart` as the header for Payroll tab.
class PayrollHeader extends StatelessWidget {
  final Widget searchBar;
  const PayrollHeader({super.key, required this.searchBar});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Payroll', style: theme.textTheme.titleLarge),
          ),
          Expanded(
            child: Padding(padding: const EdgeInsets.all(8), child: searchBar),
          ),
        ],
      ),
    );
  }
}
