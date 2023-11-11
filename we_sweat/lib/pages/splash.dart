import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:we_sweat/pages/home.dart';
import 'package:we_sweat/pages/login.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/state/profile_state.dart';

import '../widgets/base_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

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
                          builder: (context) =>
                              ProfileProvider(child: LoginScreen())));
                } else {
                  //logged in
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (context) => Home()));
                }
              });
            },
            builder: (context, state, child) {
              return Center(child: Container());
            }));
  }
}
