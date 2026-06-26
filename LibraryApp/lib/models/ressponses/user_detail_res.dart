

// lib/data/models/user_model.dart

class UserDetailRes {
  String? userId;
  String? fullName;
  String? email;
  String? major;
  String? phoneNumber;
  int? totalBorrowCount;

  UserDetailRes({
    this.userId,
    this.fullName,
    this.email,
    this.major,
    this.phoneNumber,
    this.totalBorrowCount,
  });

  factory UserDetailRes.fromJson(Map<String, dynamic> json) => UserDetailRes(
    userId: json['userId'],
    fullName: json['fullName'],
    email: json['email'],
    major: json['major'],
    phoneNumber: json['phoneNumber'],
    totalBorrowCount: json['totalBorrowCount'],
  );

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'fullName': fullName,
    'email': email,
    'major': major,
    'phoneNumber': phoneNumber,
    'totalBorrowCount': totalBorrowCount,
  };
}