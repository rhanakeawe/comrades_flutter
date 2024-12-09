import 'package:flutter/material.dart';

class WeekView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;

  const WeekView({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startOfWeek = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    final daysInWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: daysInWeek.map((day) {
        final isSelected = day.day == selectedDay.day &&
            day.month == selectedDay.month &&
            day.year == selectedDay.year;

        return GestureDetector(
          onTap: () => onDaySelected(day),
          child: Column(
            children: [
              Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.blue.shade700 : Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        );
      }).toList(),
    );
  }
}
