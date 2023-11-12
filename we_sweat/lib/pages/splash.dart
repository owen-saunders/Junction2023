import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:we_sweat/pages/home.dart';
import 'package:we_sweat/pages/login.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/state/profile_state.dart';

import '../widgets/base_widget.dart';

class SplashScreen extends StatelessWidget {
  var msgServ;

  SplashScreen({Key? key, required this.msgServ}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BaseWidget<ProfileState>(
            state: Provider.of<ProfileState>(context),
            onStateReady: (state) async {
              await state.isUserLoggedIn().then((v) async {
                if (!v) {
                  //not logged in
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileProvider(
                                  child: LoginScreen(
                                msgServ: msgServ,
                              ))));
                } else {
                  //logged in

                  //generate random number of tiles to place each with a random activity level:
                  Random random = Random();
                  int randomNumber = random.nextInt(4) + 1;
                  List<String> tiles = [];
                  for (int i = 0; i <= randomNumber; i++) {
                    int t = random.nextInt(3) + 1;
                    tiles.add(t.toString());
                  }

                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileProvider(
                              child: Home(msgServ: msgServ, tiles: tiles))));
                }
              });
            },
            builder: (context, state, child) {
              return Center(child: Container());
            }));
  }
}
