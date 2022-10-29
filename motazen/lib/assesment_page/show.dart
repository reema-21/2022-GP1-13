// ignore_for_file: camel_case_types

import 'package:motazen/isar_service.dart';

import 'package:flutter/material.dart';
import 'package:motazen/assesment_page/assesment_question_page_assignments.dart';
import 'QuastoinAssesment.dart';

class shows extends StatefulWidget {
  final IsarService iser;
  final List<dynamic>? fixedAspect;
  final List<dynamic>? chosenAspect;
  const shows(
      {super.key, required this.iser, this.fixedAspect, this.chosenAspect});

  @override
  State<shows> createState() => _showsState();
}

class _showsState extends State<shows> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: AssesmentQuestionPageAssignments().questionListCreationg(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? q = snapshot.data;
                return IconStepperDemo(
                    isr: widget.iser,
                    q: q,
                    fixedAspect: widget.fixedAspect,
                    chosenAspect: widget.chosenAspect);
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
