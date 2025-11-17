import 'package:flutter/material.dart';

class CheckInAndOutDialog extends StatelessWidget {
  final bool isCheckedIn;
  final DateTime? checkInTime;

  const CheckInAndOutDialog({
    super.key,
    required this.isCheckedIn,
    this.checkInTime,
  });

  String formatTime(DateTime t) {
    return "${t.hour % 12}:${t.minute.toString().padLeft(2, '0')} ${t.hour >= 12 ? 'PM' : 'AM'}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // STATUS DOT
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.circle,
                  color: isCheckedIn ? Colors.green : Colors.red,
                  size: 20,
                ),
              ),

              const SizedBox(height: 10),

              // SINCE TIME (if checked in)
              if (isCheckedIn)
                Text(
                  "Since ${formatTime(checkInTime!)}",
                  style: theme.textTheme.displaySmall,
                ),

              if (isCheckedIn) const SizedBox(height: 12),

              // MAIN BUTTON BOX
              InkWell(
                onTap: () => Navigator.pop(context, !isCheckedIn),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.withOpacity(0.4)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isCheckedIn ? "Check Out" : "Check IN",
                        style: theme.textTheme.titleMedium,
                      ),
                      const Icon(Icons.arrow_right_alt_rounded, size: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
