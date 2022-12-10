import '/isar_service.dart';
import '/entities/aspect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/select_aspectPage/handle_aspect_data.dart';

class AssessmentQuestions {
  IsarService iser = IsarService();
  static int activeStep = 0;
  static List<dynamic> quastionsList = [];
  static Map answers = {};
  static String currentvalue = "";
  static List<dynamic> tempquastionsList = [];
  static double currentChosenAnswer = 0;

  resetQuestions() {
    activeStep = 0;
    quastionsList = [];
    answers = {};
    currentvalue = "";
    tempquastionsList = [];
    currentChosenAnswer = 0;
  }

  Future<List<dynamic>> createQuestionList() async {
    resetQuestions();
    List<Aspect> tempAspect =
        []; //store the fetched chosen aspect from the user
    List<dynamic> tempQuestionList = []; //temporary store one aspect quastion
    tempAspect =
        await handle_aspect().getSelectedAspects(); //fetch the chosen aspect
    List<dynamic> quastionsList = []; //the list of all chosen aspect quastion
    int countr = 0; //to fill in the answer list
    int endpoint = 0; // to know where to stop in creating the answers list ;
    for (int i = 0; i < tempAspect.length; i++) {
      //the output of this loop is the quastion list and the answer list
      Aspect aspect = tempAspect[i];
      switch (aspect.name) {
        // include all the aspect make sure the index is write//
        case "money and finances":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(7));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "0M";
            } else {
              AssessmentQuestions.answers[countr++] = "0M";
            }
          }

          endpoint = countr;
          break;
        case "Fun and Recreation":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(6));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0R";
          }

          endpoint = countr;
          break;
        case "career":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(5));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0C";
          }

          endpoint = countr;
          break;
        case "Significant Other":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(4));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0S";
          }

          endpoint = countr;
          break;
        case "Physical Environment":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(3));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0E";
          }

          endpoint = countr;
          break;
        case "Personal Growth":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(2));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0G";
          }
          endpoint = countr;
          break;

        case "Health and Wellbeing":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(1));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);
          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0H";
          }
          endpoint = countr;
          break;
        case "Family and Friends":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(0));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);
          for (countr;
              countr <= tempQuestionList.length - 1 + endpoint;
              countr++) {
            AssessmentQuestions.answers[countr] = "0F";
          }
          endpoint = countr;

          break;
      }
    }

    return quastionsList;
  }

  void createQuestionAnswersList(
      List<dynamic> questions, List<Aspect> aspects) {
    int countr = 0; //to fill in the answer list
    int endpoint = 0; // to know where to stop in  creating the answers list ;

    for (int i = 0; i < aspects.length; i++) {
      //the output of this loop is the quastion list and the answer list
      Aspect aspect = aspects[i];
      switch (aspect.name) {
        // include all the aspect make sure the index is write
        case "money and finances":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0M";
          }

          endpoint = countr;
          break;
        case "Fun and Recreation":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0R";
          }

          endpoint = countr;
          break;
        case "career":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0C";
          }

          endpoint = countr;
          break;
        case "Significant Other":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0S";
          }

          endpoint = countr;
          break;
        case "Physical Environment":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0E";
          }

          endpoint = countr;
          break;
        case "Personal Growth":
          for (countr; countr < 4 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0G";
          }
          endpoint = countr;
          break;

        case "Health and Wellbeing":
          for (countr; countr < 5 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0H";
          }
          endpoint = countr;
          break;
        case "Family and Friends":
          for (countr; countr < 9 + endpoint; countr++) {
            AssessmentQuestions.answers[countr] = "0F";
          }
          endpoint = countr;
          break;
      }
    }
  }
}
