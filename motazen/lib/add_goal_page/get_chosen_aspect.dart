// ignore_for_file: camel_case_types

import 'package:motazen/add_goal_page/add_goal_screen.dart';
import 'package:motazen/isar_service.dart';

import 'package:flutter/material.dart';

import '../entities/aspect.dart';



class getChosenAspect extends StatefulWidget {
  final IsarService iser;
  const getChosenAspect(
      {super.key, required this.iser,});

  @override
  State<getChosenAspect> createState() => _showsState();
}

class _showsState extends State<getChosenAspect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future:widget.iser.getchoseAspect(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? aspects = snapshot.data;
                List<String> chosenAspectNames =[];
                print("here is the aspects ");
                print(aspects);
                for (int i = 0 ; i<aspects!.length ; i++ ){
                  Aspect x = aspects[i];
                  chosenAspectNames.add(x.name);
                  print(chosenAspectNames);

                }

                return AddGoal(
                    isr: widget.iser,
                    aspects:aspects,
                    );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
