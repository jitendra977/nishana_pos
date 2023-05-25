class UserModel {
  String userId;
  String userName;
  String userEmail;
  String userPhone;

  UserModel({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userEmail: map['userEmail'] ?? '',
      userPhone: map['userPhone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPhone': userPhone,
    };
  }
}
