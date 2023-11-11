import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/state/feed_state.dart';

class FeedProvider extends StatelessWidget {
  final Widget child;

  FeedProvider({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FeedState>(
      create: (_) => FeedState(),
      child: child,
    );
  }
}
