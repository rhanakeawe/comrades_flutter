import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeekView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final List<Map<String, dynamic>> events;

  const WeekView({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final startOfWeek = focusedDay.subtract(Duration(days: focusedDay.weekday - 1));
    final daysInWeek = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysInWeek.map((day) {
              final isSelected = day.day == selectedDay.day &&
                  day.month == selectedDay.month &&
                  day.year == selectedDay.year;

              final eventsForDay = _getEventsForDay(day);

              return GestureDetector(
                onTap: () {
                  onDaySelected(day);
                },
                child: Column(
                  children: [
                    CircleAvatar(
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
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          _buildEventList(eventsForDay: _getEventsForDay(selectedDay), context: context),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    return events
        .where((event) {
      final eventStart = event['startTime']; // If eventStart is already a DateTime, no need to call toDate()
      final eventEnd = event['endTime']; // Same for eventEnd

      return eventStart.year == day.year &&
          eventStart.month == day.month &&
          eventStart.day == day.day;
    })
        .toList();
  }

  Widget _buildEventList({required List<Map<String, dynamic>> eventsForDay, required BuildContext context}) {
    if (eventsForDay.isEmpty) {
      return const Center(
        child: Text(
          'No events for this day.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Column(
      children: eventsForDay.map((event) {
        final startTime = DateFormat.jm().format(event['startTime']);
        final endTime = DateFormat.jm().format(event['endTime']);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            width: MediaQuery.of(context).size.width - 16, // Makes the event box full width
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Me',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event['eventTitle'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$startTime - $endTime',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
