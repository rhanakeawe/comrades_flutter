class GoalData {
  final String goalName;
  final String goalText;
  final String userEmail;
  final String goalDayStart;
  final String goalDayEnd;
  final String ID_group;

  GoalData({
    required this.goalName,
    required this.goalText,
    required this.userEmail,
    required this.goalDayStart,
    required this.goalDayEnd,
    required this.ID_group
  });

  Map<String, dynamic> toJson() => {
    'goalName' : goalName,
    'goalText' : goalText,
    'userEmail' : userEmail,
    'goalDayStart' : goalDayStart,
    'goalDayEnd' : goalDayEnd,
    'ID_group' : ID_group,
  };

  factory GoalData.fromJson(Map<String, dynamic> json) {
    return GoalData(
      goalName: json['goalName'],
      goalText: json['goalText'],
      userEmail: json['userEmail'],
      goalDayStart: json['goalDayStart'],
      goalDayEnd: json['goalDayEnd'],
      ID_group: json['ID_group'],
    );
  }
}