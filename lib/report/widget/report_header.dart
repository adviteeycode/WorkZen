import 'package:flutter/material.dart';

/// ReportHeader: Header for Reports tab with title and search bar
class ReportHeader extends StatelessWidget {
  final Widget? searchBar;
  const ReportHeader({super.key, this.searchBar});

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
            child: Text('Reports', style: theme.textTheme.titleLarge),
          ),
          if (searchBar != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: searchBar!,
              ),
            ),
        ],
      ),
    );
  }
}
