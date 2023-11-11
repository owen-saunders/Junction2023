import 'package:flutter/material.dart';
import 'package:we_sweat/models/challenge.dart';
import 'package:we_sweat/models/feedItem.dart';
import 'package:we_sweat/services/search_service.dart';

class SearchState extends ChangeNotifier {
  SearchService service = SearchService();

  bool gotSearchedChallenges = false;
  bool gettingSearchedChallenges = false;
  List<Challenge> challenges = [];

  void getSearchedArticles(String query) async {
    gettingSearchedChallenges = true;
    notifyListeners();

    challenges = await service.getArticles(query);

    gettingSearchedChallenges = false;
    gotSearchedChallenges = true;
    notifyListeners();
  }

  bool gotSearchedMyChallenges = false;
  bool gettingSearchedMyChallenges = false;
  List<Challenge> myChallenges = [];

  void getMyChallenges() async {
    gettingSearchedMyChallenges = true;
    notifyListeners();

    myChallenges = await service.getMyChallenges();

    gettingSearchedMyChallenges = false;
    gotSearchedMyChallenges = true;
    notifyListeners();
  }

  bool gettingExplore = false;
  bool gotExplore = false;
  List<Challenge> exploreChallenges = [];

  void getExploreChallenges() async {
    gettingExplore = true;
    notifyListeners();

    exploreChallenges = await service.getExplore();
    // print(exploreChallenges);

    gettingExplore = false;
    gotExplore = true;
    notifyListeners();
  }

  bool gotFeed = false;
  bool gettingFeed = false;
  List<FeedItem> feed = [];

  void getFeed(int id) async {
    gettingFeed = true;
    notifyListeners();

    feed = await service.getChallengeFeed(id);

    gettingFeed = false;
    gotFeed = true;
    notifyListeners();
  }

  Future<bool> joinChallenge(int id) async {
    return service.joinChallenge(id);
  }

  // bool isVerified = false;

  // void verifyImage(String image, String word, int id) async {
  //   isVerified = await service.isVerified(image, word, id);
  //   notifyListeners();
  // }

  // XFile? _xImage;

  // Future selectOrTakePhoto(ImageSource imageSource) async {
  //   final ImagePicker picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(source: imageSource);

  //   if (pickedFile != null) {
  //     _xImage = pickedFile;
  //     getNewImage();
  //   } else {
  //     print('No photo was selected or taken');
  //   }
  // }

  // ImageProvider<Object> image = const NetworkImage(
  //     'https://www.publicdomainpictures.net/pictures/30000/nahled/plain-white-background.jpg');

  // String path = '';

  // void getNewImage() async {
  //   path = _xImage!.path;
  //   // final image_upload = File(path).path.toString();
  //   // image_upload = Image.file(File(path));
  //   final bytes = await File(path).readAsBytes();
  //   UserPreferences().updateProfile(bytes);
  //   image = Image.memory(bytes).image;
  //   notifyListeners();
  // }

  // bool loading = false;

  // Future<Map<String, dynamic>> uploadPost(int challenge, String title) async {
  //   loading = false;
  //   setWaiting();
  //   // print(challenge);
  //   // print(title);
  //   Map<String, dynamic> value =
  //       await service.uploadPost(challenge, title, path);
  //   // await Future.delayed(const Duration(seconds: 1));
  //   setWaiting();
  //   return value;
  // }

  // void setWaiting() {
  //   if (loading == false) {
  //     loading = true;
  //     notifyListeners();
  //   } else {
  //     loading = false;
  //     notifyListeners();
  //   }
  // }
}
