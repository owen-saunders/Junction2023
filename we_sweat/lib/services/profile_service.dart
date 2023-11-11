import 'dart:async';
import 'package:we_sweat/models/challenge.dart';

import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:we_sweat/models/user.dart';
import 'package:we_sweat/state/profile_state.dart';

class ProfileService {
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

  Future<Map<String, dynamic>> login(String username, String password) async {
    var url = "http://10.173.45.133:8000/api/login/";
    var map = <String, dynamic>{};
    map['username'] = username;
    map['password'] = password;

    // print(username);
    // print(password);

    try {
      var response = await http
          .post(Uri.parse(url), body: map)
          .timeout(Duration(seconds: 1));

      // print(response.body);
      // print(response.statusCode);
      // print(response.headers);

      if (response.statusCode == 200) {
        var responseDecoded = jsonDecode(response.body)["user"];
        var token = jsonDecode(response.body)["token"];

        UserPreferences().saveUser(
            token,
            responseDecoded["username"],
            responseDecoded["first_name"],
            responseDecoded["last_name"],
            responseDecoded["email"],
            responseDecoded["id"]
            // responseDecoded["profile_picture"]
            );
        return {'status': true, 'message': 'Login successful'};
      } else {
        return {'status': false, 'message': 'Login unsuccessful'};
      }
    } catch (e) {
      // print(e);
      return {
        'status': false,
        'message': 'Oops something went wrong, please try again'
      };
    }
  }

  Future<List<User>> getUsers(List<int> user_ids) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url;

    url = 'http://10.173.45.133:8000/api/v1/users/';

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    Uri uri = Uri.parse(url);

    List<User> users = [];

    try {
      Response response = await client.get(uri, headers: headers);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          users.add(User.fromJson(result));
        }
      }

      users = users.where((user) => user_ids.contains(user.id)).toList();

      // print(users);

      return users;
    } catch (e) {
      return users;
    }
  }

  Future<List<User>> getFriends() async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url;
    List<User> users = [];

    url = 'http://10.173.45.133:8000/api/v1/users/me/';

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    List<int> ids = [];
    try {
      Response response = await client.get(uri, headers: headers);

      // print(response.body);
      // print(response.statusCode);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ids = responseDecoded['friends'].cast<int>();
        // print(ids);
      }

      users = await getUsers(ids);

      return users;
    } catch (e) {
      return users;
    }
  }

  Future<List<User>> getRecommended() async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url;
    List<User> users = [];

    url = 'http://10.173.45.133:8000/api/v1/users/';

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      Response response = await client.get(uri, headers: headers);

      // print(response.body);
      // print(response.statusCode);

      Map<String, dynamic> responseDecoded = jsonDecode(response.body);
      if (response.statusCode == 200) {
        for (var result in responseDecoded['results']) {
          users.add(User.fromJson(result));
        }
      }

      List<User> friends = await getFriends();

      //filter where users are not me and not in friends list
      users = users
          .where((u) => u.id != user.id && friends.contains(u) == false)
          .toList();

      return users;
    } catch (e) {
      return users;
    }
  }

  // Future<Stats> getFriendsStats(int id) async {
  //   Client client = Client();
  //   User user = await UserPreferences().getUser();

  //   String url;

  //   url = 'http://10.173.45.133:8000/api/v1/challenges/stats/?user_id=$id';

  //   Uri uri = Uri.parse(url);

  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': "Token ${user.token}"
  //   };

  //   Stats stats = Stats();

  //   try {
  //     Response response = await client.get(uri, headers: headers);

  //     // print(response.body);
  //     // print(response.statusCode);

  //     Map<String, dynamic> responseDecoded = jsonDecode(response.body)[0];
  //     if (response.statusCode == 200) {
  //       stats = Stats.fromJson(responseDecoded);
  //     }

  //     return stats;
  //   } catch (e) {
  //     return stats;
  //   }
  // }

  // Future<Stats> getMyStats() async {
  //   Client client = Client();
  //   User user = await UserPreferences().getUser();

  //   String url;

  //   Stats stats = Stats();

  //   url = 'http://10.173.45.133:8000/api/v1/challenges/my-stats/';

  //   Uri uri = Uri.parse(url);

  //   var headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': "Token ${user.token}"
  //   };

  //   try {
  //     Response response = await client.get(uri, headers: headers);

  //     print(response.body);
  //     print(response.statusCode);

  //     var responseDecoded = jsonDecode(response.body)[0];
  //     if (response.statusCode == 200) {
  //       stats = Stats.fromJson(responseDecoded);
  //     }

  //     return stats;
  //   } catch (e) {
  //     // print(e);
  //     return stats;
  //   }
  // }

  Future<bool> sendRequest(User user) async {
    Client client = Client();
    User user = await UserPreferences().getUser();

    String url;

    url =
        'http://10.173.45.133:8000/api/v1/users/send_friend_request/?userID=${user.id}';

    Uri uri = Uri.parse(url);

    var headers = {
      'Content-Type': 'application/json',
      'Authorization': "Token ${user.token}"
    };

    try {
      Response response = await client.post(uri, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
