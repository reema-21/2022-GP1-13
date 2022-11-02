// ignore_for_file: camel_case_types

import '/isar_service.dart';

import 'package:flutter/material.dart';
import 'assesment_question_page_assignments.dart';

import 'QuastoinAssesment.dart';

class AssessmentQuestionsList extends StatefulWidget {
  final IsarService iser;
  final List<dynamic>? fixedAspect;
  final List<dynamic>? chosenAspect;
  const AssessmentQuestionsList(
      {super.key, required this.iser, this.fixedAspect, this.chosenAspect});

  @override
  State<AssessmentQuestionsList> createState() => _showsState();
}

class _showsState extends State<AssessmentQuestionsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: AssessmentQuestions().createQuestionList(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? question = snapshot.data;
                return WheelOfLifeAssessmentPage(
                    isr: widget.iser,
                    question: question,
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
