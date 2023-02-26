import 'package:cloud_firestore/cloud_firestore.dart';

import '../../entities/aspect.dart';
import '../select_aspectPage/handle_aspect_data.dart';

class TestQuestions {
  CollectionReference aspectQuestions =
      FirebaseFirestore.instance.collection('aspect_Question');

  Future<List> exampleMethod() async {
    //retrieve selected aspects
    List<Aspect> tempAspect = [];
    tempAspect = await handle_aspect().getSelectedAspects();

    //retrieve the info as a snapshot
    List questionList = [];

    for (var aspect in tempAspect) {
      dynamic questionSnapshot = await aspectQuestions.doc(aspect.name).get();
      final currentCommunityDoc =
          questionSnapshot.data() as Map<String, dynamic>;
      final questions =
          currentCommunityDoc["Question"] ?? currentCommunityDoc["Questions"];

      for (var question in questions) {
        questionList
            .add({'aspect': aspect.name, 'question': question, 'points': 0.0});
      }
    }

    return questionList;
  }
}
