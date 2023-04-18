import 'package:cloud_firestore/cloud_firestore.dart';

class TestQuestions {
  CollectionReference aspectQuestions =
      FirebaseFirestore.instance.collection('aspect_Question');

  Future<List> retrieveQuestions(List<String> aspectNames) async {
    //retrieve the info as a snapshot
    List questionList = [];

    for (var aspect in aspectNames) {
      dynamic questionSnapshot = await aspectQuestions.doc(aspect).get();
      final currentAspectDoc = questionSnapshot.data() as Map<String, dynamic>;
      final questions =
          currentAspectDoc["Question"] ?? currentAspectDoc["Questions"];

      for (var question in questions) {
        questionList
            .add({'aspect': aspect, 'question': question, 'points': 0.0});
      }
    }

    return questionList;
  }
}
