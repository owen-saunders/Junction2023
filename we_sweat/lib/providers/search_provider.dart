import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/state/search_state.dart';

class SearchProvider extends StatelessWidget {
  final Widget child;

  SearchProvider({Key? key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SearchState>(
      create: (_) => SearchState(),
      child: child,
    );
  }
}
