// ignore_for_file: camel_case_types

import '/isar_service.dart';

import 'package:flutter/material.dart';
import '/assesment_page/assesment_question_page_assignments.dart';
import "QuastoinAssesment.dart";

class shows extends StatefulWidget {
  final IsarService iser;
  const shows({super.key, required this.iser});

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
                return IconStepperDemo(isr: widget.iser, q: q);
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
