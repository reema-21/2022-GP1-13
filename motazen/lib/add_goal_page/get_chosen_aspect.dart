// ignore_for_file: camel_case_types

import 'package:motazen/add_goal_page/add_goal_screen.dart';
import 'package:motazen/isar_service.dart';

import 'package:flutter/material.dart';

import '../entities/aspect.dart';
import '../entities/task.dart';

class getChosenAspect extends StatefulWidget {
  final IsarService iser;
    final List <Task> goalsTasks ; 

  const getChosenAspect({
    super.key,
    required this.iser, required this.goalsTasks,
  });

  @override
  State<getChosenAspect> createState() => _showsState();
}

class _showsState extends State<getChosenAspect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: widget.iser.getchoseAspect(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? aspects = snapshot.data;
                List<String> chosenAspectNames =[];
                for (int i = 0 ; i<aspects!.length ; i++ ){
                  Aspect x = aspects[i];
                  String nameInArabic ="";
                  switch(x.name){
        case "money and finances":
          nameInArabic ="أموالي";
          break;
        case "Fun and Recreation":
         nameInArabic ="متعتي";
          break;
        case "career":
          nameInArabic ="مهنتي";
          break;
        case "Significant Other":
         nameInArabic ="علاقاتي";
          break;
        case "Physical Environment":
         nameInArabic ="بيئتي";
          break;
        case "Personal Growth":
          nameInArabic ="ذاتي";
          break;

        case "Health and Wellbeing":
        nameInArabic ="صحتي";
          break;
        case "Family and Friends":
         nameInArabic ="عائلتي وأصدقائي";
          break;
      }
                  
                  chosenAspectNames.add(nameInArabic);
                
                }
                print(chosenAspectNames);
                return AddGoal(
                    isr: widget.iser,
                    chosenAspectNames:chosenAspectNames,
                    goalsTasks: widget.goalsTasks,

                    );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
