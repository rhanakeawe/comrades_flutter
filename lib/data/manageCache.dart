import 'dart:convert';
import 'dart:typed_data';

import 'package:Comrades/data/goalData.dart';
import 'package:Comrades/data/notificationSettingData.dart';

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

  Future<void> saveListToCache(String filename, List<Object> list) async {
    List<Map<String, dynamic>> listJson = [];
    if (filename == 'groups_data.json') {
      list = list as List<GroupData>;
      listJson = list.map((item) => item.toJson()).toList();
    } else if (filename == 'goals_data.json') {
      list = list as List<GoalData>;
      listJson = list.map((item) => item.toJson()).toList();
    } else if (filename == 'notification_setting.json') {
      list = list as List<NotificationSettingData>;
      listJson = list.map((item) => item.toJson()).toList();
    }
    print("length: ${list}");

    final jsonString = jsonEncode(listJson);

    await cacheManager.putFile(
      filename,
      Uint8List.fromList(jsonString.codeUnits),
    );
  }

  Future<List<Object>?> loadListFromCache(String filename) async {
    final fileInfo = await cacheManager.getFileFromCache(filename);
    if (fileInfo != null) {
      final jsonString = String.fromCharCodes(await fileInfo.file.readAsBytes());
      final List<dynamic> jsonData = jsonDecode(jsonString);
      if (filename == 'groups_data.json') {
        return jsonData.map((json) => GroupData.fromJson(json)).toList();
      } else if (filename == 'goals_data.json') {
        return jsonData.map((json) => GoalData.fromJson(json)).toList();
      } else if (filename == 'notification_setting.json') {
        return jsonData.map((json) => NotificationSettingData.fromJson(json)).toList();
      }
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