import 'package:motazen/isar_service.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'assesmentQuestionPageGlobals.dart'; // for the global varible

class AssesmentQuestionPageAssignments {
  IsarService iser = IsarService();
  Future<List<dynamic>> questionListCreationg() async {
    List<Aspect> tempAspect = []; //store the fetched chosen aspect from the user 
    List<dynamic> tempQuestionList = [];//temporary store one aspect quastion 
    tempAspect = await iser.getAspectFirstTime(); //fetch the chosen aspect 
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
              .then((value) => value.docs.elementAt(8));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0M";
          }

          endpoint = countr;
          break;
        case "Fun and Recreation":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(7));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0R";
          }

          endpoint = countr;
          break;
        case "career":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(6));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0C";
          }

          endpoint = countr;
          break;
        case "Significant Other":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(5));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0S";
          }

          endpoint = countr;
          break;
        case "Physical Environment":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(4));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0E";
          }

          endpoint = countr;
          break;
        case "Personal Growth":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(3));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0G";
          }
          endpoint = countr;
          break;

        case "Health and Wellbeing":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(2));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);
          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0H";
          }
          endpoint = countr;
          break;
        case "Friends":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(1));

          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);
          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0D";
          }
          endpoint = countr;
          break;
        case "Family":
          var aspectQuastions = await FirebaseFirestore.instance
              .collection("aspect_Quastion")
              .get()
              .then((value) => value.docs.elementAt(0));
          tempQuestionList =
              Map<String, dynamic>.from(aspectQuastions.data()).values.toList();
          quastionsList.addAll(tempQuestionList);

          for (countr; countr <= tempQuestionList.length - 1 + endpoint; countr++) {
            AssesmentQuestionPageGlobals.answares[countr] = "0F";
          }
          endpoint = countr;
          break;
      }
    }
    createQuestionAnswersList (quastionsList , tempAspect);
    return quastionsList;
  }

  Map<dynamic , dynamic> createQuestionAnswersList (List<dynamic> questions , List<Aspect> aspects ){
  Map answares = {};
  



  return answares ; 

  }
}
