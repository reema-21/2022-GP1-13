import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import '../../entities/task.dart';
import '/entities/goal.dart';
import '/pages/goals_habits_tab/getchosenAspect_editing.dart';
import '/isar_service.dart';

import 'package:intl/intl.dart' as intl;

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
  List<Task> goalTasks = [];
  Goal? goal;
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
    goal = await widget.isr.getSepecificGoall(widget.goalId);

    setState(() {
      displayGoalNameControlller.text = goal!.titel;
      goalAspect = goal!.aspect.value!.name;
      
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
      if (goalDuration != 0) {
        goalDurationDescription = goal!.DescriptiveGoalDuration;
      }

      if (goalDuration != 0) {
        if (goalDurationDescription.contains("أسبوع")) {
          weekisSelected = true;
        } else  { //you had a condition  to check whether it contains يوم in here now it is deleted 
          daysisSelected = true;
        }
      }
      goalTasks = goal!.task.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return getChosenAspectE(
                  isr: widget.isr,
                  goalName: displayGoalNameControlller.text,
                  goalAspect: goalAspect,
                  importance: importance,
                  goalDuration: goalDuration,
                  goalDurationDescription: goalDurationDescription,
                  goalImportanceDescription: goalImportanceDescription,
                  temGoalDataTime: temGoalDataTime,
                  dueDataDescription: dueDataDescription,
                  weekisSelected: weekisSelected,
                  daysisSelected: daysisSelected,
                  goalTasks: goalTasks,
                  id: widget.goalId,
                ); // must be the
              }));
            },
            backgroundColor: const Color.fromARGB(255, 252, 252, 252),
            child: const Icon(
              Icons.edit,
              color: Color(0xFF66BF77),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          body: Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("معلومات الهدف",
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0), fontSize: 30)),
                  const SizedBox(
                    width: 170,
                  ),
                  IconButton(
                      // ignore: prefer_const_constructors
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const navBar();
                        }));
                      }),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(66, 102, 191, 118),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Stack(
                    children: [
                      ClipPath(
                          clipper: WaveClipperTwo(),
                          child: Container(
                            height: 100,
                            color: const Color.fromARGB(255, 255, 253, 254),
                          )),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "اسم الهدف:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  displayGoalNameControlller.text,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "جانب الحياة:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  goalAspect,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "تاريخ الاستحقاق:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  dueDataDescription,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "الفترة:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  goalDurationDescription,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "الأهمية:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  goalImportanceDescription,
                                  style: const TextStyle(
                                      fontSize: 22, color: Colors.black54),
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "المهام:",
                                  style: TextStyle(fontSize: 23),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                // Text(
                                //  goalTasks.isEmpty?"لايوجد مهام":"",
                                //   style: const TextStyle(
                                //       fontSize: 22, color: Colors.black54),
                                // )
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF66BF77),
                                  ),
                                  onPressed: goalTasks.isNotEmpty
                                      ? () {
                                          dialogBox(context);
//the nevigator is downs
                                        }
                                      : null,
                                  child: const Text("اعرض المهام"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ));
  }

  dynamic dialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              "مهام الهدف",
              textAlign: TextAlign.right,
            ),
            content: buildView(context),
          );
        });
  }

  Widget buildView(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: goalTasks.length, //here is what causing the error
            itemBuilder: (context, index) {
              final name = goalTasks[index].name;
              return Card(
                  // here is the code of each item you have
                  child: ListTile(
                leading: const Icon(Icons.task, color: Color(0xFF66BF77)),
                title: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Text(name),
                ),
              ));
            }),
      ),
    );
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
