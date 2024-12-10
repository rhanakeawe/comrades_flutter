import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NonNegotiablesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? _currentUserEmail = FirebaseAuth.instance.currentUser?.email;

  Future<_NonNegotiablesData> fetchNonNegotiables() async {
    List<Map<String, dynamic>> nonNegotiablesList = [];
    List<String> documentIds = [];

    if (_currentUserEmail != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("non-negotiables")
          .where("userEmail", isEqualTo: _currentUserEmail)
          .get();

      for (var doc in snapshot.docs) {
        nonNegotiablesList.add({
          'type': doc.data()["type"],
          'days': doc.data()["days"],
          'startTime': doc.data()["startTime"],
          'endTime': doc.data()["endTime"],
        });
        documentIds.add(doc.id);
      }
    }

    return _NonNegotiablesData(
      nonNegotiablesList: nonNegotiablesList,
      documentIds: documentIds,
    );
  }

  Future<void> addNonNegotiable(Map<String, dynamic> nonNegotiable) async {
    if (_currentUserEmail != null) {
      nonNegotiable['userEmail'] = _currentUserEmail;
      await _firestore.collection("non-negotiables").add(nonNegotiable);
    }
  }

  Future<void> updateNonNegotiable(String documentId, Map<String, dynamic> updatedData) async {
    await _firestore.collection("non-negotiables").doc(documentId).update(updatedData);
  }

  Future<void> deleteNonNegotiable(String documentId) async {
    await _firestore.collection("non-negotiables").doc(documentId).delete();
  }

  // New method to fetch non-negotiables for all group members
  Future<Map<String, List<Map<String, dynamic>>>> fetchGroupNonNegotiables(List<String> groupEmails) async {
    Map<String, List<Map<String, dynamic>>> groupNonNegotiables = {};
    for (String email in groupEmails) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore
          .collection("non-negotiables")
          .where("userEmail", isEqualTo: email)
          .get();

      groupNonNegotiables[email] = snapshot.docs.map((doc) => doc.data()).toList();
    }
    return groupNonNegotiables;
  }
}

class _NonNegotiablesData {
  final List<Map<String, dynamic>> nonNegotiablesList;
  final List<String> documentIds;

  _NonNegotiablesData({
    required this.nonNegotiablesList,
    required this.documentIds,
  });
}
