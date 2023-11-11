import 'dart:core';

class FeedItem {
  final String media;
  final int likes;
  final String title;
  final int owner;
  final String name;
  final String profilePic;
  final bool isSaved;
  final bool isVerified;
  final String word;
  final int challenge;

  FeedItem(
      {this.media = '',
      this.likes = 0,
      this.title = '',
      this.name = '',
      this.profilePic = '',
      this.owner = -1,
      this.isSaved = false,
      this.isVerified = false,
      this.word = '',
      this.challenge = -1});

  factory FeedItem.fromJson(Map<String, dynamic> responseData) {
    return FeedItem(
        media: responseData['photo'],
        likes: responseData['likes'],
        title: responseData['title'],
        owner: responseData["owner"],
        name: responseData["name"],
        isVerified: responseData['verified'],
        word: responseData['word'],
        challenge: responseData['challenge']);
  }
}
