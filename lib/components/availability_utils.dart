import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityUtils {
  /// Calculates group availability by finding overlapping free time intervals.
  /// Filters intervals to only those 2 hours or longer.
  static List<Map<String, dynamic>> getGroupAvailability(
      List<List<Map<String, dynamic>>> groupUnavailabilityLists, // Updated type
      DateTime dayStart,
      DateTime dayEnd,
      List<String> groupIDs,
      List<Map<String, dynamic>> events, // Updated type
      ) {
    // Initial interval is the full day for each group
    List<Map<String, dynamic>> availableIntervals = groupIDs.map((groupID) {
      return {
        'startTime': dayStart,
        'endTime': dayEnd,
        'group_ID': groupID,
      };
    }).toList();

    for (var userUnavailability in groupUnavailabilityLists) {
      List<Map<String, dynamic>> updatedIntervals = [];

      for (var interval in availableIntervals) {
        DateTime currentStart = interval['startTime'] as DateTime;
        DateTime currentEnd = interval['endTime'] as DateTime;

        for (var unavailable in [...userUnavailability, ...events]) {
          // Convert Timestamp to DateTime if needed
          DateTime unavailableStart = unavailable['startTime'] is Timestamp
              ? (unavailable['startTime'] as Timestamp).toDate()
              : unavailable['startTime'] as DateTime;
          DateTime unavailableEnd = unavailable['endTime'] is Timestamp
              ? (unavailable['endTime'] as Timestamp).toDate()
              : unavailable['endTime'] as DateTime;

          if (unavailableEnd.isBefore(currentStart) || unavailableStart.isAfter(currentEnd)) {
            // No overlap, keep the interval
            updatedIntervals.add({
              'startTime': currentStart,
              'endTime': currentEnd,
              'group_ID': interval['group_ID'],
            });
          } else {
            // Overlap: Split the interval
            if (unavailableStart.isAfter(currentStart)) {
              updatedIntervals.add({
                'startTime': currentStart,
                'endTime': unavailableStart,
                'group_ID': interval['group_ID'],
              });
            }
            if (unavailableEnd.isBefore(currentEnd)) {
              updatedIntervals.add({
                'startTime': unavailableEnd,
                'endTime': currentEnd,
                'group_ID': interval['group_ID'],
              });
            }
          }
        }
      }

      // Update intervals to the filtered ones
      availableIntervals = updatedIntervals;
    }

    // Filter intervals that are less than 2 hours
    availableIntervals = availableIntervals.where((interval) {
      final startTime = interval['startTime'] as DateTime;
      final endTime = interval['endTime'] as DateTime;
      return endTime.difference(startTime).inMinutes >= 120;
    }).toList();

    return availableIntervals;
  }
}
