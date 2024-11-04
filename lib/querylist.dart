import 'package:cloud_firestore/cloud_firestore.dart';

class QueryList {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchList(
      String collection, String field, dynamic value) async {
    try {
      QuerySnapshot<Map<String, dynamic>> list = await _db
          .collection(collection)
          .where(field, isEqualTo: value)
          .get();
      return list;
    } catch (e) {
      print("Error completing query: $e");
      rethrow;
    }
  }
}
