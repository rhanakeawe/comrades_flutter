import 'package:flutter/material.dart';

class GroupAvailabilityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> groupAvailability;

  const GroupAvailabilityWidget({required this.groupAvailability, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupAvailability.length,
      itemBuilder: (context, index) {
        final availability = groupAvailability[index];
        final groupName = availability['groupName'];
        final startTime = availability['startTime'];
        final endTime = availability['endTime'];

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
                // Top Row: Group Name
                Text(
                  groupName ?? 'Unknown Group',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Middle Row: Availability Status
                const Text(
                  "Available",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8.0),
                // Bottom Row: Availability Time
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

  // Helper function to format DateTime
  String _formatDateTime(DateTime dateTime, BuildContext context) {
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return timeOfDay.format(context);
  }
}
