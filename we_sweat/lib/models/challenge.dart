import 'dart:core';

class Challenge {
  final int id;
  final String title;
  final String shortDesc;
  final int owner;
  final int participants;
  final String longDesc;
  final String reward;

  Challenge({
    this.id = -1,
    this.title = '',
    this.shortDesc = '',
    this.longDesc = '',
    this.reward = '',
    this.owner = -1,
    this.participants = -1,
  });

  factory Challenge.fromJson(Map<String, dynamic> responseData) {
    return Challenge(
      id: responseData['id'] ?? -1,
      title: responseData['title'] ?? "",
      shortDesc: responseData['short_description'] ?? "",
      longDesc: responseData['long_description'] ?? "",
      reward: responseData['reward'] ?? "",
      owner: responseData['owner'] ?? -1,
      participants: responseData['participants'] ?? -1,
    );
  }

  @override
  String toString() {
    return 'Challenge: $title';
  }
}
