import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:workzen/user_role.dart';

class AttendanceHeader extends StatelessWidget {
  final Widget searchBar;
  final UserRole role;

  const AttendanceHeader({
    super.key,
    required this.searchBar,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Attendance',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),

          // Only Admin gets Search Bar
          if (role == UserRole.admin)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: searchBar,
              ),
            ),
        ],
      ),
    );
  }
}

class AttendanceBody extends StatefulWidget {
  final UserRole role;

  const AttendanceBody({super.key, required this.role});

  @override
  State<AttendanceBody> createState() => _AttendanceBodyState();
}

class _AttendanceBodyState extends State<AttendanceBody> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get isAdmin => widget.role == UserRole.admin;
  bool get isEmployee => widget.role == UserRole.employee;

  String get formattedSelectedDate =>
      "${selectedDate.day}, ${_monthName(selectedDate.month)} ${selectedDate.year}";

  String get formattedSelectedMonth =>
      "${_monthName(selectedMonth.month)} ${selectedMonth.year}";

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }

  bool _isBeforeDay(DateTime d1, DateTime d2) {
    return DateTime(
      d1.year,
      d1.month,
      d1.day,
    ).isBefore(DateTime(d2.year, d2.month, d2.day));
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topFilters(),
          const SizedBox(height: 10),

          // Admin → date display
          if (isAdmin) _selectedDateWidget(),

          // Employee → month display
          if (isEmployee) _selectedMonthWidget(),

          const SizedBox(height: 10),
          _tableHeader(),
          Expanded(child: _attendanceList()),
        ],
      ),
    );
  }

  // ---------------- TOP FILTERS ----------------
  Widget _topFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (isAdmin) ...[
            _squareButton(
              Icons.keyboard_double_arrow_left_sharp,
              onTap: () {
                setState(() {
                  selectedDate = selectedDate.subtract(const Duration(days: 1));
                });
              },
            ),
            const SizedBox(width: 8),
            _squareButton(
              Icons.keyboard_double_arrow_right_sharp,
              onTap: () {
                if (_isBeforeDay(selectedDate, DateTime.now())) {
                  setState(() {
                    selectedDate = selectedDate.add(const Duration(days: 1));
                  });
                }
              },
            ),
            const SizedBox(width: 12),
            _datePickerButton(),
          ],

          if (isEmployee) _monthPickerButton(),

          const SizedBox(width: 12),

          if (isEmployee)
            Expanded(
              child: SizedBox(
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _summaryBox("Attendance Days: 05"),
                      const SizedBox(width: 4),
                      _summaryBox("Leaves: 00"),
                      const SizedBox(width: 4),
                      _summaryBox("Working Days: 05"),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _squareButton(IconData icon, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 22),
      ),
    );
  }

  Widget _summaryBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  // ---------------- ADMIN DATE PICKER ----------------
  Widget _datePickerButton() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (!mounted) return;
        if (picked != null) {
          setState(() => selectedDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text(
              "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // ---------------- EMPLOYEE MONTH PICKER ----------------
  Widget _monthPickerButton() {
    return InkWell(
      onTap: () async {
        final picked = await showMonthPicker(
          context: context,
          initialDate: selectedMonth,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(), // No future months
        );

        if (!mounted) return;
        if (picked != null) {
          setState(() {
            selectedMonth = DateTime(picked.year, picked.month);
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text("${_monthName(selectedMonth.month)} ${selectedMonth.year}"),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // ---------------- SELECTED DATE (ADMIN) ----------------
  Widget _selectedDateWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        formattedSelectedDate,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ---------------- SELECTED MONTH (EMPLOYEE) ----------------
  Widget _selectedMonthWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        formattedSelectedMonth,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  // ---------------- TABLE HEADER ----------------
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.grey.withOpacity(0.1),
      child: const Row(
        children: [
          Expanded(child: Text("Date")),
          Expanded(child: Text("Check In")),
          Expanded(child: Text("Check Out")),
          Expanded(child: Text("Work Hours")),
          Expanded(child: Text("Extra Hours")),
        ],
      ),
    );
  }

  // ---------------- TABLE ROWS ----------------
  Widget _attendanceList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Expanded(child: Text("28/10/2025")),
              Expanded(child: Text("10:00")),
              Expanded(child: Text("19:00")),
              Expanded(child: Text("09:00")),
              Expanded(child: Text("01:00")),
            ],
          ),
        );
      },
    );
  }
}
