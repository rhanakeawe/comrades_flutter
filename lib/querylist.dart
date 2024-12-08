import 'package:cloud_firestore/cloud_firestore.dart';

class QueryList {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchList(
      String collection, String field, String value,
      [String? field2, String? value2]) async {
    if (value2 == null) {
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
    } else {
      try {
        QuerySnapshot<Map<String, dynamic>> list = await _db
            .collection(collection)
            .where(field, isEqualTo: value)
            .where(field2 as Object, isEqualTo: value2)
            .get();
        return list;
      } catch (e) {
        print("Error completing query: $e");
        rethrow;
      }
    }
  }
}
