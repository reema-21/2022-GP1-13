// ignore_for_file: camel_case_types

import 'package:provider/provider.dart';

import 'add_goal_screen.dart';
import '/isar_service.dart';

import 'package:flutter/material.dart';
import '/pages/homepage/homepage.dart';
import '/pages/select_aspectPage/handle_aspect_data.dart';

import '../../data/data.dart';
import '../../entities/aspect.dart';

class getChosenAspect extends StatefulWidget {
  final IsarService iser;
  final String page;
  final List<double>? pointsList;
  const getChosenAspect({
    super.key,
    required this.iser,
    required this.page,
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
                  updatedAspects[i].percentagePoints = widget.pointsList![i];
                }

                aspectList.allAspects = updatedAspects;

                switch (widget.page) {
                  case 'Home':
                    return const Homepage();
                  case 'Goal':
                    return AddGoal(
                      isr: widget.iser,
                      chosenAspectNames: chosenAspectNames,
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
