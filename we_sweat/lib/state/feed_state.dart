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

    feed = [
      FeedItem(
          media:
              'https://media.istockphoto.com/id/925354566/vector/young-running-woman-isolated-vector-silhouette-run-side-view.jpg?s=612x612&w=0&k=20&c=O2pwvF5jAf8sBq1FeOPcrPJTY4zyeC26lyPfF5N_v-4=',
          title: 'test 1'),
      FeedItem(title: 'test 2')
    ];

    //feed = await service.getFeed();

    gettingFeed = false;
    gotFeed = true;
    notifyListeners();
  }
}
