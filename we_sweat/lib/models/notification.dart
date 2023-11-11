import 'dart:core';

class Notifications {
  final int user;
  final String title;
  final bool read;
  final String content;
  final String date;
  final bool isFriendRequest;

  Notifications(
      {this.user = -1,
      this.title = '',
      this.read = false,
      this.content = '',
      this.date = '',
      this.isFriendRequest = false});

  factory Notifications.fromJson(Map<String, dynamic> responseData) {
    return Notifications(
        // token: responseData['token'],
        user: responseData['user'],
        title: responseData['title'],
        read: responseData['read'],
        content: responseData['content'],
        date: responseData['datetime'],
        isFriendRequest: responseData['is_friend_request']);
  }

  @override
  String toString() {
    return 'Notification';
  }
}
