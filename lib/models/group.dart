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
  }) : groupId = groupId ?? const Uuid().v4();  // Auto-generate groupId if not provided

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
      groupId: json['groupId'],
      groupName: json['groupName'],
      groupColor: Color(json['groupColor']),
      members: List<String>.from(json['members']),
      visibleTo: List<String>.from(json['visibleTo']),
    );
  }
}
