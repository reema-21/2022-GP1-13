import 'package:motazen/isarService.dart';

import '/entities/aspect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/pages/select_aspectPage/handle_aspect_data.dart';

class AssessmentQuestions {
  IsarService iser = IsarService();
  static int activeStep = 0;
  static List<dynamic> quastionsList = [];
  static List<dynamic> resectedquestion = [];
  static Map answers = {};
  static String currentvalue = "";
  static List<dynamic> tempquastionsList = [];
  static double currentChosenAnswer = 1;


  void removeDeselectedAnswers(List<String> unselectedAspects) {
    int counter;
    if (unselectedAspects.length > AssessmentQuestions.answers.length) {
      counter = unselectedAspects.length;
    } else {
      counter = AssessmentQuestions.answers.length;
    }
    for (var i = 0; i < counter; i++) {
      for (var item in unselectedAspects) {
        //delete the answers of removed aspects
        switch (item) {
          // include all the aspect make sure the index is write
          case "money and finances":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('M');
            });
            break;
          case "Fun and Recreation":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('R');
            });

            break;

          case "career":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('C');
            });

            break;

          case "Significant Other":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('S');
            });
            break;

          case "Physical Environment":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('E');
            });

            break;
          case "Personal Growth":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('G');
            });
            break;

          case "Health and Wellbeing":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('H');
            });
            break;

          case "Family and Friends":
            AssessmentQuestions.answers.removeWhere((key, value) {
              return value.contains('F');
            });

            break;
        }
      }
    }
  }

  Future<List<dynamic>> createQuestionList() async {
    
    List<Aspect> tempAspect =
        []; //store the fetched chosen aspect from the user
    List<dynamic> tempQuestionList = []; //temporary store one aspect quastion
    tempAspect =
        await handle_aspect().getSelectedAspects(); //fetch the chosen aspect
    List<dynamic> quastionsList =
        []; //the list of all chosen aspect quastion (needs to be emptied everytime)
    if (quastionsList.isNotEmpty) {
      quastionsList.clear();
    }

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
              AssessmentQuestions.answers[countr] = "1M";
            }
            // else {
            //   AssessmentQuestions.answers[countr++] = "1M";
            // }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1R";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1C";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1S";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1E";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1G";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1H";
            }
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
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1F";
            }
          }
          endpoint = countr;

          break;
      }
    }

    return quastionsList;
  }

  void createQuestionAnswersList(
      List<dynamic> questions, List<Aspect> aspects) {
    ///check if global list is empty, if not return it's content and save the answers to a global list at the end
    int countr = 0; //to fill in the answer list
    int endpoint = 0; // to know where to stop in creating the answers list ;

    for (int i = 0; i < aspects.length; i++) {
      //the output of this loop is the quastion list and the answer list
      Aspect aspect = aspects[i];
      switch (aspect.name) {
        // include all the aspect make sure the index is write
        case "money and finances":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1M";
            }
          }

          endpoint = countr;
          break;
        case "Fun and Recreation":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1R";
            }
          }

          endpoint = countr;
          break;
        case "career":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1C";
            }
          }

          endpoint = countr;
          break;
        case "Significant Other":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1S";
            }
          }

          endpoint = countr;
          break;
        case "Physical Environment":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1E";
            }
          }

          endpoint = countr;
          break;
        case "Personal Growth":
          for (countr; countr < 4 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1G";
            }
          }
          endpoint = countr;
          break;

        case "Health and Wellbeing":
          for (countr; countr < 5 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1H";
            }
          }
          endpoint = countr;
          break;
        case "Family and Friends":
          for (countr; countr < 9 + endpoint; countr++) {
            if (AssessmentQuestions.answers[countr] == null) {
              AssessmentQuestions.answers[countr] = "1F";
            }
          }
          endpoint = countr;
          break;
      }
    }
  }
}
