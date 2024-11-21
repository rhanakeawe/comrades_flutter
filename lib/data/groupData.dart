class GroupData {
  final String groupName;
  final String group_ID;
  final String groupCreator;
  final String groupDesc;
  final String groupPhotoURL;
  final String groupColor;

  GroupData({
    required this.groupName,
    required this.group_ID,
    required this.groupCreator,
    required this.groupDesc,
    required this.groupPhotoURL,
    required this.groupColor
  });

  Map<String, dynamic> toJson() => {
      'groupName' : groupName,
      'group_ID' : group_ID,
      'groupCreator' : groupCreator,
      'groupDesc' : groupDesc,
      'groupPhotoURL' : groupPhotoURL,
      'groupColor' : groupColor,
    };

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      groupName: json['groupName'],
      group_ID: json['group_ID'],
      groupCreator: json['groupCreator'],
      groupDesc: json['groupDesc'],
      groupPhotoURL: json['groupPhotoURL'],
      groupColor: json['groupColor'],
    );
  }
}