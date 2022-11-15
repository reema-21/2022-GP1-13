// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import '/pages/goals_habits_tab/goal_list_screen.dart';
import '/isar_service.dart';
import 'habit_list_screen.dart';

class Goals_habit extends StatefulWidget {
  final IsarService iser;

  const Goals_habit({super.key, required this.iser});

  @override
  State<Goals_habit> createState() => Goals_habitState();
}

class Goals_habitState extends State<Goals_habit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(children: [
            //firstTap
            GoalListScreen(isr: widget.iser),
            //second
            HabitListScreen(isr: widget.iser)
          ]),
        )
      ],
    );
  }
}
