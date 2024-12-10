import 'package:cloud_firestore/cloud_firestore.dart';

class QueryList {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchList(
      String collection,
      String field,
      String value, [
        String? field2,
        String? value2,
      ]) async {
    try {
      Query<Map<String, dynamic>> query = _db.collection(collection).where(field, isEqualTo: value);

      if (field2 != null && value2 != null) {
        query = query.where(field2, isEqualTo: value2);
      }

      return await query.get();
    } catch (e) {
      print("Error completing query on collection '$collection': $e");
      rethrow;
    }
  }
}
