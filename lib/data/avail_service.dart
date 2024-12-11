import 'package:cloud_firestore/cloud_firestore.dart';

class AvailabilityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch user's non-negotiables from Firebase
  Future<List<Map<String, dynamic>>> getUserNonNegotiables(String userEmail) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userEmail)
          .collection('nonNegotiables')
          .get();

      // Debug print to check fetched documents
      print("Fetched non-negotiables snapshot: ${snapshot.docs}");

      return snapshot.docs.map((doc) {
        print("Non-negotiable document data: ${doc.data()}");
        return doc.data();
      }).toList();
    } catch (e) {
      print("Error fetching non-negotiables: $e");
      return [];
    }
  }

  // Fetch group availability for a specific day
  Future<List<Map<String, dynamic>>> getGroupAvailabilityForDay(String userEmail, DateTime selectedDay) async {
    try {
      final formattedDate = "${selectedDay.year}-${selectedDay.month}-${selectedDay.day}";

      final snapshot = await _firestore
          .collection('groups')
          .where('members', arrayContains: userEmail)
          .get();

      // Debug print to check fetched documents
      print("Fetched group availability snapshot: ${snapshot.docs}");

      return snapshot.docs.map((doc) {
        final data = doc.data();
        print("Group availability data: $data");

        // Handle null values and convert timestamps to DateTime
        if (data['startTime'] != null && data['startTime'] is Timestamp) {
          data['startTime'] = (data['startTime'] as Timestamp).toDate();
        } else {
          data['startTime'] = DateTime.now(); // Default to current time if null
        }

        if (data['endTime'] != null && data['endTime'] is Timestamp) {
          data['endTime'] = (data['endTime'] as Timestamp).toDate();
        } else {
          data['endTime'] = DateTime.now(); // Default to current time if null
        }

        return {
          ...data,
          'date': formattedDate,
        };
      }).toList();
    } catch (e) {
      print("Error fetching group availability: $e");
      return [];
    }
  }




  // Filter availability by non-negotiables
  List<Map<String, dynamic>> filterByNonNegotiables(
      List<Map<String, dynamic>> availability,
      List<Map<String, dynamic>> nonNegotiables) {
    try {
      print("Filtering availability based on non-negotiables...");

      // Filter logic: Exclude time slots that conflict with non-negotiables
      return availability.where((avail) {
        return nonNegotiables.every((nonNeg) {
          // Convert Timestamp to DateTime for both availability and non-negotiables
          final availStart = (avail['startTime'] as Timestamp).toDate();
          final availEnd = (avail['endTime'] as Timestamp).toDate();
          final nonNegStart = (nonNeg['startTime'] as Timestamp).toDate();
          final nonNegEnd = (nonNeg['endTime'] as Timestamp).toDate();

          // Debug logs
          print("Availability: $availStart to $availEnd");
          print("Non-Negotiable: $nonNegStart to $nonNegEnd");

          // Check for overlap between availability and non-negotiables
          return availEnd.isBefore(nonNegStart) || availStart.isAfter(nonNegEnd);
        });
      }).toList();
    } catch (e) {
      print("Error filtering availability: $e");
      return availability; // Return unfiltered availability on error
    }
  }

  // Add a new member to a group
  Future<void> addUserToGroup(String groupId, String userEmail) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'members': FieldValue.arrayUnion([userEmail]),  // Add user email to the group
      });
      print("User added to group successfully.");
    } catch (e) {
      print("Error adding user to group: $e");
    }
  }
}
