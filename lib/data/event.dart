import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final List<String> participants; // List of user IDs or names
  final bool isPersonal; // To determine the color

  Event({
    required this.title,
    required this.startTime,
    required this.endTime,
    this.participants = const [],
    this.isPersonal = false,
  });

  // Convert Event object to a Map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startTime': Timestamp.fromDate(startTime), // Convert DateTime to Timestamp
      'endTime': Timestamp.fromDate(endTime), // Convert DateTime to Timestamp
      'participants': participants,
      'isPersonal': isPersonal,
    };
  }

  // Convert Firestore document to Event object
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      title: map['title'] ?? '',
      startTime: (map['startTime'] as Timestamp).toDate(), // Convert Timestamp back to DateTime
      endTime: (map['endTime'] as Timestamp).toDate(), // Convert Timestamp back to DateTime
      participants: List<String>.from(map['participants'] ?? []),
      isPersonal: map['isPersonal'] ?? false,
    );
  }
}
