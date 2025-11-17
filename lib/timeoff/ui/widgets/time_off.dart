import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:workzen/timeoff/ui/widgets/time_off_request_dialog.dart';
import 'package:workzen/user_role.dart';

class TimeOffHeader extends StatelessWidget {
  final Widget searchBar;
  final UserRole role;

  const TimeOffHeader({super.key, required this.searchBar, required this.role});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Time Off',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),

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

class TimeOffBody extends StatefulWidget {
  final UserRole role;

  const TimeOffBody({super.key, required this.role});

  @override
  State<TimeOffBody> createState() => _TimeOffBodyState();
}

class _TimeOffBodyState extends State<TimeOffBody> {
  DateTime selectedDate = DateTime.now();
  DateTime selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get isAdmin => widget.role == UserRole.admin;
  bool get isEmployee => widget.role == UserRole.employee;

  // -------- Formatting helpers ----------
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

  String get formattedSelectedMonth =>
      "${_monthName(selectedMonth.month)} ${selectedMonth.year}";

  // ----------------------------------------

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topBar(),
          const SizedBox(height: 10),

          if (isEmployee) _timeOffSummaryCards(),
          if (isEmployee) const SizedBox(height: 10),

          _tableHeader(),

          Expanded(child: _timeOffList()),
        ],
      ),
    );
  }

  // ---------------- TOP BAR (New button + Month/Date Picker) ----------------
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (isEmployee)
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => const TimeOffRequestDialog(),
                );
              },
              child: const Text("NEW"),
            ),

          if (isEmployee) const SizedBox(width: 12),

          // Admin → Date picker
          if (isAdmin) _datePickerButton(),
          if (isEmployee) _monthPickerButton(),
        ],
      ),
    );
  }

  Widget _monthPickerButton() {
    return InkWell(
      onTap: () async {
        final picked = await showMonthPicker(
          context: context,
          initialDate: selectedMonth,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );

        if (picked != null) {
          setState(() => selectedMonth = DateTime(picked.year, picked.month));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: _borderBox(),
        child: Row(
          children: [
            Text(formattedSelectedMonth),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  // ------------------ Date Picker (Admin) -------------------
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
        if (picked != null) setState(() => selectedDate = picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: _borderBox(),
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

  BoxDecoration _borderBox() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(6),
    );
  }

  // ------------------ Paid / Sick Time Off Cards -------------------
  Widget _timeOffSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _timeOffCard("Paid Time Off", "24 Days Available")),
          const SizedBox(width: 16),
          Expanded(child: _timeOffCard("Sick Time Off", "07 Days Available")),
        ],
      ),
    );
  }

  Widget _timeOffCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _borderBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // ------------------ Table Header -------------------
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.grey.withOpacity(0.1),
      child: const Row(
        children: [
          Expanded(child: Text("Name")),
          Expanded(child: Text("Start Date")),
          Expanded(child: Text("End Date")),
          Expanded(child: Text("Type")),
          Expanded(child: Text("Status")),
        ],
      ),
    );
  }

  // ------------------ Table Rows -------------------
  Widget _timeOffList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              const Expanded(child: Text("[Employee Name]")),
              const Expanded(child: Text("28/10/2025")),
              const Expanded(child: Text("28/10/2025")),
              const Expanded(child: Text("Paid Time Off")),
              Expanded(child: _statusDot("Approved")),
            ],
          ),
        );
      },
    );
  }

  Widget _statusDot(String status) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: status == "Approved"
              ? Colors.green
              : status == "Pending"
              ? Colors.orange
              : Colors.red,
        ),
      ),
      child: Text(status, textAlign: TextAlign.center),
    );
  }
}
