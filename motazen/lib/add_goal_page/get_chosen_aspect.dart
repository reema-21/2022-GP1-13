// ignore_for_file: camel_case_types

import 'package:motazen/add_goal_page/add_goal_screen.dart';
import 'package:motazen/isar_service.dart';

import 'package:flutter/material.dart';
import 'package:motazen/pages/homepage/homepage.dart';
import 'package:motazen/select_aspectPage/handle_aspect_data.dart';
import 'package:provider/provider.dart';

import '../data/data.dart';
import '../entities/aspect.dart';

class getChosenAspect extends StatefulWidget {
  final IsarService iser;
  final List<Aspect>? aspects;
  const getChosenAspect({
    super.key,
    required this.iser,
    required this.aspects,
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

                return Homepage();
                // return AddGoal(
                //   isr: widget.iser,
                //   chosenAspectNames: chosenAspectNames,
                // );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
