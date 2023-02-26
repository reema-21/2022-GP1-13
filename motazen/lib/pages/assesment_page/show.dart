// ignore_for_file: camel_case_types

import 'package:motazen/data/data.dart';
import 'package:motazen/pages/assesment_page/display_assesment.dart';
import 'package:motazen/pages/select_aspectPage/handle_aspect_data.dart';
import 'package:provider/provider.dart';
import '/isar_service.dart';
import 'package:flutter/material.dart';
import 'get_assessment_questions.dart';

class AssessmentQuestionsList extends StatefulWidget {
  final IsarService iser;
  final List<String> unselected;
  const AssessmentQuestionsList({
    super.key,
    required this.iser,
    required this.unselected,
  });

  @override
  State<AssessmentQuestionsList> createState() => _showsState();
}

class _showsState extends State<AssessmentQuestionsList> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: Future.wait([
              TestQuestions().exampleMethod(),
              handle_aspect().getSelectedAspects()
            ]),
            builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? question = snapshot.data![0];
                aspectList.selected = snapshot.data![1];
                if (aspectList.questionData.isNotEmpty) {
                  aspectList.updateQuestionData(question!);
                } else {
                  aspectList.questionData = question!;
                }

                return const AssessmentPage();
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
