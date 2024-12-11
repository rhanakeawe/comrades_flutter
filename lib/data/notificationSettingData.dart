class NotificationSettingData {
  final String toggled;

  NotificationSettingData({
    required this.toggled,
  });

  Map<String, dynamic> toJson() => {
    'toggled' : toggled,
  };

  factory NotificationSettingData.fromJson(Map<String, dynamic> json) {
    return NotificationSettingData(
        toggled: json['toggled']
    );
  }
}