import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Timestamp

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
        final groupName = availability['groupName'] ?? 'Unknown Group';

        // Handle Timestamp conversion here
        final startTime = availability['startTime'] is Timestamp
            ? (availability['startTime'] as Timestamp).toDate()
            : availability['startTime'];
        final endTime = availability['endTime'] is Timestamp
            ? (availability['endTime'] as Timestamp).toDate()
            : availability['endTime'];

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
                  groupName,
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

  String _formatDateTime(DateTime dateTime, BuildContext context) {
    if (dateTime == null) return "Invalid Time";
    final timeOfDay = TimeOfDay.fromDateTime(dateTime);
    return timeOfDay.format(context);
  }
}
