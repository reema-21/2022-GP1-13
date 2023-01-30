// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/assesment_page/c.dart';
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
  static Map AnswerdOrnot = {};

  final c freq = Get.put(c(), permanent: true);

  Future<List<dynamic>> createQuestionList() async {
    if (freq.PreviouseSelected.value.isNotEmpty) {
      List<Aspect> tempAspect = [];
      tempAspect =
          await handle_aspect().getSelectedAspects(); //fetch the chosen aspect

      if (freq.PreviouseSelected.value.length < tempAspect.length) {
        bool justAddMoreSameOrder = true;

        for (int i = 0; i < freq.PreviouseSelected.value.length; i++) {
          justAddMoreSameOrder = false;
        }
        if (justAddMoreSameOrder) //!Meaning the user is adding more with same order
        {
          List<Aspect> tempAspect = [];

          //this is for the binding error
          tempAspect = await handle_aspect()
              .getSelectedAspects(); //fetch the chosen aspect

          //store the fetched chosen aspect from the user
          List<dynamic> tempQuestionList =
              []; //temporary store one aspect quastion
          tempAspect = await handle_aspect()
              .getSelectedAspects(); //fetch the chosen aspect

          for (var i in tempAspect) {}
          if (quastionsList.isNotEmpty) {
            quastionsList.clear();
          }

          int countr = 0; //to fill in the answer list
          int endpoint =
              0; // to know where to stop in creating the answers list ;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0M";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0R";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0C";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0S";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0E";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0G";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0H";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
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
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0F";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }
                endpoint = countr;

                break;
            }
          }
        } else {
          //!Meaning the user is adding but no decend order

          for (int i = 0; i < tempAspect.length; i++) {}

          for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {}

          List<Aspect> CommoneAspect = [];
          List<Aspect> NotCommoneAspect = [];
          bool check = true;
          for (int i = 0; i < tempAspect.length; i++) {
            for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {
              if (tempAspect[i].name == freq.PreviouseSelected.value[j].name) {
                CommoneAspect.add(tempAspect[i]);
                break;
              }
            }
          }
          for (int j = 0; j < tempAspect.length; j++) {
            for (int i = 0; i < CommoneAspect.length; i++) {
              if (CommoneAspect[i].name == tempAspect[j].name) {
                check = false;
              }
            }
            if (check) {
              NotCommoneAspect.add(tempAspect[j]);
            }
            check = true;
          }
          List<Aspect> forchecking = [];

          for (int j = 0; j < CommoneAspect.length; j++) {
            forchecking.add(CommoneAspect[j]);
          }

          for (int j = 0; j < NotCommoneAspect.length; j++) {
            CommoneAspect.add(NotCommoneAspect[j]);
          }

          for (int j = 0; j < CommoneAspect.length; j++) {}

          AssessmentQuestions.answers.clear(); // a must
          AssessmentQuestions.AnswerdOrnot.clear();
          int countrr = 0; //to fill in the answer list
          String theRightLetter = "";
          for (int j = 0; j < CommoneAspect.length; j++) {
            String name = CommoneAspect[j].name;
            switch (name) {
              case "money and finances":
                theRightLetter = "M";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);

                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0M") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
              case "Fun and Recreation":
                theRightLetter = "R";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0R") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
              case "career":
                theRightLetter = "C";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0C") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Significant Other":
                theRightLetter = "S";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0S") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Physical Environment":
                theRightLetter = "E";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0E") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Personal Growth":
                theRightLetter = "G";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0G") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;

              case "Health and Wellbeing":
                theRightLetter = "H";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0H") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Family and Friends":
                theRightLetter = "F";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);

                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0F") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
            }
          }
          for (int i = 0; i < AssessmentQuestions.answers.length; i++) {}

          //!Now lets create the quastion list and for answare check befor if added or not the letter
          //!Start of creating the quastion list //
          //? you might face problem with the order of the question with the answare but you might not give it a try :)
          List<Aspect> tempAspectFinal = CommoneAspect;
          //store the fetched chosen aspect from the user
          List<dynamic> tempQuestionList =
              []; //temporary store one aspect quastion

          // List<dynamic> quastionsList =[]; //the list of all chosen aspect quastion (needs to be emptied everytime)
          if (quastionsList.isNotEmpty) {
            quastionsList.clear();
          }
          for (int j = 0; j < forchecking.length; j++) {}

          int countr =
              AssessmentQuestions.answers.length; //to fill in the answer list
          int endpoint = AssessmentQuestions.answers
              .length; // to know where to stop in creating the answers list ;
          for (int i = 0; i < tempAspectFinal.length; i++) {
            //the output of this loop is the quastion list and the answer list
            Aspect aspect = tempAspectFinal[i];
            switch (aspect.name) {
              // include all the aspect make sure the index is write//
              case "money and finances":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(7));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0M";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Fun and Recreation":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(6));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0R";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "career":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(5));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0C";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Significant Other":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(4));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0S";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Physical Environment":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(3));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0E";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Personal Growth":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(2));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0G";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;

              case "Health and Wellbeing":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(1));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0H";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }
                  endpoint = countr;
                }

                break;
              case "Family and Friends":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(0));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0F";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
            }
          }

          freq.AssesmentQuestions.value.addAll(quastionsList);
          freq.PreviouseSelected.value.clear();
          freq.PreviouseSelected.value
              .addAll(await handle_aspect().getSelectedAspects());
          for (int i = 0; i < AssessmentQuestions.answers.length; i++) {
            var result = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            if (result == 0) {
              if (i - 1 >= 0) {
                AssessmentQuestions.activeStep = i - 1;
                break;
              } else {
                AssessmentQuestions.activeStep = i;
                break;
              }
            }
          }
          return quastionsList;
          //! Ends of creating the quastion list //
        }
      } else if (freq.PreviouseSelected.value.length == tempAspect.length) {
        // tow case either excatly the same or just delete and add
        bool excatlyThesame = true;
        for (int i = 0; i < freq.PreviouseSelected.value.length; i++) {
          if (freq.PreviouseSelected.value[i].name != tempAspect[i].name) {
            excatlyThesame = false;
            break;
          }
        }
        if (excatlyThesame) //! this one basicly for checking if the user just go back and front with no changes ;
        {
          //? i don't want to make any changes in here

          quastionsList.clear();
          //get the answares
          AssessmentQuestions.answers.clear();
          AssessmentQuestions.AnswerdOrnot.clear();

          for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
            String currentAnswer = freq.AssesmentAswers.value[i];
            if (currentAnswer.startsWith("0")) {
              AssessmentQuestions.AnswerdOrnot[i] = false;
            } else {
              AssessmentQuestions.AnswerdOrnot[i] = true;
            }
            AssessmentQuestions.answers[i] = freq.AssesmentAswers.value[i];
          }
          //get the question ;
          List<dynamic> tempQuestionList = [];
          for (int i = 0; i < tempAspect.length; i++) {
            Aspect aspect = tempAspect[i];
            switch (aspect.name) {
              case "money and finances":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(7));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "Fun and Recreation":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(6));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "career":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(5));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "Significant Other":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(4));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "Physical Environment":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(3));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "Personal Growth":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(2));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;

              case "Health and Wellbeing":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(1));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                break;
              case "Family and Friends":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(0));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                break;
            }
          }
        } else {
          //!  this one basicly means that the user add and delete and so on
          for (int i = 0; i < tempAspect.length; i++) {}

          for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {}
          List<Aspect> CommoneAspect = [];
          List<Aspect> NotCommoneAspect = [];
          bool check = true;
          for (int i = 0; i < tempAspect.length; i++) {
            for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {
              if (tempAspect[i].name == freq.PreviouseSelected.value[j].name) {
                CommoneAspect.add(tempAspect[i]);
                break;
              }
            }
          }
          for (int j = 0; j < tempAspect.length; j++) {
            for (int i = 0; i < CommoneAspect.length; i++) {
              if (CommoneAspect[i].name == tempAspect[j].name) {
                check = false;
              }
            }
            if (check) {
              NotCommoneAspect.add(tempAspect[j]);
            }
            check = true;
          }
          List<Aspect> forchecking = [];

          for (int j = 0; j < CommoneAspect.length; j++) {
            forchecking.add(CommoneAspect[j]);
          }

          for (int j = 0; j < NotCommoneAspect.length; j++) {
            CommoneAspect.add(NotCommoneAspect[j]);
          }

          for (int j = 0; j < CommoneAspect.length; j++) {}

          AssessmentQuestions.answers.clear(); // a must
          AssessmentQuestions.AnswerdOrnot.clear();
          int countrr = 0; //to fill in the answer list
          String theRightLetter = "";
          for (int j = 0; j < CommoneAspect.length; j++) {
            String name = CommoneAspect[j].name;
            switch (name) {
              case "money and finances":
                theRightLetter = "M";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);

                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0M") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
              case "Fun and Recreation":
                theRightLetter = "R";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0R") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
              case "career":
                theRightLetter = "C";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0C") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Significant Other":
                theRightLetter = "S";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0S") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Physical Environment":
                theRightLetter = "E";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0E") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Personal Growth":
                theRightLetter = "G";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0G") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;

              case "Health and Wellbeing":
                theRightLetter = "H";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);
                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0H") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }
                break;
              case "Family and Friends":
                theRightLetter = "F";
                for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                  String aspectLetter = freq.AssesmentAswers.value[i];

                  String aspectLetter1 =
                      aspectLetter.substring(aspectLetter.length - 1);

                  if (aspectLetter1 == theRightLetter) {
                    AssessmentQuestions.answers[countrr] = aspectLetter;
                    if (aspectLetter == "0F") {
                      AssessmentQuestions.AnswerdOrnot[countrr] = false;
                    } else {
                      AssessmentQuestions.AnswerdOrnot[countrr] = true;
                    }
                    countrr++;
                  }
                }

                break;
            }
          }
          for (int i = 0; i < AssessmentQuestions.answers.length; i++) {}

          //!Now lets create the quastion list and for answare check befor if added or not the letter
          //!Start of creating the quastion list //
          //? you might face problem with the order of the question with the answare but you might not give it a try :)
          List<Aspect> tempAspectFinal = CommoneAspect;
          //store the fetched chosen aspect from the user
          List<dynamic> tempQuestionList =
              []; //temporary store one aspect quastion

          // List<dynamic> quastionsList =[]; //the list of all chosen aspect quastion (needs to be emptied everytime)
          if (quastionsList.isNotEmpty) {
            quastionsList.clear();
          }
          for (int j = 0; j < forchecking.length; j++) {}

          int countr =
              AssessmentQuestions.answers.length; //to fill in the answer list
          int endpoint = AssessmentQuestions.answers
              .length; // to know where to stop in creating the answers list ;
          for (int i = 0; i < tempAspectFinal.length; i++) {
            //the output of this loop is the quastion list and the answer list
            Aspect aspect = tempAspectFinal[i];
            switch (aspect.name) {
              // include all the aspect make sure the index is write//
              case "money and finances":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(7));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0M";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Fun and Recreation":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(6));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0R";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "career":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(5));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0C";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Significant Other":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(4));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0S";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Physical Environment":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(3));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);

                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0E";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
              case "Personal Growth":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(2));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0G";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;

              case "Health and Wellbeing":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(1));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0H";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }
                  endpoint = countr;
                }

                break;
              case "Family and Friends":
                var aspectQuastions = await FirebaseFirestore.instance
                    .collection("aspect_Quastion")
                    .get()
                    .then((value) => value.docs.elementAt(0));

                tempQuestionList =
                    Map<String, dynamic>.from(aspectQuastions.data())
                        .values
                        .toList();
                quastionsList.addAll(tempQuestionList);
                bool isNotThere = true;
                for (int i = 0; i < forchecking.length; i++) {
                  if (forchecking[i].name == aspect.name) {
                    isNotThere = false;
                  }
                }
                if (isNotThere) {
                  for (countr;
                      countr <= tempQuestionList.length - 1 + endpoint;
                      countr++) {
                    if (AssessmentQuestions.answers[countr] == null) {
                      AssessmentQuestions.answers[countr] = "0F";
                      AssessmentQuestions.AnswerdOrnot[countr] = false;
                    }
                  }

                  endpoint = countr;
                }

                break;
            }
          }
        }
      } else {
        //! this one is for the new is less then the pre means deleting maybe adding
        for (int i = 0; i < tempAspect.length; i++) {}

        for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {}
        List<Aspect> CommoneAspect = [];
        List<Aspect> NotCommoneAspect = [];
        bool check = true;
        for (int i = 0; i < tempAspect.length; i++) {
          for (int j = 0; j < freq.PreviouseSelected.value.length; j++) {
            if (tempAspect[i].name == freq.PreviouseSelected.value[j].name) {
              CommoneAspect.add(tempAspect[i]);
              break;
            }
          }
        }
        for (int j = 0; j < tempAspect.length; j++) {
          for (int i = 0; i < CommoneAspect.length; i++) {
            if (CommoneAspect[i].name == tempAspect[j].name) {
              check = false;
            }
          }
          if (check) {
            NotCommoneAspect.add(tempAspect[j]);
          }
          check = true;
        }
        List<Aspect> forchecking = [];

        for (int j = 0; j < CommoneAspect.length; j++) {
          forchecking.add(CommoneAspect[j]);
        }

        for (int j = 0; j < NotCommoneAspect.length; j++) {
          CommoneAspect.add(NotCommoneAspect[j]);
        }

        for (int j = 0; j < CommoneAspect.length; j++) {}

        AssessmentQuestions.answers.clear(); // a must
        AssessmentQuestions.AnswerdOrnot.clear();
        int countrr = 0; //to fill in the answer list
        String theRightLetter = "";
        for (int j = 0; j < CommoneAspect.length; j++) {
          String name = CommoneAspect[j].name;
          switch (name) {
            case "money and finances":
              theRightLetter = "M";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);

                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0M") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }

              break;
            case "Fun and Recreation":
              theRightLetter = "R";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0R") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }

              break;
            case "career":
              theRightLetter = "C";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0C") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }
              break;
            case "Significant Other":
              theRightLetter = "S";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0S") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }
              break;
            case "Physical Environment":
              theRightLetter = "E";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0E") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }
              break;
            case "Personal Growth":
              theRightLetter = "G";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0G") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }

              break;

            case "Health and Wellbeing":
              theRightLetter = "H";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);
                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0H") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }
              break;
            case "Family and Friends":
              theRightLetter = "F";
              for (int i = 0; i < freq.AssesmentAswers.value.length; i++) {
                String aspectLetter = freq.AssesmentAswers.value[i];

                String aspectLetter1 =
                    aspectLetter.substring(aspectLetter.length - 1);

                if (aspectLetter1 == theRightLetter) {
                  AssessmentQuestions.answers[countrr] = aspectLetter;
                  if (aspectLetter == "0F") {
                    AssessmentQuestions.AnswerdOrnot[countrr] = false;
                  } else {
                    AssessmentQuestions.AnswerdOrnot[countrr] = true;
                  }
                  countrr++;
                }
              }

              break;
          }
        }
        for (int i = 0; i < AssessmentQuestions.answers.length; i++) {}

        //!Now lets create the quastion list and for answare check befor if added or not the letter
        //!Start of creating the quastion list //
        //? you might face problem with the order of the question with the answare but you might not give it a try :)
        List<Aspect> tempAspectFinal = CommoneAspect;
        //store the fetched chosen aspect from the user
        List<dynamic> tempQuestionList =
            []; //temporary store one aspect quastion

        if (quastionsList.isNotEmpty) {
          quastionsList.clear();
        }
        for (int j = 0; j < forchecking.length; j++) {}

        int countr =
            AssessmentQuestions.answers.length; //to fill in the answer list
        int endpoint = AssessmentQuestions.answers
            .length; // to know where to stop in creating the answers list ;
        for (int i = 0; i < tempAspectFinal.length; i++) {
          //the output of this loop is the quastion list and the answer list
          Aspect aspect = tempAspectFinal[i];
          switch (aspect.name) {
            // include all the aspect make sure the index is write//
            case "money and finances":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(7));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);
              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0M";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
            case "Fun and Recreation":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(6));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);
              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0R";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
            case "career":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(5));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);

              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0C";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
            case "Significant Other":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(4));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);

              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0S";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
            case "Physical Environment":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(3));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);

              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0E";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
            case "Personal Growth":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(2));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);
              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0G";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;

            case "Health and Wellbeing":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(1));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);
              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0H";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }
                endpoint = countr;
              }

              break;
            case "Family and Friends":
              var aspectQuastions = await FirebaseFirestore.instance
                  .collection("aspect_Quastion")
                  .get()
                  .then((value) => value.docs.elementAt(0));

              tempQuestionList =
                  Map<String, dynamic>.from(aspectQuastions.data())
                      .values
                      .toList();
              quastionsList.addAll(tempQuestionList);
              bool isNotThere = true;
              for (int i = 0; i < forchecking.length; i++) {
                if (forchecking[i].name == aspect.name) {
                  isNotThere = false;
                }
              }
              if (isNotThere) {
                for (countr;
                    countr <= tempQuestionList.length - 1 + endpoint;
                    countr++) {
                  if (AssessmentQuestions.answers[countr] == null) {
                    AssessmentQuestions.answers[countr] = "0F";
                    AssessmentQuestions.AnswerdOrnot[countr] = false;
                  }
                }

                endpoint = countr;
              }

              break;
          }
        }
      }
    }
    //!*****************************8888888888888888888888888888888888888888888888888

    //!Else here is for no previouse selesction

    else {
      List<Aspect> tempAspect =
          []; //store the fetched chosen aspect from the user
      List<dynamic> tempQuestionList = []; //temporary store one aspect quastion
      tempAspect =
          await handle_aspect().getSelectedAspects(); //fetch the chosen aspect

      for (var i in tempAspect) {}

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

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0M";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }

            endpoint = countr;
            break;
          case "Fun and Recreation":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(6));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0R";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }

            endpoint = countr;
            break;
          case "career":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(5));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0C";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }

            endpoint = countr;
            break;
          case "Significant Other":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(4));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0S";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }

            endpoint = countr;
            break;
          case "Physical Environment":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(3));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0E";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }

            endpoint = countr;
            break;
          case "Personal Growth":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(2));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);

            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0G";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }
            endpoint = countr;
            break;

          case "Health and Wellbeing":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(1));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);
            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0H";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }
            endpoint = countr;
            break;
          case "Family and Friends":
            var aspectQuastions = await FirebaseFirestore.instance
                .collection("aspect_Quastion")
                .get()
                .then((value) => value.docs.elementAt(0));

            tempQuestionList = Map<String, dynamic>.from(aspectQuastions.data())
                .values
                .toList();
            quastionsList.addAll(tempQuestionList);
            for (countr;
                countr <= tempQuestionList.length - 1 + endpoint;
                countr++) {
              if (AssessmentQuestions.answers[countr] == null) {
                AssessmentQuestions.answers[countr] = "0F";
                AssessmentQuestions.AnswerdOrnot[countr] = false;
              }
            }
            endpoint = countr;

            break;
        }
      }
    }

    freq.AssesmentQuestions.value.addAll(quastionsList);
    freq.PreviouseSelected.value.clear();
    freq.PreviouseSelected.value
        .addAll(await handle_aspect().getSelectedAspects());
//? You need to assign a value for the active stepper --------------------------------------------------
//? i am search for the first not answerd value .........................................................

    for (int i = 0; i < AssessmentQuestions.answers.length; i++) {
      var result = double.parse(AssessmentQuestions.answers[i]
          .substring(0, AssessmentQuestions.answers[i].length - 1));
      if (result == 0) {
        if (i - 1 >= 0) {
          AssessmentQuestions.activeStep = i - 1;
          break;
        } else {
          AssessmentQuestions.activeStep = i;
          break;
        }
      }
    }
    return quastionsList;
  }
}
