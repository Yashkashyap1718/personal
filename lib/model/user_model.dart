// ignore_for_file: file_names

class UserModel {
  int? id;
  String? uid;
  String? username;
  String? phoneNumber;
  String? email;
  String? studentId;
  String? collegeName;
  String? cityName;
  String? profilePic;

  UserModel(
      {this.id,
      this.uid,
      this.username,
      this.phoneNumber,
      this.email,
      this.studentId,
      this.collegeName,
      this.cityName,
      this.profilePic});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'] ?? 1,
        uid: json['uid'] ?? "",
        username: json['username'] ?? '',
        phoneNumber: json['phoneNumber'] ?? '',
        email: json['email'] ?? '',
        studentId: json['studentId'] ?? '',
        collegeName: json['collegeName'] ?? '',
        cityName: json['cityName'] ?? '',
        profilePic: json['profilePic'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      'username': username,
      'phoneNumber': phoneNumber,
      'email': email,
      'studentId': studentId,
      'collegeName': collegeName,
      'cityName': cityName,
      'profilePic': profilePic
    };
  }
}
