import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/theme/theme_manager.dart';

// ignore: must_be_immutable
class LikeButton extends StatefulWidget {
  LikeButton({
    Key? key,
    required this.liked,
    required this.onLike,
    required this.onUnlike,
    required this.likes,
    this.showLikeNum = true,
    this.id = -1,
  }) : super(key: key);

  bool liked;
  final Function onLike;
  final Function onUnlike;
  int likes;
  final bool showLikeNum;
  final int id;

  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  int currentLikes = 0;
  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    currentLikes = widget.likes;
    final AnimationController _controller = AnimationController(
        vsync: this,
        value: (widget.liked) ? 1.0 : 0.0,
        lowerBound: 0.3,
        duration: Duration(milliseconds: 2000));

    return Column(
      children: [
        ClipRect(
          child: Container(
            child: Align(
              alignment: Alignment.center,
              widthFactor: 0.6,
              heightFactor: 0.6,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  if (widget.liked) {
                    widget.onUnlike();
                    _controller.value = 0.0;
                    // if (widget.giveawayState != null) {
                    //   widget.giveawayState!.unsaveGiveaway(widget.id);
                    // }
                    setState(() {
                      widget.liked = false;
                      widget.likes -= 1;
                    });
                  } else {
                    widget.onLike();
                    _controller.forward(from: 0.0);
                    // if (widget.giveawayState != null) {
                    //   widget.giveawayState!.saveGiveaway(widget.id);
                    // }
                    setState(() {
                      widget.liked = true;
                      widget.likes += 1;
                    });
                  }
                },
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  child: Icon(
                    Icons.thumb_up,
                    color: widget.liked
                        ? theme.colors.highlight
                        : theme.colors.light,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.showLikeNum,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                border: Border.all(color: Color(0xffc6c6c6), width: 1)),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
              child: Text(
                NumberUtils.numberShort(currentLikes),
                style: theme.themeData.textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NumberUtils {
  static String numberShort(int number) {
    if (number <= 999) {
      return number.toString();
    } else if (number > 999 && number <= 9999) {
      return number.toString()[0] + "." + number.toString()[1] + "k";
    } else if (number > 9999 && number <= 99999) {
      return number.toString()[0] + number.toString()[1] + "k";
    } else {
      return number.toString()[0] +
          number.toString()[1] +
          number.toString()[2] +
          "k";
    }
  }
}
