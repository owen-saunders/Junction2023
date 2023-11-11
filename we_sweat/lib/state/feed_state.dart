import 'package:flutter/material.dart';
import 'package:we_sweat/models/feedItem.dart';
import 'package:we_sweat/services/feed_service.dart';

class FeedState extends ChangeNotifier {
  FeedService service = FeedService();

  bool gotFeed = false;
  bool gettingFeed = false;
  List<FeedItem> feed = [];

  void getFeed() async {
    gettingFeed = true;
    notifyListeners();

    feed = await service.getFeed();
    notifyListeners();

    print(feed);

    gettingFeed = false;
    gotFeed = true;
    notifyListeners();
  }
}
