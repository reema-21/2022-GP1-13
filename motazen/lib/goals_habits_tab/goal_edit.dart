import 'package:flutter/material.dart';
import 'package:motazen/add_goal_page/get_chosen_aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/goals_habits_tab/getchosenAspect_editing.dart';
import 'package:motazen/goals_habits_tab/goal_list_screen.dart';
import 'package:motazen/isar_service.dart';

import 'package:intl/intl.dart' as intl;

//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency
class EditGoal extends StatefulWidget {
  final IsarService isr;
  final int goalId;
  const EditGoal({super.key, required this.isr, required this.goalId});

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  TextEditingController displayGoalNameControlller = TextEditingController();
  String goalAspect = ""; //for the dropMenu A must
  int importance = 0; //for the importance if any
  int goalDuration = 0;
  String goalDurationDescription = "-";
  String goalImportanceDescription = "-";
  DateTime temGoalDataTime = DateTime.utc(1989, 11, 9);
  String dueDataDescription = "";
  Goal? goal = Goal();
  bool isLoading = false;
  bool weekisSelected = false;
  bool daysisSelected = false;

  @override
  void initState() {
    super.initState();
    getGoalInformation();
    // might be deleted .
  }

  getGoalInformation() async {
    goal = await widget.isr.getSepecificGoal(widget.goalId);

    setState(() {
      displayGoalNameControlller.text = goal!.titel;
      print(displayGoalNameControlller.text);
      goalAspect = goal!.aspect.value!.name;
      print(goalAspect);
      switch (goalAspect) {
        case "money and finances":
          goalAspect = "أموالي";
          break;
        case "Fun and Recreation":
          goalAspect = "متعتي";
          break;
        case "career":
          goalAspect = "مهنتي";
          break;
        case "Significant Other":
          goalAspect = "علاقاتي";
          break;
        case "Physical Environment":
          goalAspect = "بيئتي";
          break;
        case "Personal Growth":
          goalAspect = "ذاتي";
          break;

        case "Health and Wellbeing":
          goalAspect = "صحتي";
          break;
        case "Family and Friends":
          goalAspect = "عائلتي وأصدقائي";
          break;
      }
      //take the otherfeild incase there we not noll
      if (goal!.dueDate.compareTo(temGoalDataTime) == 0) {
        dueDataDescription = "لايوجد تاريخ استحقاق";
      } else {
        temGoalDataTime = goal!.dueDate;
        dueDataDescription = intl.DateFormat.yMMMEd().format(temGoalDataTime);
      }
      importance = goal!.importance;

      switch (importance) {
        case 1:
          goalImportanceDescription = "منخفضة";
          break;
        case 2:
          goalImportanceDescription = "متوسطة";

          break;
        case 3:
          goalImportanceDescription = "مرتفعة";

          break;
      }

      goalDuration = goal!.goalDuration;
      if(goalDuration!= 0 )
      goalDurationDescription = goal!.DescriptiveGoalDuration;

      if (goalDuration != 0) {
        if (goalDurationDescription.contains("أسبوع")) {
          weekisSelected = true;
          print ("i am here");
        } else  if (goalDurationDescription.contains("يوم")){
          daysisSelected = true;
           print ("i am here");

        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF66BF77),
                  title: const Text(
                    "معلومات الهدف",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        // ignore: prefer_const_constructors
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return GoalListScreen(isr: widget.isr);
                          }));
                        })
                  ],
                ),
                body: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "اسم الهدف:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                displayGoalNameControlller.text,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "جانب الحياة:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                goalAspect,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "تاريخ الاستحقاق:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                dueDataDescription,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "الفترة:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                goalDurationDescription,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "الأهمية:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                goalImportanceDescription,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
                bottomSheet: TextButton(
                    child: const Text("تعديل"),
                    onPressed: () {
                      print(daysisSelected);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return   getChosenAspectE(
                        isr: widget.isr,
                        daysisSelected: daysisSelected,
                        dueDataDescription: dueDataDescription,
                        goalAspect: goalAspect,
                        goalImportanceDescription: goalImportanceDescription,
                        temGoalDataTime: temGoalDataTime,
                        goalDurationDescription: goalDurationDescription,
                        importance: importance,
                        goalName: displayGoalNameControlller.text,
                        goalDuration: goalDuration,
                        weekisSelected: weekisSelected,
                      ); ; // must be the
                    }));
                    
                    }))));
  }

//   Widget buildTextField(String labelText ,String placeholder){
//     return Padding(padding: EdgeInsets.only(bottom: 30),

//     child: TextField(
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(bottom: 5 ),
//         labelText:labelText,
//         floatingLabelBehavior:FloatingLabelBehavior.always,
// hintText: placeholder,
// hintStyle: TextStyle

//       ),
//     ),

//     );
//   }
}
