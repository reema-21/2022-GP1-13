// ignore_for_file: camel_case_types

import 'add_habit.dart';
import '/isar_service.dart';

import 'package:flutter/material.dart';

import '../../entities/aspect.dart';

class getChosenAspectH extends StatefulWidget {
  final IsarService iser;
  const getChosenAspectH({
    super.key,
    required this.iser,
  });

  @override
  State<getChosenAspectH> createState() => _showsState();
}

class _showsState extends State<getChosenAspectH> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: widget.iser.getchoseAspect(),
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
                return AddHabit(
                  isr: widget.iser,
                  chosenAspectNames: chosenAspectNames,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
