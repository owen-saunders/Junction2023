import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_sweat/state/profile_state.dart';
import 'package:we_sweat/theme/theme_manager.dart';
import 'package:we_sweat/widgets/base_widget.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeManager theme =
        Provider.of<ThemeManager>(context, listen: false);
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      body: BaseWidget<ProfileState>(
          state: Provider.of<ProfileState>(context),
          onStateReady: (state) {
            //fetches last 24hrs
            state.fetchData();
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
                                "Workouts",
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
                            itemCount: state.healthDataList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  color: theme.colors.dark,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
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
                                              "${state.healthDataList[index].value.toJson()["workoutActivityType"]} \nDuration: ${state.healthDataList[index].dateTo.difference(state.healthDataList[index].dateFrom)}",
                                              style: theme.themeData.textTheme
                                                  .bodyMedium,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            },
                          ),
                        )
                      ],
                    )));
          }),
    );
  }
}
