import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/models/feedItem.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/liked_button.dart';

class ItemFeed extends StatefulWidget {
  final FeedItem item;

  const ItemFeed({Key? key, required this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ItemFeedState();
}

class ItemFeedState extends State<ItemFeed> {
  // bool isMenuOpen = false;
  //bool verified = false;

  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    return Container(
        decoration: BoxDecoration(
            color: theme.colors.dark,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  if (widget.item.media != '')
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Image.network(
                            widget.item.media,
                            fit: BoxFit.cover,
                          )),
                    ), // Picture of product
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 48,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: (widget.item.profilePic != '')
                              ? ClipOval(
                                  child: Image.network(
                                  widget.item.profilePic,
                                  fit: BoxFit.cover,
                                ))
                              : ClipOval(
                                  child: Container(
                                    color: theme.colors.highlight,
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 100,
                                        color: theme.colors.highlight,
                                      ),
                                    ),
                                  ),
                                ),
                        )),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: theme.themeData.textTheme.titleSmall,
                          ),
                          Text(
                            widget.item.name,
                            style: theme.themeData.textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 4,
                            ),
                            LikeButton(
                              liked: widget.item.isSaved,
                              onLike: () => print("liked"),
                              onUnlike: () => print("unliked"),
                              likes: widget.item.likes,
                              id: widget.item.likes,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
