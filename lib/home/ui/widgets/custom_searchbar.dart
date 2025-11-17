import 'package:flutter/material.dart';

class CustomSearchbar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const CustomSearchbar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        prefixIcon: Icon(Icons.search, color: theme.iconTheme.color),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: theme.iconTheme.color),
                onPressed: onClear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: theme.dividerColor),
        ),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
      ),
    );
  }
}
