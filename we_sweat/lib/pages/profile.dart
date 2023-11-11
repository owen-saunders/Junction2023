import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/pages/workouts.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late bool auth;
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
          },
          builder: (context, state, child) {
            return SafeArea(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Profile",
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
                                ]),
                            const SizedBox(height: 24),
                            Center(
                                child: Stack(
                              children: [
                                FluttermojiCircleAvatar(
                                  backgroundColor: theme.colors.light,
                                  radius: MediaQuery.of(context).size.width / 3,
                                ),
                                // Container(
                                //   width: MediaQuery.of(context).size.width / 3,
                                //   height: MediaQuery.of(context).size.width / 3,
                                //   decoration: BoxDecoration(
                                //       shape: BoxShape.circle,
                                //       image: DecorationImage(
                                //           fit: BoxFit.cover, image: state.image)),
                                // ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                9,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                9,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: const Icon(Icons.edit),
                                          color: theme.colors.highlight,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AvatarPage()));
                                          },
                                        ))),
                              ],
                            )),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 24),
                                              labelText: "Display Name",
                                              labelStyle: theme.themeData
                                                  .textTheme.bodyMedium,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintText:
                                                  "${state.user.fname} ${state.user.lname}",
                                              hintStyle: theme.themeData
                                                  .textTheme.bodyLarge)),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 24),
                                              labelText: "Username",
                                              labelStyle: theme.themeData
                                                  .textTheme.bodyMedium,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintText: state.user.username,
                                              hintStyle: theme.themeData
                                                  .textTheme.bodyLarge)),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      TextField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 24),
                                              labelText: "Email",
                                              labelStyle: theme.themeData
                                                  .textTheme.bodyMedium,
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.always,
                                              hintText: state.user.email,
                                              hintStyle: theme.themeData
                                                  .textTheme.bodyLarge)),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Allow access to Health",
                                            style: theme
                                                .themeData.textTheme.bodyMedium,
                                          ),
                                          Spacer(),
                                          Switch(
                                            value: auth,
                                            onChanged: (bool value) async {
                                              if (value) {
                                                state.authorize();
                                                auth = true;
                                              } else {
                                                state.revokeAccess();
                                                auth = false;
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 24,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileProvider(
                                                          child:
                                                              WorkoutScreen())));
                                        },
                                        child: Text(
                                          "View workouts",
                                          style: theme
                                              .themeData.textTheme.bodyMedium,
                                        ),
                                      )
                                    ]))
                          ],
                        ))));
          }),
    );
  }
}

class AvatarPage extends StatelessWidget {
  const AvatarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: FluttermojiCircleAvatar(
                    radius: MediaQuery.of(context).size.width / 3,
                    backgroundColor: theme.colors.light),
              ),
              SizedBox(
                width: min(600, _width * 0.85),
                child: Row(
                  children: [
                    Spacer(),
                    FluttermojiSaveWidget(
                      child: Icon(
                        Icons.save,
                        color: theme.colors.highlight,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: FluttermojiCustomizer(
                  scaffoldWidth: min(600, _width * 0.85),
                  scaffoldHeight: min(1000, _height * 0.4),
                  autosave: true,
                  theme: FluttermojiThemeData(
                    primaryBgColor: theme.colors.dark,
                    secondaryBgColor: theme.colors.dark,
                    iconColor: theme.colors.highlight,
                    selectedIconColor: theme.colors.mid,
                    selectedTileDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    unselectedTileDecoration: null,
                    boxDecoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    labelTextStyle: theme.themeData.textTheme.titleMedium!
                        .copyWith(color: theme.colors.light),
                    scrollPhysics: const ClampingScrollPhysics(),
                    tileMargin: const EdgeInsets.all(2.0),
                    tilePadding: const EdgeInsets.all(2.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
