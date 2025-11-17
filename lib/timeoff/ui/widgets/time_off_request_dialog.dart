import 'package:flutter/material.dart';

class TimeOffRequestDialog extends StatefulWidget {
  const TimeOffRequestDialog({super.key});

  @override
  State<TimeOffRequestDialog> createState() => _TimeOffRequestDialogState();
}

class _TimeOffRequestDialogState extends State<TimeOffRequestDialog> {
  // FORM FIELDS
  String? selectedEmployee = "Employee 1";
  String? selectedType = "Paid Time Off";

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  String? attachmentFileName;

  final employees = ["Employee 1", "Employee 2"];
  final timeOffTypes = ["Paid Time Off", "Sick Time Off", "Unpaid Leave"];

  // ------------------- PICKERS --------------------
  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: startDate,
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  // Mock attachment picker
  Future<void> pickAttachment() async {
    // Replace with file picker later
    setState(() => attachmentFileName = "certificate.pdf");
  }

  @override
  Widget build(BuildContext context) {
    final allocation = endDate.difference(startDate).inDays + 1;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header --------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Time off Type Request",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),

              const SizedBox(height: 12),
              _readOnlyField("Employee", selectedEmployee ?? "Unknown"),

              const SizedBox(height: 12),
              _dropdownField(
                "Time off Type",
                selectedType,
                timeOffTypes,
                (v) => setState(() => selectedType = v),
              ),

              const SizedBox(height: 12),
              _dateRangePicker(),

              const SizedBox(height: 12),
              _allocationField(allocation),

              const SizedBox(height: 12),
              _attachmentField(),

              const SizedBox(height: 22),
              _actionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readOnlyField(String label, String value) {
    return Row(
      children: [
        SizedBox(width: 140, child: Text(label)),
        Text(value),
      ],
    );
  }

  // ---------- DROPDOWN FIELD ----------
  Widget _dropdownField(
    String label,
    String? selected,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Row(
      children: [
        SizedBox(width: 140, child: Text(label)),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: _box(),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selected,
                items: options
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- DATE RANGE PICKER ----------
  Widget _dateRangePicker() {
    return Row(
      children: [
        const SizedBox(width: 140, child: Text("Validity Period")),
        InkWell(
          onTap: pickStartDate,
          child: Text(
            "${_monthName(startDate.month)} ${startDate.day}",
            style: const TextStyle(color: Colors.blue),
          ),
        ),
        const SizedBox(width: 12),
        const Text("To"),
        const SizedBox(width: 12),
        InkWell(
          onTap: pickEndDate,
          child: Text(
            "${_monthName(endDate.month)} ${endDate.day}",
            style: const TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }

  // ---------- ALLOCATION ----------
  Widget _allocationField(int allocation) {
    return Row(
      children: [
        const SizedBox(width: 140, child: Text("Allocation")),
        Text(
          allocation.toString().padLeft(2, '0'),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        const Text("Days"),
      ],
    );
  }

  // ---------- ATTACHMENT ----------
  Widget _attachmentField() {
    return Row(
      children: [
        const SizedBox(width: 140, child: Text("Attachment")),
        InkWell(
          onTap: pickAttachment,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.upload, color: Colors.blue),
          ),
        ),
        const SizedBox(width: 10),
        Text(attachmentFileName ?? "(For sick leave certificate)"),
      ],
    );
  }

  // ---------- ACTION BUTTONS ----------
  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
          onPressed: () {},
          child: const Text("Submit"),
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Discard"),
        ),
      ],
    );
  }

  // Helpers
  String _monthName(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[m - 1];
  }

  BoxDecoration _box() {
    return BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(8),
    );
  }
}
