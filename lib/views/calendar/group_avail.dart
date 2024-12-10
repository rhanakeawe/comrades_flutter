import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupAvailabilityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> groupAvailability;

  const GroupAvailabilityWidget({Key? key, required this.groupAvailability}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (groupAvailability.isEmpty) {
      return const Center(
        child: Text(
          "No overlapping availability found for the selected day.",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupAvailability.length,
      itemBuilder: (context, index) {
        final availability = groupAvailability[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${availability['groupName']} - Available: ${DateFormat.jm().format(availability['startTime'])} - ${DateFormat.jm().format(availability['endTime'])}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
