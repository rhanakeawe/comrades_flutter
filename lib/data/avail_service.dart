import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Comrades/components/availability_utils.dart';

class AvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, DateTime>>> getUserUnavailability(
      List<String> memberEmails) async {
    if (memberEmails.isEmpty) {
      return []; // No members, no unavailability
    }

    final snapshot = await _firestore
        .collection('userUnavailability')
        .where('userEmail', whereIn: memberEmails)
        .get();

    // Default to full-day availability if no data is found for a user
    if (snapshot.docs.isEmpty) {
      return [
        {
          'startTime': DateTime(0, 0, 0, 0, 0),
          'endTime': DateTime(23, 59),
        }
      ];
    }

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'startTime': (data['startTime'] as Timestamp).toDate(),
        'endTime': (data['endTime'] as Timestamp).toDate(),
      };
    }).toList();
  }


  Future<List<Map<String, dynamic>>> getGroupAvailabilityForDay(
      String userEmail, DateTime selectedDay) async {
    // Fetch group IDs the user belongs to
    final groupUserListSnapshot = await _firestore
        .collection('groupUserList')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    final groupIDs = groupUserListSnapshot.docs
        .map((doc) => doc['ID_group'] as String)
        .toList();

    // Fetch all group members for these groups
    final groupMembersSnapshot = await _firestore
        .collection('groupUserList')
        .where('ID_group', whereIn: groupIDs)
        .get();

    final memberEmails = groupMembersSnapshot.docs
        .map((doc) => doc['userEmail'] as String)
        .toList();

    // Fetch unavailability for all group members
    final userUnavailability = await getUserUnavailability(memberEmails);

    // Define the start and end of the selected day
    DateTime dayStart =
    DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0);
    DateTime dayEnd =
    DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59);

    // Use AvailabilityUtils to calculate availability slots
    return AvailabilityUtils.getGroupAvailability(
        [userUnavailability], dayStart, dayEnd);
  }

  Future<void> addUnavailabilityToFirestore(
      String groupID, DateTime startTime, DateTime endTime) async {
    await _firestore.collection('groupUnavailability').add({
      'ID_group': groupID,
      'startTime': startTime,
      'endTime': endTime,
    });
  }
}
