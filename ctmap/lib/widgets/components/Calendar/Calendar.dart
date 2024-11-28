import 'package:flutter/material.dart';

class CustomCalendar extends StatelessWidget {
  final Function(DateTime) onDateSelected;
  final DateTime initialDate;

  const CustomCalendar({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.calendar_today, color: Colors.red),
      onPressed: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2000),
          lastDate: DateTime(2025),
          helpText: 'Chọn ngày',
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
    );
  }
}
