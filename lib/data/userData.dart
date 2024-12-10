class UserData {
  final String userName;
  final String email;
  final String profilePic;

  UserData({
    required this.userName,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userName: json['userName'] is String ? json['userName'] : '',
      email: json['email'] is String ? json['email'] : '',
      profilePic: json['profilePic'] is String ? json['profilePic'] : '',
    );
  }
}
