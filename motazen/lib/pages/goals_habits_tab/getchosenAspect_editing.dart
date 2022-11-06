// ignore_for_file: file_names, camel_case_types

import '../../entities/task.dart';
import '/pages/goals_habits_tab/goal_details.dart';
import '/isar_service.dart';

import 'package:flutter/material.dart';

import '../../entities/aspect.dart';

class getChosenAspectE extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  final String goalName;
  final String goalAspect;
  final int importance; //for the importance if any
  final int goalDuration;
  final String goalDurationDescription;
  final String goalImportanceDescription;
  final DateTime temGoalDataTime;
  final String dueDataDescription;
  final bool weekisSelected;
  final bool daysisSelected;
  final List<Task> goalTasks;
  final int id;
  const getChosenAspectE({
    
 required this.isr, this.chosenAspectNames, required this.goalName, required this.goalAspect, required this.importance, required this.goalDuration, required this.goalDurationDescription, required this.goalImportanceDescription, required this.temGoalDataTime, required this.dueDataDescription, required this.weekisSelected, required this.daysisSelected, required this.goalTasks, required this.id});

  @override
  State<getChosenAspectE> createState() => _showsState();
}

class _showsState extends State<getChosenAspectE> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: widget.isr.getchoseAspect(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? aspects = snapshot.data;
                List<String> chosenAspectNames = [];
                for (int i = 0; i < aspects!.length; i++) {
                  Aspect x = aspects[i];
                  String nameInArabic = "";
                  switch (x.name) {
                    case "money and finances":
                      nameInArabic = "أموالي";
                      break;
                    case "Fun and Recreation":
                      nameInArabic = "متعتي";
                      break;
                    case "career":
                      nameInArabic = "مهنتي";
                      break;
                    case "Significant Other":
                      nameInArabic = "علاقاتي";
                      break;
                    case "Physical Environment":
                      nameInArabic = "بيئتي";
                      break;
                    case "Personal Growth":
                      nameInArabic = "ذاتي";
                      break;

                    case "Health and Wellbeing":
                      nameInArabic = "صحتي";
                      break;
                    case "Family and Friends":
                      nameInArabic = "عائلتي وأصدقائي";
                      break;
                  }

                  chosenAspectNames.add(nameInArabic);
                }
                print(chosenAspectNames);

                return goalDetails(
                  isr: widget.isr,
                  chosenAspectNames: chosenAspectNames,
                  daysisSelected: widget.daysisSelected,
                  dueDataDescription: widget.dueDataDescription,
                  goalImportanceDescription: widget.goalImportanceDescription,
                  goalDuration: widget.goalDuration,
                  temGoalDataTime: widget.temGoalDataTime,
                  goalName: widget.goalName,
                  importance: widget.importance,
                  goalDurationDescription: widget.goalDurationDescription,
                  weekisSelected: widget.weekisSelected,
                  goalAspect: widget.goalAspect,
                  id: widget.id, goalTasks: widget.goalTasks,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
