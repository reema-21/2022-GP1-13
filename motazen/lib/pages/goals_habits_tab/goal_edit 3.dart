//manar
import 'package:flutter/material.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/pages/goals_habits_tab/goal_details.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '/entities/goal.dart';
import 'package:provider/provider.dart';

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
  late DateTime endDate ; 
  late DateTime startDate ; 
  // DateTime temGoalDataTime = DateTime.utc(1989, 11, 9);
  String dueDataDescription = "";
  List<LocalTask> goalTasks = [];
  Goal? goal;
  bool isLoading = false;
  // bool weekisSelected = false;
  // bool daysisSelected = false;

  @override
  void initState() {
    super.initState();
    getGoalInformation();
    // might be deleted .
  }

  getGoalInformation() async {
    goal = await widget.isr.getSepecificGoall(widget.goalId);
endDate = goal!.endDate ; 
startDate = goal!.startData ; 
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
      // if (goal!.dueDate.compareTo(temGoalDataTime) == 0) {
      //   dueDataDescription = "لايوجد تاريخ استحقاق";
      // } else {
      //   temGoalDataTime = goal!.dueDate;
      //   dueDataDescription = intl.DateFormat.yMMMEd().format(temGoalDataTime);
      // }
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

      // if (goalDuration != 0) {
      //   if (goalDurationDescription.contains("أسبوع")) {
      //     weekisSelected = true;
      //   } else {
      //     //you had a condition  to check whether it contains يوم in here now it is deleted
      //     daysisSelected = true;
      //   }
      // }
      goalTasks = goal!.task.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "معلومات الهدف",
          style: titleText,
        ),
        backgroundColor: kWhiteColor,
        iconTheme: const IconThemeData(color: kBlackColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return goalDetails(
                endDate: endDate ,
                startDate:  startDate, 
                chosenAspectNames: aspectList.selectedArabic,
                isr: widget.isr,
                goalName: displayGoalNameControlller.text,
                goalAspect: goalAspect,
                importance: importance,
                goalDuration: goalDuration,
                goalDurationDescription: goalDurationDescription,
                goalImportanceDescription: goalImportanceDescription,
                // temGoalDataTime: temGoalDataTime,
                dueDataDescription: dueDataDescription,
                // weekisSelected: weekisSelected,
                // daysisSelected: daysisSelected,
                goalTasks: goalTasks,
                id: widget.goalId,
              );
            }));
          },
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        child: const Icon(
          Icons.edit,
          color: Color(0xFF66BF77),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Column(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      "اسم الهدف:",
                      style: titleText2,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      displayGoalNameControlller.text,
                      style: subTitle,
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                 Row(
                      children: [
                        Text(
                          "جانب الحياة:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          goalAspect,
                          style: subTitle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     Row(
                      children: [
                        Text(
                          "تاريخ البدء:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          intl.DateFormat.yMMMEd().format(startDate),
                          style: subTitle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "تاريخ الاستحقاق:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          intl.DateFormat.yMMMEd().format(endDate),
                          style: subTitle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "الفترة:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          goalDurationDescription,
                          style: subTitle,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "الأهمية:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(goalImportanceDescription, style: subTitle)
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "المهام:",
                          style: titleText2,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              padding: kDefaultPadding),
                          onPressed: goalTasks.isNotEmpty
                              ? () {
                                  dialogBox(context);
                                  //the nevigator is downs
                                }
                              : null,
                      child: const Text(
                        "اعرض المهام",
                        style: TextStyle(
                          color: kWhiteColor,
                          fontSize: 16,
                          fontFamily: 'Frutiger',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                CircularPercentIndicator(
                  radius: 120,
                  lineWidth: 20,
                  circularStrokeCap: CircularStrokeCap.round,
                  percent: goal!.goalProgressPercentage,
                  animation: true,
                  animationDuration: 600,
                  progressColor: kPrimaryColor,
                  backgroundColor: kPrimaryColor.withOpacity(0.3),
                  center: Text(
                    '${(goal!.goalProgressPercentage * 100).round().toString()}%',
                    style: titleText,
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }

  dynamic dialogBox(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              "مهام الهدف",
              textAlign: TextAlign.right,
              style: titleText2,
            ),
            content: buildView(context),
          );
        });
  }

  Widget buildView(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: goalTasks.length, //here is what causing the error
          itemBuilder: (context, index) {
            final name = goalTasks[index].name;
            final completionPercentage =
                goalTasks[index].taskCompletionPercentage;
            return Card(
                // here is the code of each item you have
                child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.task, color: Color(0xFF66BF77)),
                  title: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Text(
                      name,
                      style: subTitle,
                    ),
                  ),
                ),
                LinearPercentIndicator(
                  animation: true,
                  animationDuration: 600,
                  curve: Curves.easeIn,

                  ///check later why the value isn't updated
                  percent: completionPercentage,
                  lineHeight: 7,
                  isRTL: true,
                  progressColor: kPrimaryColor,
                  backgroundColor: kPrimaryColor.withOpacity(0.3),
                  barRadius: const Radius.circular(10),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            ));
          }),
    );
  }
}
