import 'package:flutter/material.dart';

class MonthView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final List<DateTime> availableDates; // New parameter for available dates

  const MonthView({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.availableDates, // Passing available dates
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = DateTime(focusedDay.year, focusedDay.month, index + 1);
        final isSelected = day.day == selectedDay.day &&
            day.month == selectedDay.month &&
            day.year == selectedDay.year;

        final isAvailable = availableDates.contains(day); // Check if the day is available

        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Container(
            decoration: BoxDecoration(
              color: isAvailable ? Colors.green.shade200 : Colors.transparent, // Highlight available dates
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
