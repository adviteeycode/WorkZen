import 'package:flutter/material.dart';
import 'package:workzen/employee/ui/widgets/employee_card.dart';

class EmployeeHeader extends StatefulWidget {
  const EmployeeHeader({super.key, required this.searchBar});

  final Widget searchBar;

  @override
  State<EmployeeHeader> createState() => _EmployeeHeaderState();
}

class _EmployeeHeaderState extends State<EmployeeHeader> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(onPressed: () {}, child: const Text("New")),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.searchBar,
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeBody extends StatefulWidget {
  const EmployeeBody({super.key});

  @override
  State<EmployeeBody> createState() => _EmployeeBodyState();
}

class _EmployeeBodyState extends State<EmployeeBody> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: GridView.builder(
        itemCount: 10,
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, // Max width per card
          mainAxisExtent: 115,
        ),
        itemBuilder: (context, index) {
          return EmployeeCard(name: 'Employee ${index + 1}', isCheckedIn: true);
        },
      ),
    );
  }
}
