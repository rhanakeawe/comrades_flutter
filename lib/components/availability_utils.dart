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

  /// Calculates group availability by finding overlapping free time intervals.
  static List<Map<String, DateTime>> getGroupAvailability(
      List<List<Map<String, DateTime>>> groupUnavailabilityLists,
      DateTime dayStart,
      DateTime dayEnd,
      ) {
    // Define initial available intervals (entire day is initially free)
    List<Map<String, DateTime>> availableIntervals = [
      {'startTime': dayStart, 'endTime': dayEnd}
    ];

    for (var userUnavailability in groupUnavailabilityLists) {
      List<Map<String, DateTime>> updatedIntervals = [];

      for (var interval in availableIntervals) {
        DateTime currentStart = interval['startTime']!;
        DateTime currentEnd = interval['endTime']!;

        for (var unavailable in userUnavailability) {
          DateTime unavailableStart = unavailable['startTime']!;
          DateTime unavailableEnd = unavailable['endTime']!;

          if (unavailableEnd.isBefore(currentStart) ||
              unavailableStart.isAfter(currentEnd)) {
            // No overlap, keep the interval
            updatedIntervals.add({'startTime': currentStart, 'endTime': currentEnd});
          } else {
            // Overlap detected, split the current interval
            if (unavailableStart.isAfter(currentStart)) {
              updatedIntervals.add({'startTime': currentStart, 'endTime': unavailableStart});
            }
            if (unavailableEnd.isBefore(currentEnd)) {
              updatedIntervals.add({'startTime': unavailableEnd, 'endTime': currentEnd});
            }
          }
        }
      }

      // Update available intervals after processing current user's unavailability
      availableIntervals = updatedIntervals;
    }

    return availableIntervals;
  }
}
