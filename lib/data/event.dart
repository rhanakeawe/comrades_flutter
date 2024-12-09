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
}