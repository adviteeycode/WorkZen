import 'package:flutter/material.dart';

class TabCard extends StatelessWidget {
  const TabCard({super.key, required this.name, required this.isSelected});
  final String name;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        name,
        style: theme.textTheme.bodyLarge!.copyWith(
          overflow: TextOverflow.ellipsis,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: isSelected
              ? theme.textTheme.bodyLarge!.fontSize! + 2
              : theme.textTheme.bodyLarge!.fontSize,
          color: isSelected
              ? theme.colorScheme.primary
              : theme.textTheme.bodyLarge!.color,
        ),
      ),
    );
  }
}
