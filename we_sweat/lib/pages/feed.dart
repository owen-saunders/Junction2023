import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/providers/search_provider.dart';
import 'package:we_sweat/state/feed_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';
import 'package:we_sweat/widgets/feed_item_widget.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);

    return Scaffold(
        backgroundColor: theme.colors.backgroundColor,
        body: BaseWidget<FeedState>(
            state: Provider.of<FeedState>(context),
            onStateReady: (state) => {state.getFeed()},
            builder: (context, state, child) {
              return SafeArea(
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
                                    "Feed",
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
                            Expanded(
                                child: ListView.separated(
                              itemCount: state.feed.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SearchProvider(
                                    child: ItemFeed(item: state.feed[index]));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return SizedBox(height: 10);
                              },
                            ))
                          ])));
            }));
  }
}
