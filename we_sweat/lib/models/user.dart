import 'dart:core';

class User {
  final int id;
  final String token;
  final String username;
  final String fname;
  final String lname;
  final String email;
  final String profilePicture;
  final String fcm;

  User(
      {this.id = -1,
      this.token = '',
      this.username = '',
      this.fname = '',
      this.lname = '',
      this.email = '',
      this.profilePicture = '',
      this.fcm = ''});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        // token: responseData['token'],
        id: responseData['id'] ?? -1,
        username: responseData['username'] ?? "",
        fname: responseData['first_name'] ?? "",
        lname: responseData['last_name'] ?? "",
        email: responseData['email'] ?? "",
        fcm: responseData['fcm_token'] ?? "");
  }

  @override
  String toString() {
    return 'User token: $token, username: $username, name: $fname fcm: $fcm';
  }

  @override
  bool operator ==(Object other) {
    return (other is User && other.id == id);
  }
}
