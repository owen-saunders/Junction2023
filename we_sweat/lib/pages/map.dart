import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:we_sweat/pages/profile.dart';
import 'package:we_sweat/pages/workouts.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late bool auth;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late double lat;
  late double long;
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(60.164031958716435, 24.911919067200344),
    zoom: 14.4746,
  );

  static const CameraPosition _kJunction = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(60.16210713258729, 24.905906969956497),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  List<Marker> allMarkers = [];

  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      body: BaseWidget<ProfileState>(
          state: Provider.of<ProfileState>(context),
          onStateReady: (state) async {
            state.getUserDetails();
            auth = await state.isAuthorised();
            print("Auth done");

            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? fluttermoji = prefs.getString('fluttermoji');
            print("fluttermoji: $fluttermoji");
            BitmapDescriptor bitmapDescriptor =
                await getBitmapDescriptorFromSvgString(fluttermoji!);
            Marker marker = Marker(
                markerId: MarkerId('someId'),
                draggable: false,
                onTap: () {
                  print('Marker Tapped');
                  // TODO: ShowDialog doesn't work
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: theme.colors.backgroundColor,
                          title: Text(
                            "Frankie",
                            style: theme.themeData.textTheme.bodyLarge!
                                .copyWith(color: theme.colors.mid),
                          ),
                          content: Text(
                            "Frankie is here! Currently doing: Walking",
                            style: theme.themeData.textTheme.bodyMedium,
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Close",
                                    style: theme.themeData.textTheme.bodySmall!
                                        .copyWith(
                                            color: theme.colors.highlight))),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileProvider(
                                              child: const ProfileScreen())));
                                },
                                child: Text("View Profile",
                                    style: theme.themeData.textTheme.bodySmall!
                                        .copyWith(
                                            color: theme.colors.highlight)))
                          ],
                        );
                      });
                },
                icon: bitmapDescriptor,
                position: const LatLng(60.161031958716435, 24.911919067200344));
            setState(() {
              allMarkers.add(marker);
            });
          },
          builder: (context, state, child) {
            return Stack(children: <Widget>[
              GoogleMap(
                mapType: MapType.hybrid,
                initialCameraPosition: _kInitialPosition,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                buildingsEnabled: false,
                markers: Set.from(allMarkers),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 18),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Nearby Friends",
                                style: theme.themeData.textTheme.titleLarge,
                              ),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.cancel,
                                    color: theme.colors.light,
                                    size: 30,
                                  ))
                            ])
                      ]))
            ]);
          }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheHackathon,
        label: const Text('To the Junction Hackathon!'),
        icon: const Icon(Icons.directions_bus),
      ),
    );
  }

  Future<void> _goToTheHackathon() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kJunction));
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromSvgString(
    String assetName, [
    Size size = const Size(48, 48),
  ]) async {
    print("ENTERED BITMAP DESCRIPTOR");
    // Read SVG file as String
    // String svgString =
    //     await DefaultAssetBundle.of(context).loadString(assetName);
    // Create DrawableRoot from SVG String

    PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(assetName), null);
    print("pic info: $pictureInfo");
    // toPicture() and toImage() don't seem to be pixel ratio aware, so we calculate the actual sizes here
    MediaQueryData queryData = MediaQuery.of(context);
    double devicePixelRatio = queryData.devicePixelRatio;
    int width = (32 * devicePixelRatio)
        .round(); // where 32 is your SVG's original width
    int height = (32 * devicePixelRatio).round(); // same thing
    final scaleFactor = min(
      width / pictureInfo.size.width,
      height / pictureInfo.size.height,
    );

    final recorder = ui.PictureRecorder();

    print("After here?");
    ui.Canvas(recorder)
      ..scale(scaleFactor)
      ..drawPicture(pictureInfo.picture);
    print("Or here?");

    final rasterPicture = recorder.endRecording();

    print("Orrrrr...?");

    final image = rasterPicture.toImageSync(width, height);
    print("Idk");
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;
    print("Anymore");
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permantly denied, we cannot request permissions.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.medium,
      distanceFilter: 200,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      lat = position.latitude;
      long = position.longitude;
    });
  }

  // TODO: Get friends' last locations
  // void _getFriendsLocation() {}
}
