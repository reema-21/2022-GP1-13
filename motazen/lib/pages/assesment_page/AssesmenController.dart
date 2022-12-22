// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:motazen/pages/assesment_page/assesment_question_page_assignments.dart';

class AssesmentController extends GetxController {
  var activeStep = 0.obs;
  Rx<List<dynamic>> mainquastionsList = Rx<List<dynamic>>(
      []); // this will be always the source first time it will be null if the user reselect the aspect we will know that it is a reselction knowing that this is not null and we will put a set of the question of all the aspect after the reselction in currentquestionList .
  Rx<List<dynamic>> currentquastionsList = Rx<List<dynamic>>(
      []); //  this list will be used when the user reselct aspect in the middle of taking the assesment IN here we will have alist of all question both reselected and preselected we will compare the twe arrayes so that we can know what to add what to delete and check where to complete .
  var currentQuestion = 0.obs;
  Map answers = {}.obs;
  var currentvalue = "".obs;
  RxList<dynamic> tempquastionsList = RxList<dynamic>([]);
  var currentChosenAnswer = 1.obs;

  createQuestion() {
    AssessmentQuestions x = AssessmentQuestions();
    x.createQuestionList().then((value) {
      for (var i in value) {
        mainquastionsList.value.add(i);
      }
    });
  }
}
