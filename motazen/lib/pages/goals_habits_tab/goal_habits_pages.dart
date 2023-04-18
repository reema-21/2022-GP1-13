import 'package:flutter/material.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/goals_habits_tab/goal_list_screen.dart';
import 'habit_list_screen.dart';

class GoalsHabit extends StatefulWidget {
  final IsarService iser;

  const GoalsHabit({super.key, required this.iser});

  @override
  State<GoalsHabit> createState() => GoalsHabitState();
}

class GoalsHabitState extends State<GoalsHabit> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            children: [
              //firstTap
              GoalListScreen(isr: widget.iser),
              //second
              HabitListScreen(isr: widget.iser)
            ],
          ),
        )
      ],
    );
  }
}
