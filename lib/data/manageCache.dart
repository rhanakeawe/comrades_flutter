import 'dart:convert';
import 'dart:typed_data';

import 'appCacheManager.dart';
import 'groupData.dart';
final cacheManager = AppCacheManager();

class ManageCache {
  Future<String?> loadDataFromCache(String filename) async {
    final fileInfo = await cacheManager.getFileFromCache(filename);

    if (fileInfo != null) {
      return String.fromCharCodes(await fileInfo.file.readAsBytes());
    }
    return null;
  }

  Future<void> saveGroupsToCache(String filename, List<GroupData> groups) async {
    final List<Map<String, dynamic>> groupsJson =
    groups.map((group) => group.toJson()).toList();
    print("length: ${groups.length}");

    final jsonString = jsonEncode(groupsJson);

    await cacheManager.putFile(
      filename,
      Uint8List.fromList(jsonString.codeUnits),
    );
  }

  Future<List<GroupData>?> loadGroupsFromCache(String filename) async {
    final fileInfo = await cacheManager.getFileFromCache(filename);
    if (fileInfo != null) {
      final jsonString = String.fromCharCodes(await fileInfo.file.readAsBytes());
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((json) => GroupData.fromJson(json)).toList();
    }
    return null;
  }

  Future<void> clearAllCache() async {
    await cacheManager.emptyCache();
    print('All cache cleared.');
  }

  Future<void> deleteCache(String filename) async {
    try {
      await cacheManager.removeFile(filename);
      print("deleting $filename");
    } catch (e) {print(e);}
  }
}