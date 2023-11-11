import 'dart:async';
import 'package:we_sweat/models/feedItem.dart';
import 'package:we_sweat/models/user.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'dart:convert';
import 'package:http/http.dart';

class FeedService {
  Future<List<FeedItem>> getFeed() async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/feeds/?my_challenges=true';

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<FeedItem> feed = [];
    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      // print(response.body);
      // print(response.statusCode);

      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          feed.add(FeedItem.fromJson(result));
        }
      }
      return feed;
    } catch (e) {
      return feed;
    }
  }
}
