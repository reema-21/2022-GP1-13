// ignore_for_file: camel_case_types

import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:provider/provider.dart';

import '/isar_service.dart';

import 'package:flutter/material.dart';
import '/pages/select_aspectPage/handle_aspect_data.dart';

import '../../data/data.dart';
import '../../entities/aspect.dart';
import 'add_goal_screen.dart';

class getChosenAspect extends StatefulWidget {
  final IsarService iser;
  final String page;
  final List<double>? pointsList;
  const getChosenAspect({
    super.key,
    required this.iser,
    required this.page,
    required List goalsTasks,
    this.pointsList,
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
            future: handle_aspect().getAspects(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                var aspectList = Provider.of<WheelData>(context);
                //prepare the parameter of add goal
                List<String> chosenAspectNames = [];
                //a list of selected aspects
                List<Aspect>? updatedAspects = snapshot.data;
                for (int i = 0; i < updatedAspects!.length; i++) {
                  if (updatedAspects[i].isSelected) {
                    chosenAspectNames.add(updatedAspects[i].name);
                  }
                  if (widget.page == 'Home') {
                    updatedAspects[i].percentagePoints = widget.pointsList![i];
                  }
                }

                aspectList.allAspects = updatedAspects;
                List<String> chosenspectNames = [];

                for (int i = 0; i < chosenAspectNames.length; i++) {
                  String x = chosenAspectNames[i];
                  String nameInArabic = "";
                  switch (x) {
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

                  chosenspectNames.add(nameInArabic);
                }

                switch (widget.page) {
                  case 'Home':
                    return const navBar();
                  case 'Goal':
                    return AddGoal(
                      isr: widget.iser,
                      chosenAspectNames: chosenspectNames,
                      goalsTasks: const [],
                    );
                  default:
                    throw 'Error404: page not found';
                }
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
