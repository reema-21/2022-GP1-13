// ignore_for_file: camel_case_types

import 'package:motazen/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:motazen/assesment_page/assesment_question_page_assignments.dart';
import 'package:motazen/select_aspectPage/select_aspect.dart';

class fetchAspect extends StatefulWidget {
  final IsarService iser;
  const fetchAspect({super.key, required this.iser});

  @override
  State<fetchAspect> createState() => _fetchAspect();
}

class _fetchAspect extends State<fetchAspect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: AssessmentQuestions().aspectsFetching(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? allAspects = snapshot.data;
                return AspectSelection(isr: widget.iser, aspects: allAspects);
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
