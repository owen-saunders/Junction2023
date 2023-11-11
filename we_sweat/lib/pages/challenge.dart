import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/widgets/base_widget.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BaseWidget<ProfileState>(
          state: Provider.of<ProfileState>(context),
          onStateReady: (state) {
            state.getMyChallenges();
          },
          builder: (context, state, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Challenges",
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.myChallenges.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.workspace_premium,
                              size: 30,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(state.myChallenges[index].title),
                                Text(
                                  state.myChallenges[index].startDate,
                                )
                              ],
                            )
                          ],
                        ),
                      ));
                    },
                  ),
                )
              ],
            );
          }),
    );
  }
}
