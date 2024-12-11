import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'group_avail.dart'; // Import the shared widget

class MonthView extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final Function(DateTime) onDaySelected;
  final List<Map<String, dynamic>> availableDates;
  final List<Map<String, dynamic>> groupAvailability;
  final List<Map<String, dynamic>> userEvents;

  const MonthView({
    Key? key,
    required this.focusedDay,
    required this.selectedDay,
    required this.onDaySelected,
    required this.availableDates,
    required this.groupAvailability,
    required this.userEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;

    return Column(
      children: [
        GridView.builder(
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

            return GestureDetector(
              onTap: () {
                onDaySelected(day);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue.shade200 : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.blue.shade700
                          : Colors.grey.shade400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        // Display Group Availability Widget for the selected day
        GroupAvailabilityWidget(
          groupAvailability: groupAvailability,
          userEvents: userEvents,
        ),
      ],
    );
  }
}
