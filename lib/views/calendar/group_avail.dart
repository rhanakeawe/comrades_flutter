import 'package:flutter/material.dart';

class GroupAvailabilityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> groupAvailability;
  final List<Map<String, dynamic>> userEvents;

  const GroupAvailabilityWidget({
    required this.groupAvailability,
    required this.userEvents,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Separate group availability and user events, and sort each by time
    List<Map<String, dynamic>> sortedGroupAvailability = [];
    sortedGroupAvailability.addAll(groupAvailability);

    // Sort the group availability by start time (ensure startTime and endTime are DateTime)
    sortedGroupAvailability.sort((a, b) {
      DateTime aStart = a['startTime'] as DateTime; // Make sure it's a DateTime object
      DateTime bStart = b['startTime'] as DateTime; // Make sure it's a DateTime object
      return aStart.compareTo(bStart);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedGroupAvailability.length,
      itemBuilder: (context, index) {
        final availability = sortedGroupAvailability[index];
        final isGroup = availability.containsKey('groupName'); // Check if it's a group availability

        final title = isGroup ? availability['groupName'] : availability['eventTitle'];
        final startTime = availability['startTime'] as DateTime; // Ensure startTime is DateTime
        final endTime = availability['endTime'] as DateTime; // Ensure endTime is DateTime

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.0),
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.black,
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Group Name or Event Title
                Text(
                  title ?? 'Unknown Title',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Middle Row: Availability or Event Status
                Text(
                  isGroup ? "Available" : "Event",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isGroup ? Colors.green : Colors.blue,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Bottom Row: Availability/Event Time
                Text(
                  "${_formatDateTime(startTime, context)} - ${_formatDateTime(endTime, context)}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return timeOfDay.format(context);
  }
}
