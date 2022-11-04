// ignore_for_file: camel_case_types

import 'add_goal_screen.dart';
import '/isar_service.dart';

import 'package:flutter/material.dart';
import '/pages/homepage/homepage.dart';
import '/pages/select_aspectPage/handle_aspect_data.dart';

import '../../data/data.dart';
import '../../entities/aspect.dart';

class getChosenAspect extends StatefulWidget {
  final IsarService iser;
  final List<Aspect>? aspects;
  final String page;
  const getChosenAspect({
    super.key,
    required this.iser,
    required this.aspects,
    required this.page,
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
            future: handle_aspect().getSelectedAspects(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<String> chosenAspectNames = [];
                List<Aspect>? selectedAspects = snapshot.data;
                for (int i = 0; i < selectedAspects!.length; i++) {
                  chosenAspectNames.add(selectedAspects[i].name);
                  for (int j = 0; j < widget.aspects!.length; j++) {
                    if (widget.aspects![j].name == selectedAspects[i].name) {
                      widget.aspects![j].percentagePoints =
                          selectedAspects[i].percentagePoints;
                    }
                  }
                }
                WheelData().copyAspectList(widget.aspects);

                switch (widget.page) {
                  case 'Home':
                    return const Homepage();
                  case 'Goal':
                    return AddGoal(
                      isr: widget.iser,
                      chosenAspectNames: chosenAspectNames, goalsTasks: [],
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
