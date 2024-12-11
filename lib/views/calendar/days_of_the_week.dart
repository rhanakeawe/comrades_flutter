import 'package:flutter/material.dart';

class DaysOfWeek extends StatelessWidget {
  final bool highlightCurrentDay;

  const DaysOfWeek({
    super.key,
    this.highlightCurrentDay = false,
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

          // Map `DateTime.weekday` (1=Mon, 7=Sun) to `days` array (0=Sun, 6=Sat)
          final isToday = highlightCurrentDay && ((today.weekday % 7) == index);

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
