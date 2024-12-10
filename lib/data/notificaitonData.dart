class NotificationData {
  final String toggled;

  NotificationData({
    required this.toggled,
  });

  Map<String, dynamic> toJson() => {
    'toggled' : toggled,
  };

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
        toggled: json['toggled']
    );
  }
}