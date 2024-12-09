import 'package:flutter/material.dart';

class AvailabilityUtils {
  /// Checks if a given time interval is available.
  static bool isAvailable(
      DateTime startTime,
      DateTime endTime,
      List<Map<String, DateTime>> unavailabilityList,
      ) {
    for (var interval in unavailabilityList) {
      final unavailableStart = interval['startTime']!;
      final unavailableEnd = interval['endTime']!;
      if ((startTime.isBefore(unavailableEnd) && endTime.isAfter(unavailableStart))) {
        // Overlap detected
        return false;
      }
    }
    return true;
  }

  /// Placeholder for calculating group availability
  /// Takes multiple users' unavailability lists and computes shared availability.
  static List<Map<String, DateTime>> getGroupAvailability(
      List<List<Map<String, DateTime>>> groupUnavailabilityLists,
      ) {
    // Placeholder logic for calculating group availability
    // This can involve finding overlapping free times across multiple members
    return [];
  }
}
