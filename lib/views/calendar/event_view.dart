import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventView extends StatelessWidget {
  final String title;
  final DateTime startTime;
  final DateTime endTime;

  const EventView({
    super.key,
    required this.title,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    final startTimeFormatted = DateFormat('hh:mm a').format(startTime);
    final endTimeFormatted = DateFormat('hh:mm a').format(endTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Me',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$startTimeFormatted - $endTimeFormatted',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
