import 'package:flutter/material.dart';

class DaysOfWeek extends StatelessWidget {
  final bool highlightCurrentDay;

  const DaysOfWeek({
    super.key,
    this.highlightCurrentDay = false, // Optional parameter to highlight the current day
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final today = DateTime.now();

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.asMap().entries.map((entry) {
          final index = entry.key;
          final day = entry.value;

          // Check if this day is the current day
          final isToday = highlightCurrentDay && today.weekday % 7 == index + 1;

          return Text(
            day,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isToday ? Colors.blue : Colors.grey, // Highlight current day
            ),
          );
        }).toList(),
      ),
    );
  }
}
