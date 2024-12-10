import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FriendGroup {
  String groupId;
  String groupName;
  Color groupColor;
  List<String> members;
  List<String> visibleTo;

  FriendGroup({
    String? groupId,
    required this.groupName,
    required this.groupColor,
    required this.members,
    required this.visibleTo,
  }) : groupId = groupId ?? const Uuid().v4(); // Auto-generate groupId if not provided

  // Convert FriendGroup to JSON
  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'groupColor': groupColor.value,
      'members': members,
      'visibleTo': visibleTo,
    };
  }

  // Create FriendGroup from JSON
  factory FriendGroup.fromJson(Map<String, dynamic> json) {
    return FriendGroup(
      groupId: json['groupId'] ?? const Uuid().v4(), // Ensure groupId fallback
      groupName: json['groupName'] ?? 'Unknown Group',
      groupColor: json['groupColor'] is int
          ? Color(json['groupColor'])
          : Colors.black, // Default color if parsing fails
      members: json['members'] != null
          ? List<String>.from(json['members'])
          : [], // Ensure members is a list
      visibleTo: json['visibleTo'] != null
          ? List<String>.from(json['visibleTo'])
          : [], // Ensure visibleTo is a list
    );
  }
}
