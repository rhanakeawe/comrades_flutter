import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Comrades/components/availability_utils.dart';

class AvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch unavailability for a list of group members
  Future<List<Map<String, DateTime>>> getUserUnavailability(
      List<String> memberEmails) async {
    if (memberEmails.isEmpty) {
      return [
        {
          'startTime': DateTime(0, 0, 0, 0, 0),
          'endTime': DateTime(23, 59),
        }
      ];
    }

    final snapshot = await _firestore
        .collection('userUnavailability')
        .where('userEmail', whereIn: memberEmails)
        .get();

    return snapshot.docs.isNotEmpty
        ? snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'startTime': (data['startTime'] as Timestamp).toDate(),
        'endTime': (data['endTime'] as Timestamp).toDate(),
      };
    }).toList()
        : [
      {
        'startTime': DateTime(0, 0, 0, 0, 0),
        'endTime': DateTime(23, 59),
      }
    ];
  }

  /// Fetch group availability for a specific day
  Future<List<Map<String, dynamic>>> getGroupAvailabilityForDay(
      String userEmail, DateTime selectedDay) async {
    // Step 1: Fetch groups the user belongs to
    final groupUserListSnapshot = await _firestore
        .collection('groupUserList')
        .where('userEmail', isEqualTo: userEmail)
        .get();

    final groupIDs = groupUserListSnapshot.docs
        .map((doc) => doc['ID_group'] as String)
        .toList();

    if (groupIDs.isEmpty) {
      return [];
    }

    // Step 2: Fetch all members for these groups
    final groupMembersSnapshot = await _firestore
        .collection('groupUserList')
        .where('ID_group', whereIn: groupIDs)
        .get();

    final memberEmails = groupMembersSnapshot.docs
        .map((doc) => doc['userEmail'] as String)
        .toList();

    // Step 3: Fetch unavailability for all members
    final userUnavailability = await getUserUnavailability(memberEmails);

    // Step 4: Define the start and end of the selected day
    DateTime dayStart =
    DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 0, 0);
    DateTime dayEnd =
    DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 23, 59);

    // Step 5: Fetch group names for mapping
    final groupSnapshots = await _firestore
        .collection('groups')
        .where('group_ID', whereIn: groupIDs)
        .get();

    final groupNameMap = {
      for (var doc in groupSnapshots.docs)
        doc['group_ID']: doc['groupName'],
    };


    // Step 6: Calculate overlapping availability using AvailabilityUtils
    final calculatedAvailability = AvailabilityUtils.getGroupAvailability(
        [userUnavailability], dayStart, dayEnd);

    // Map ID_group to groupName for display
    return calculatedAvailability.map((slot) {
      final groupID = slot['ID_group'];
      return {
        'ID_group': groupID,
        'groupName': groupNameMap[groupID] ?? 'Unknown Group',
        'startTime': slot['startTime'],
        'endTime': slot['endTime'],
      };
    }).toList();
  }

  /// Add unavailability for a group
  Future<void> addUnavailabilityToFirestore(
      String groupID, DateTime startTime, DateTime endTime) async {
    await _firestore.collection('groupUnavailability').add({
      'ID_group': groupID,
      'startTime': startTime,
      'endTime': endTime,
    });
  }
}
