import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Comrades/data/event.dart';

class WeekView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final List<Event> events; // Accept events to render them

  const WeekView({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.events,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startOfWeek = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    final daysInWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: daysInWeek.map((day) {
          // Check if the day is selected
          final isSelected = day.day == selectedDay.day &&
              day.month == selectedDay.month &&
              day.year == selectedDay.year;

          // Day Widget
          return GestureDetector(
            onTap: () {
              onDaySelected(day);
            },
            child: CircleAvatar(
              backgroundColor: isSelected ? Colors.blue : Colors.grey.shade800,
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
