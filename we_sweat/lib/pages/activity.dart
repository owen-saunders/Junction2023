import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  String selectedActivity = '';
  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      body: BaseWidget<ProfileState>(
          state: Provider.of<ProfileState>(context),
          onStateReady: (state) {
            state.getFriends();
            state.getUserDetails();
          },
          builder: (context, state, child) {
            return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Activities",
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
                          child: ListView.builder(
                            itemCount: state.sportActivities.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  color: theme.colors.dark,
                                  child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: InkWell(
                                        onTap: () {
                                          selectedActivity = state
                                              .sportActivities[index]
                                              .toLowerCase();
                                          _sendMessage(state, selectedActivity,
                                              state.user.fname);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.fitness_center,
                                              color: theme.colors.highlight,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  state.sportActivities[index],
                                                  style: theme.themeData
                                                      .textTheme.bodyMedium,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )));
                            },
                          ),
                        )
                      ],
                    )));
          }),
    );
  }

  Future _sendMessage(ProfileState state, String activity, String name) async {
    List<String> fcms = state.friends
        .map((e) => e.fcm.toString())
        .toList()
        .where((element) => element != "")
        .toList();
    // print(fcms);
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": fcms,
      "messageTitle": "Join $name",
      "messageBody": "$name wants to do $activity with you"
    });
    print(res);
  }
}
