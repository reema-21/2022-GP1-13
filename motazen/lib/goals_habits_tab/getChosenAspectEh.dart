import 'package:motazen/add_goal_page/add_goal_screen.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/goals_habits_tab/goal_details.dart';
import 'package:motazen/isar_service.dart';

import 'package:flutter/material.dart';

import '../entities/aspect.dart';
import 'habit_datials.dart';

class getChosenAspectEh extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  final String HabitName;
  final String habitAspect;
  final String habitFrequency;

  final int id;
  const getChosenAspectEh({
    super.key,
    required this.isr,
    this.chosenAspectNames, required this.HabitName, required this.habitAspect, required this.habitFrequency, required this.id,
    
    
  });

  @override
  State<getChosenAspectEh> createState() => _showsState();
}

class _showsState extends State<getChosenAspectEh> {
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
                
                return HabitDetails(
                  isr: widget.isr,
                  chosenAspectNames: chosenAspectNames,
                   
                  HabitName: widget.HabitName,
                 habitFrequency:widget.habitFrequency,
                  habitAspect: widget.habitAspect,
                  id:widget.id,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}