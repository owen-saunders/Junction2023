import 'package:flutter/material.dart';
import 'package:hexagon/hexagon.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/pages/activity.dart';
import 'package:we_sweat/pages/challenge.dart';
import 'package:we_sweat/pages/feed.dart';
import 'package:we_sweat/pages/profile.dart';
import 'package:we_sweat/pages/map.dart';
import 'package:we_sweat/providers/feed_provider.dart';
import 'package:we_sweat/providers/profile_provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';

enum HexState { FILLED, EMPTY }

class Home extends StatelessWidget {
  var msgServ;

  Home({super.key, required this.msgServ});

  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);

    return BaseWidget<ProfileState>(
        state: Provider.of<ProfileState>(context),
        onStateReady: (state) async {},
        builder: (context, state, child) {
          return Scaffold(
              backgroundColor: theme.colors.backgroundColor,
              body: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: _buildMenu(state, context, theme)),
                ],
              ));
        });
  }

  Widget _buildMenu(
      ProfileState state, BuildContext context, ThemeManager theme) {
    List<HexagonWidgetBuilder> menu = [
      HexagonWidgetBuilder(
          elevation: 2,
          padding: 4.0,
          cornerRadius: 10,
          color: theme.colors.highlight,
          child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => ProfileProvider(
                        child: ActivityScreen(),
                      ),
                      transitionDuration: Duration(milliseconds: 700),
                      transitionsBuilder: (_, a, __, c) =>
                          FadeTransition(opacity: a, child: c),
                    ));
                print('activity started');
              },
              child: Column(
                children: [
                  Spacer(),
                  Text(
                    'Start Activity',
                    style: theme.themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Notify friends',
                    style: theme.themeData.textTheme.titleMedium,
                  ),
                  SizedBox(height: 16),
                  Icon(
                    Icons.radio_button_checked,
                    size: 45,
                  ),
                  Spacer()
                ],
              ))),
      HexagonWidgetBuilder(
          elevation: 2,
          padding: 4.0,
          cornerRadius: 10,
          color: theme.colors.highlight,
          child: InkWell(
            onTap: () {
              print('friend started');
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ProfileProvider(
                      child: const MapScreen(),
                    ),
                    transitionDuration: const Duration(milliseconds: 700),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ));
            },
            child: Column(
              children: [
                Spacer(),
                Text(
                  'Friends',
                  style: theme.themeData.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Friends near you',
                  style: theme.themeData.textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.group,
                  size: 45,
                ),
                Spacer()
              ],
            ),
          )),
      HexagonWidgetBuilder(
          elevation: 2,
          padding: 4.0,
          cornerRadius: 10,
          color: theme.colors.highlight,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeedProvider(
                      child: FeedScreen(),
                    ),
                    transitionDuration: Duration(milliseconds: 700),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ));
            },
            child: Column(
              children: [
                Spacer(),
                Text('Feed',
                    style: theme.themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  'See activities',
                  style: theme.themeData.textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.forum,
                  size: 45,
                ),
                Spacer()
              ],
            ),
          )),
      HexagonWidgetBuilder(
          elevation: 2,
          padding: 4.0,
          cornerRadius: 10,
          color: theme.colors.highlight,
          child: InkWell(
            onTap: () {
              print('team started');
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => ProfileProvider(
                      child: ChallengeScreen(),
                    ),
                    transitionDuration: Duration(milliseconds: 700),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ));
            },
            child: Column(
              children: [
                Spacer(),
                Text('Team',
                    style: theme.themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  'Your challenges',
                  style: theme.themeData.textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.diversity_3,
                  size: 45,
                ),
                Spacer()
              ],
            ),
          )),
      HexagonWidgetBuilder(
          elevation: 2,
          padding: 4.0,
          cornerRadius: 10,
          color: theme.colors.highlight,
          child: InkWell(
            onTap: () {
              print('profile');
              Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FeedProvider(
                      child: ProfileProvider(child: ProfileScreen()),
                    ),
                    transitionDuration: Duration(milliseconds: 700),
                    transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                  ));
            },
            child: Column(
              children: [
                Spacer(),
                Text('Profile',
                    style: theme.themeData.textTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.bold)),
                Text(
                  'Your information',
                  style: theme.themeData.textTheme.titleMedium,
                ),
                SizedBox(height: 16),
                Icon(
                  Icons.person,
                  size: 45,
                ),
                Spacer()
              ],
            ),
          ))
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: HexagonOffsetGrid.oddPointy(
          color: Colors.black54.withOpacity(1),
          padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 32.0),
          columns: 5,
          rows: 1,
          buildTile: (col, row) => menu.elementAt(col)),
    );
  }
}
