import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/pages/assesment_page/display_assesment.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'get_assessment_questions.dart';

class AssessmentQuestionsList extends StatefulWidget {
  final List<String> unselected;
  final List<String> selected;
  const AssessmentQuestionsList({
    super.key,
    required this.unselected,
    required this.selected,
  });

  @override
  State<AssessmentQuestionsList> createState() => _ShowsState();
}

class _ShowsState extends State<AssessmentQuestionsList> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: Future.wait([
              TestQuestions().retrieveQuestions(widget.selected),
              // HandleAspect().getSelectedAspects()
            ]),
            builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List? question = snapshot.data![0];
                // aspectList.selected = snapshot.data![1];
                if (aspectList.questionData.isNotEmpty) {
                  aspectList.updateQuestionData(question!);
                } else {
                  aspectList.questionData = question!;
                }

                return AssessmentPage(
                  selected: widget.selected,
                  unselected: widget.unselected,
                );
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
