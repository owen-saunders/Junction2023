import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health/health.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:we_sweat/models/challenge.dart';
import 'package:we_sweat/models/user.dart';
import 'package:we_sweat/services/profile_service.dart';

enum AppState {
  DATA_NOT_FETCHED,
  FETCHING_DATA,
  DATA_READY,
  NO_DATA,
  AUTHORIZED,
  AUTH_NOT_GRANTED,
  DATA_ADDED,
  DATA_DELETED,
  DATA_NOT_ADDED,
  DATA_NOT_DELETED,
  STEPS_READY,
}

class UserPreferences {
  final storage = const FlutterSecureStorage();

  Future<bool> saveUser(
    String token,
    String username,
    String fname,
    String lname,
    String email,
    int id,
    // Uint8List profilePic
  ) async {
    try {
      await storage.write(key: "token", value: token);

      //save user to Hive
      var userBox = await Hive.openBox('user');
      userBox.putAll({
        "username": username,
        "fname": fname,
        "lname": lname,
        "email": email,
        "id": id
        // "profilePic": profilePic
      });

      print("saved user");

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<User> getUser() async {
    String token;
    String username;
    String fname;
    String lname;
    String email;
    int id;
    // String profilePic;

    try {
      token = await storage.read(key: "token") ?? '';

      //get user details from Hive
      var userBox = await Hive.openBox('user');
      username = userBox.get("username") ?? '';
      fname = userBox.get("fname") ?? '';
      lname = userBox.get("lname") ?? '';
      email = userBox.get("email") ?? '';
      id = userBox.get('id');
      // profilePic = userBox.get("profilePic") ?? '';
    } catch (e) {
      print(e);
      return User(
          token: '', username: '', fname: '', lname: '', email: '', id: -1
          // profilePicture: ''
          );
    }

    User user = User(
        token: token,
        username: username,
        fname: fname,
        lname: lname,
        email: email,
        id: id
        // profilePicture: profilePic
        );

    return user;
  }

  Future<Uint8List> getProfile() async {
    var userBox = await Hive.openBox('user');
    Uint8List image = userBox.get("profilePic");
    return image;
  }

  void updateProfile(Uint8List image) async {
    var userBox = await Hive.openBox('user');
    userBox.put('profilePic', image);
  }

  void removeUser() async {
    await storage.deleteAll();
  }
}

class ProfileState extends ChangeNotifier {
  bool gotFriends = false;
  bool gettingFriends = false;
  List<User> friends = [];

  void getFriends() async {
    gettingFriends = true;
    notifyListeners();

    friends = await service.getFriends();

    gettingFriends = false;
    gotFriends = true;
    notifyListeners();
  }

  bool gotRecommended = false;
  bool gettingRecommended = false;
  List<User> recommended = [];

  void getRecommended() async {
    gettingRecommended = true;
    notifyListeners();

    recommended = await service.getRecommended();

    gettingRecommended = false;
    gotRecommended = true;
    notifyListeners();
  }

  bool friendRequestSent = false;

  void sendRequest(User user) async {
    friendRequestSent = await service.sendRequest(user);
    notifyListeners();
  }

  // bool gotStats = false;
  // bool gettingStats = false;

  // Stats friend_stats = Stats();

  // void getFriendsStats(int id) async {
  //   gettingStats = true;
  //   notifyListeners();

  //   friend_stats = await service.getFriendsStats(id);

  //   gettingStats = false;
  //   gotStats = true;
  //   notifyListeners();
  // }

  // bool gotMyStats = false;
  // bool gettingMyStats = false;

  // Stats myStats = Stats();

  // void getMyStats() async {
  //   gettingMyStats = true;
  //   notifyListeners();

  //   friend_stats = await service.getMyStats();

  //   gettingMyStats = false;
  //   gotMyStats = true;
  //   notifyListeners();
  // }

  User user = User();

  ProfileService service = ProfileService();

  bool loading = false;

  Future<Map<String, dynamic>> login(String username, String password) async {
    loading = false;
    setWaiting();
    // print(username);
    // print(password);
    Map<String, dynamic> value = await service.login(username, password);
    // await Future.delayed(const Duration(seconds: 1));
    setWaiting();
    return value;
  }

  void setWaiting() {
    if (loading == false) {
      loading = true;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
  }

  void getUserDetails() async {
    user = await UserPreferences().getUser();
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

  Future<bool> isUserLoggedIn() async {
    User user = await UserPreferences().getUser();
    print(user);
    return user.token != '';
  }

  ImageProvider<Object> image = const NetworkImage(
      'https://www.publicdomainpictures.net/pictures/30000/nahled/plain-white-background.jpg');

  // void getNewImage() async {
  //   final path = _xImage!.path;
  //   final bytes = await File(path).readAsBytes();
  //   UserPreferences().updateProfile(bytes);
  //   image = Image.memory(bytes).image;
  //   notifyListeners();
  // }

  // void getUserProfile() async {
  //   Uint8List imageb = await UserPreferences().getProfile();
  //   image = Image.memory(imageb).image;
  // }

  List<HealthDataPoint> healthDataList = [];
  AppState _state = AppState.DATA_NOT_FETCHED;
  int _nofSteps = 0;

  // Define the types to get.
  // NOTE: These are only the ones supported on Androids new API Health Connect.
  // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
  // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
  // static final types = dataTypesAndroid;
  // Or selected types
  static final types = [
    HealthDataType.WEIGHT,
    HealthDataType.STEPS,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.WORKOUT,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    // Uncomment these lines on iOS - only available on iOS
    // HealthDataType.AUDIOGRAM
  ];

  // with coresponsing permissions
  // READ only
  // final permissions = types.map((e) => HealthDataAccess.READ).toList();
  // Or READ and WRITE
  final permissions = types.map((e) => HealthDataAccess.READ_WRITE).toList();

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);

  Future authorize() async {
    // If we are trying to read Step Count, Workout, Sleep or other data that requires
    // the ACTIVITY_RECOGNITION permission, we need to request the permission first.
    // This requires a special request authorization call.
    //
    // The location permission is requested for Workouts using the Distance information.
    await Permission.activityRecognition.request();
    await Permission.location.request();

    // Check if we have permission
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);

    // hasPermissions = false because the hasPermission cannot disclose if WRITE access exists.
    // Hence, we have to request with WRITE as well.
    hasPermissions = false;

    bool authorized = false;
    if (!hasPermissions) {
      // requesting access to the data types before reading them
      try {
        authorized =
            await health.requestAuthorization(types, permissions: permissions);
      } catch (error) {
        print("Exception in authorize: $error");
      }
    }

    _state = (authorized) ? AppState.AUTHORIZED : AppState.AUTH_NOT_GRANTED;
  }

  Future isAuthorised() async {
    bool? hasPermissions =
        await health.hasPermissions(types, permissions: permissions);
    if (hasPermissions == null) {
      // requesting access to the data types before reading them
      return false;
    } else {
      return hasPermissions;
    }
  }

  /// Fetch data points from the health plugin and show them in the app.
  Future fetchData() async {
    _state = AppState.FETCHING_DATA;

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 30));

    // Clear old data points
    healthDataList.clear();

    try {
      // fetch health data
      List<HealthDataPoint> healthData =
          await health.getHealthDataFromTypes(yesterday, now, types);
      // save all the new data points (only the first 100)
      healthDataList.addAll(
          (healthData.length < 100) ? healthData : healthData.sublist(0, 100));
    } catch (error) {
      print("Exception in getHealthDataFromTypes: $error");
    }

    // filter out duplicates
    healthDataList = HealthFactory.removeDuplicates(healthDataList);
    notifyListeners();

    healthDataList = healthDataList
        .where((element) => element.type == HealthDataType.WORKOUT)
        .toList();
    // print the results
    healthDataList.forEach((x) => print(x));

    // update the UI to display the results

    _state = healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
  }

  /// Add some random health data.
  Future addData() async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(minutes: 20));

    // Add data for supported types
    // NOTE: These are only the ones supported on Androids new API Health Connect.
    // Both Android's Google Fit and iOS' HealthKit have more types that we support in the enum list [HealthDataType]
    // Add more - like AUDIOGRAM, HEADACHE_SEVERE etc. to try them.
    bool success = true;
    success &= await health.writeHealthData(
        1.925, HealthDataType.HEIGHT, earlier, now);
    success &=
        await health.writeHealthData(90, HealthDataType.WEIGHT, earlier, now);
    success &= await health.writeHealthData(
        90, HealthDataType.HEART_RATE, earlier, now);
    success &=
        await health.writeHealthData(90, HealthDataType.STEPS, earlier, now);
    success &= await health.writeHealthData(
        200, HealthDataType.ACTIVE_ENERGY_BURNED, earlier, now);
    success &= await health.writeHealthData(
        70, HealthDataType.HEART_RATE, earlier, now);
    success &= await health.writeHealthData(
        37, HealthDataType.BODY_TEMPERATURE, earlier, now);
    success &= await health.writeBloodOxygen(98, earlier, now, flowRate: 1.0);
    success &= await health.writeHealthData(
        105, HealthDataType.BLOOD_GLUCOSE, earlier, now);
    success &=
        await health.writeHealthData(1.8, HealthDataType.WATER, earlier, now);
    success &= await health.writeWorkoutData(
        HealthWorkoutActivityType.AMERICAN_FOOTBALL,
        now.subtract(Duration(minutes: 15)),
        now,
        totalDistance: 2430,
        totalEnergyBurned: 400);
    success &= await health.writeBloodPressure(90, 80, earlier, now);
    success &= await health.writeHealthData(
        0.0, HealthDataType.SLEEP_REM, earlier, now);
    success &= await health.writeHealthData(
        0.0, HealthDataType.SLEEP_ASLEEP, earlier, now);
    success &= await health.writeHealthData(
        0.0, HealthDataType.SLEEP_AWAKE, earlier, now);
    success &= await health.writeHealthData(
        0.0, HealthDataType.SLEEP_DEEP, earlier, now);

    _state = success ? AppState.DATA_ADDED : AppState.DATA_NOT_ADDED;
  }

  /// Delete some random health data.
  Future deleteData() async {
    final now = DateTime.now();
    final earlier = now.subtract(Duration(hours: 24));

    bool success = true;
    for (HealthDataType type in types) {
      success &= await health.delete(type, earlier, now);
    }

    _state = success ? AppState.DATA_DELETED : AppState.DATA_NOT_DELETED;
  }

  /// Fetch steps from the health plugin and show them in the app.
  Future fetchStepData() async {
    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    bool requested = await health.requestAuthorization([HealthDataType.STEPS]);

    if (requested) {
      try {
        steps = await health.getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Caught exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');

      _nofSteps = (steps == null) ? 0 : steps;
      _state = (steps == null) ? AppState.NO_DATA : AppState.STEPS_READY;
    } else {
      print("Authorization not granted - error in authorization");
      _state = AppState.DATA_NOT_FETCHED;
    }
  }

  Future revokeAccess() async {
    try {
      await health.revokePermissions();
    } catch (error) {
      print("Caught exception in revokeAccess: $error");
    }
  }

  Widget _contentFetchingData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(
              strokeWidth: 10,
            )),
        Text('Fetching data...')
      ],
    );
  }

  Widget _contentDataReady() {
    return ListView.builder(
        itemCount: healthDataList.length,
        itemBuilder: (_, index) {
          HealthDataPoint p = healthDataList[index];
          if (p.value is AudiogramHealthValue) {
            return ListTile(
              title: Text("${p.typeString}: ${p.value}"),
              trailing: Text('${p.unitString}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          if (p.value is WorkoutHealthValue) {
            return ListTile(
              title: Text(
                  "${p.typeString}: ${(p.value as WorkoutHealthValue).totalEnergyBurned} ${(p.value as WorkoutHealthValue).totalEnergyBurnedUnit?.name}"),
              trailing: Text(
                  '${(p.value as WorkoutHealthValue).workoutActivityType.name}'),
              subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
            );
          }
          return ListTile(
            title: Text("${p.typeString}: ${p.value}"),
            trailing: Text('${p.unitString}'),
            subtitle: Text('${p.dateFrom} - ${p.dateTo}'),
          );
        });
  }

  Widget _contentNoData() {
    return Text('No Data to show');
  }

  Widget _contentNotFetched() {
    return Column(
      children: [
        Text('Press the download button to fetch data.'),
        Text('Press the plus button to insert some random data.'),
        Text('Press the walking button to get total step count.'),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget _authorized() {
    return Text('Authorization granted!');
  }

  Widget _authorizationNotGranted() {
    return Text('Authorization not given. '
        'For Android please check your OAUTH2 client ID is correct in Google Developer Console. '
        'For iOS check your permissions in Apple Health.');
  }

  Widget _dataAdded() {
    return Text('Data points inserted successfully!');
  }

  Widget _dataDeleted() {
    return Text('Data points deleted successfully!');
  }

  Widget _stepsFetched() {
    return Text('Total number of steps: $_nofSteps');
  }

  Widget _dataNotAdded() {
    return Text('Failed to add data');
  }

  Widget _dataNotDeleted() {
    return Text('Failed to delete data');
  }

  Widget _content() {
    if (_state == AppState.DATA_READY)
      return _contentDataReady();
    else if (_state == AppState.NO_DATA)
      return _contentNoData();
    else if (_state == AppState.FETCHING_DATA)
      return _contentFetchingData();
    else if (_state == AppState.AUTHORIZED)
      return _authorized();
    else if (_state == AppState.AUTH_NOT_GRANTED)
      return _authorizationNotGranted();
    else if (_state == AppState.DATA_ADDED)
      return _dataAdded();
    else if (_state == AppState.DATA_DELETED)
      return _dataDeleted();
    else if (_state == AppState.STEPS_READY)
      return _stepsFetched();
    else if (_state == AppState.DATA_NOT_ADDED)
      return _dataNotAdded();
    else if (_state == AppState.DATA_NOT_DELETED)
      return _dataNotDeleted();
    else
      return _contentNotFetched();
  }
}
