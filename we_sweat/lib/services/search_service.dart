import 'dart:convert';
import 'package:we_sweat/models/challenge.dart';
import 'package:we_sweat/models/feedItem.dart';
import 'package:we_sweat/models/user.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:we_sweat/state/profile_state.dart';

class SearchService {
  Future<List<Challenge>> getArticles(String query) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/challenges/?search=$query';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<Challenge> challenges = [];

    Uri uri = Uri.parse(url);

    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          challenges.add(Challenge.fromJson(result));
        }
      }
      return challenges;
    } catch (e) {
      // print(e);
      return challenges;
    }
  }

  Future<List<Challenge>> getMyChallenges() async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/challenges/?my_challenges=true';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<Challenge> challenges = [];

    Uri uri = Uri.parse(url);

    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          challenges.add(Challenge.fromJson(result));
        }
      }
      return challenges;
    } catch (e) {
      // print(e);
      return challenges;
    }
  }

  Future<List<Challenge>> getExplore() async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/challenges/?popular=true';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<Challenge> challenges = [];

    Uri uri = Uri.parse(url);

    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);

      // print(response.statusCode);
      // print(response.body);

      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          challenges.add(Challenge.fromJson(result));
        }
      }
      return challenges;
    } catch (e) {
      // print(e);
      return challenges;
    }
  }

  Future<List<FeedItem>> getChallengeFeed(int id) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/feeds/?challenge=$id';

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<FeedItem> feed = [];
    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);
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

  Future<bool> joinChallenge(int id) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    url = 'http://10.173.45.133:8000/api/v1/participate/';

    var map = <String, dynamic>{};
    map['user'] = user.id;
    map['challenge'] = id;

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      Response response =
          await client.post(uri, headers: headers, body: jsonEncode(map));

      // Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> uploadPost(
      int challenge, String title, String image) async {
    User user = await UserPreferences().getUser();

    var url = "http://10.173.45.133:8000/api/v1/feeds/";

    var map = <String, dynamic>{};
    map['challenge'] = challenge;
    map['title'] = title;
    // map['owner'] = user.id;
    // map['name'] = user.fname;
    map['likes'] = 0;
    // map['photo'] = image;

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      // var response = await http.post(Uri.parse(url),
      //     headers: headers, body: jsonEncode(map));

      var request = await http.MultipartRequest('POST', Uri.parse(url));

      request.fields['challenge'] = "$challenge";
      request.fields['title'] = title;
      request.fields['likes'] = "0";
      request.fields["owner"] = "${user.id}";
      request.files.add(await http.MultipartFile.fromPath('photo', image));
      request.headers.addAll(headers);
      var res = await request.send();
      var response = await http.Response.fromStream(res);

      final responsedData = json.decode(response.body);

      if (response.statusCode == 201) {
        return {'status': true, 'message': 'successful'};
      } else {
        return {'status': false, 'message': 'unsuccessful'};
      }
    } catch (e) {
      // print(e);
      return {
        'status': false,
        'message': 'Oops something went wrong, please try again'
      };
    }
  }

  Future<bool> isVerified(String image, String word, int id) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    image = image.substring(32);
    // print(image);

    // print(word);

    url =
        "http://10.173.45.133:8000/api/v1/verify-image/predict_caption/?word=$word&image_path=$image";
    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      Response response = await client.post(uri, headers: headers);

      // print(response.body);
      // print(response.statusCode);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 200) {
        bool update = await verify(id);

        return update;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> verify(int id) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url = '';

    var map = <String, dynamic>{};

    map['verified'] = true;

    url = "http://10.173.45.133:8000/api/v1/feeds/$id/";
    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      Response response =
          await client.patch(uri, headers: headers, body: jsonEncode(map));

      print(response.body);
      print(response.statusCode);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
