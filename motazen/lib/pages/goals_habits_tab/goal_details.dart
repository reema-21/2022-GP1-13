// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_field, unused_local_variable, must_call_super

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/pages/goals_habits_tab/taskClass.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_goal_page/taskLocal_controller.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';

import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../Sidebar_and_navigation/navigation-bar.dart';
import '/entities/goal.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../entities/aspect.dart';
import 'Edit_task.dart';

//alertof completion //tasks // getbeck to the list page // goal dependency
class goalDetails extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  final String goalName;
  final String goalAspect;
  final int importance; //for the importance if any
  final int goalDuration;
  final String goalDurationDescription;
  final String goalImportanceDescription;
  final DateTime temGoalDataTime;
  final String dueDataDescription;
  final bool weekisSelected;
  final bool daysisSelected;
  final int id;
  final List<LocalTask> goalTasks;
  const goalDetails({
    super.key,
    required this.isr,
    required this.goalName,
    required this.goalAspect,
    required this.importance,
    required this.goalDuration,
    required this.goalDurationDescription,
    required this.goalImportanceDescription,
    required this.temGoalDataTime,
    required this.dueDataDescription,
    required this.weekisSelected,
    required this.daysisSelected,
    this.chosenAspectNames,
    required this.id,
    required this.goalTasks,
  });

  @override
  State<goalDetails> createState() => _goalDetailsState();
}

class _goalDetailsState extends State<goalDetails> {
  Future<List<LocalTask>> getTasks() async {
    Goal? goal = Goal();
    goal = await widget.isr.getSepecificGoall(widget.id);
    return goal!.task.toList();
  }

  final TaskLocalControleer freq = Get.put(TaskLocalControleer());

  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.utc(1989, 11, 9);
  DateTime? noDateChosenForThisGoal;
  int goalDuration = 0;
  List<LocalTask> goalTasks = [];
  List<LocalTask> oldgoalTasks = [];
  int checkGoalDuration = 0;

  String duration = "???????????????????? ?????????????? ???????????? ?????????? ???????? ?????????? ???? ????????????";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _goalaspectController = TextEditingController();

  final _dueDateController = TextEditingController();
  bool isDataSelected = false;
  bool? _checkBox = false;
  bool? _ListtileCheckBox = false;

  String? isSelected;
  String aspectnameInEnglish = "";
  @override
  void initState() {
    int sum = 0;
    goalTasks = widget.goalTasks;
    for (int i = 0; i < goalTasks.length; i++) {
      sum = sum + goalTasks[i].duration;
      LocalTask x = LocalTask();
      x.name = goalTasks[i].name;
      x.duration = goalTasks[i].duration;
      x.durationDescribtion = goalTasks[i].durationDescribtion;
      oldgoalTasks.add(x);
    }
    freq.checkTotalTaskDuration.value = sum;
    // oldgoalTasks=widget.goalTasks;
    checkGoalDuration = widget.goalDuration;

    for (int i = 0; i < goalTasks.length; i++) {}
    if (!(widget.goalDuration == 0)) {
      duration = widget.goalDurationDescription;
    }
    _goalNmaeController.text = widget.goalName;
    importance = widget.importance;
    for (int i = 0; i < widget.chosenAspectNames!.length; i++) {
      String name = widget.chosenAspectNames![i];
      if (name.contains(widget.goalAspect)) {
        isSelected = widget.chosenAspectNames![i];
      }
    }
    _goalaspectController.text = isSelected!;

    switch (isSelected) {
      case "????????????":
        aspectnameInEnglish = "money and finances";
        break;
      case "??????????":
        aspectnameInEnglish = "Fun and Recreation";
        break;
      case "??????????":
        aspectnameInEnglish = "career";
        break;
      case "??????????????":
        aspectnameInEnglish = "Significant Other";
        break;
      case "??????????":
        aspectnameInEnglish = "Physical Environment";
        break;
      case "????????":
        aspectnameInEnglish = "Personal Growth";
        break;

      case "????????":
        aspectnameInEnglish = "Health and Wellbeing";
        break;
      case "???????????? ????????????????":
        aspectnameInEnglish = "Family and Friends";
        break;
    }
    _checkBox = widget.daysisSelected;
    _ListtileCheckBox = widget.weekisSelected;
    //you made this comment so that you can cover the date when there is no date and then you select one
    if (!widget.dueDataDescription.contains("???????????? ?????????? ??????????????")) {
      selectedDate = widget.temGoalDataTime;
      isDataSelected = true;
    }
    getTasks().then((value) {
      for (var i in value) {
        TaskData t = TaskData();
        t.name = i.name;
        for (var j in i.TaskDependency) {
          t.TaskDependency.add(j.name);
        }
        freq.OrginalTasks.value.add(t);
      }
    });
  }

  Goal? goal = Goal();

  Addgoal() async {
    goal = await widget.isr.getSepecificGoall(widget.id);
    goal?.titel = _goalNmaeController.text;
    goal?.importance = importance;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    goal?.aspect.value = selected;
    selected!.goals.add(goal!);
    widget.isr.createAspect(selected);
    goal?.DescriptiveGoalDuration = duration;
    goal?.goalDuration = goalDuration;

    var task = [];
    task = widget.goalTasks;

    for (int i = 0; i < widget.goalTasks.length; i++) {
      LocalTask? y = LocalTask();
      String name = "";

      name = task[i].name;

      y = await widget.isr.findSepecificTask(name);

      if (y != null) {
        goal!.task.add(y);
        y.goal.value = goal;
        goal!.task.add(y); // to link the task to the goal
        widget.isr.saveTask(y);
      }
    }

    goal!.dueDate = selectedDate;

    widget.isr.UpdateGoal(goal!);
    freq.TaskDuration = 0.obs;
    freq.currentTaskDuration = 0.obs;
    freq.totalTasksDuration = 0.obs;
    freq.iscool = false.obs;
    freq.tem = 0.obs;
    freq.isSelected = "????????".obs;
    freq.goalTask = Rx<List<LocalTask>>([]);
    Rx<List<TaskData>> allTaskForDepency = Rx<List<TaskData>>([]);

    freq.newTasksAddedInEditing = Rx<List<LocalTask>>([]);
    freq.TasksMenue.value.clear();
    freq.selectedTasks.value.clear();
    freq.itemCount = 0.obs;
    freq.itemCountAdd = 0.obs;
    Get.to(() => const navBar(
          selectedIndex: 1,
        ));
  }

//do the case when the date was selceted and then deleted //
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green.shade300,
                duration: const Duration(milliseconds: 700),
                content: Row(
                  children: const [
                    Icon(Icons.thumb_up_sharp),
                    SizedBox(width: 20),
                    Expanded(
                      child: Text("?????? ?????????? ?????????? "),
                    )
                  ],
                )));

            Addgoal()();
          }
        },
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        child: const Icon(Icons.save, color: Color(0xFF66BF77)),
      ),
      key: _scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF66BF77),
        title: const Text(
          "?????????? ?????????????? ??????????",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
              // ignore: prefer_const_constructors
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () async {
                final action = await AlertDialogs.yesCancelDialog(
                    context,
                    ' ???? ?????? ?????????? ???? ???????????? ',
                    '???????????? ?????? "??????????"???? ?????? ?????? ???? ?????????????? ?????? ?????? ');
                if (action == DialogsAction.yes) {
                  // here is should make sure to fetch the tasks to take itis depenency before saving it
                  List<LocalTask> g = [];
                  Goal? goal = Goal();
                  goal = await widget.isr.getSepecificGoall(widget.id);
                  g = goal!.task.toList();
                  for (int i = 0; i < g.length; i++) {
                    widget.isr.deleteTask(g[i].id);
                  }
                  for (int i = 0; i < oldgoalTasks.length; i++) {
                    //this for canceling
                    //here i will add new code for the dependncy
                    List<String> Taskss =
                        freq.OrginalTasks.value[i].TaskDependency;
                    await Future.forEach(Taskss, (item) async {
                      LocalTask? y = LocalTask();
                      String name = item;

                      y = await widget.isr.findSepecificTask(name);
                      oldgoalTasks[i]
                          .TaskDependency
                          .add(y!); // to link task and it depends tasks ;
                      // widget.isr.saveTask(y);// to link
                    });

                    widget.isr.saveTask(oldgoalTasks[i]);
                    Goal? goal = Goal();
                    goal = await widget.isr.getSepecificGoall(widget.id);
                    goal!.task.add(oldgoalTasks[i]);

                    widget.isr.createGoal(goal);
                    oldgoalTasks[i].goal.value = goal;
                    widget.isr.saveTask(oldgoalTasks[i]);
                  }

                  freq.TaskDuration = 0.obs;
                  freq.currentTaskDuration = 0.obs;
                  freq.totalTasksDuration = 0.obs;
                  freq.iscool = false.obs;
                  freq.tem = 0.obs;
                  freq.isSelected = "????????".obs;
                  freq.goalTask = Rx<List<LocalTask>>([]);
                  freq.allTaskForDepency = Rx<List<TaskData>>([]);

                  freq.newTasksAddedInEditing = Rx<List<LocalTask>>([]);

                  freq.TasksMenue.value.clear();
                  freq.selectedTasks.value.clear();
                  freq.OrginalTasks.value.clear();

                  freq.itemCount = 0.obs;
                  freq.itemCountAdd = 0.obs;

                  Get.to(() => const navBar(
                        selectedIndex: 1,
                      ));
                } else {}
              }),
        ],
      ),
      body: Stack(
        children: [
          Container(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: formKey,
                  child: ListView(children: [
                    TextFormField(
                      controller: _goalNmaeController,
                      //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "???? ???????? ???????? ?????? ??????????";
                        } else {
                          return null;
                        }
                      },

                      decoration: const InputDecoration(
                        labelText: "?????? ??????????",
                        prefixIcon: Icon(
                          Icons.pie_chart,
                          color: Color(0xFF66BF77),
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),

                    /// Aspect selectio
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: const Duration(milliseconds: 900),
                            backgroundColor:
                                const Color.fromARGB(255, 230, 38, 38),
                            content: Row(
                              children: const [
                                Icon(
                                  Icons.error,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Text("???? ???????? ?????????? ???????? ???????? ?????????? ",
                                      style: TextStyle(color: Colors.black)),
                                )
                              ],
                            )));
                      },
                      child: TextFormField(
                        enabled: false,
                        controller: _goalaspectController,
                        //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.

                        decoration: const InputDecoration(
                          labelText: "???????? ???????????? ",
                          prefixIcon: Icon(
                            Icons.verified_user_outlined,
                            color: Color.fromARGB(255, 164, 175, 166),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )

                    // DropdownButtonFormField(

                    //   value: isSelected,
                    //   items: aspectList.selectedArabic
                    //       .map((e) => DropdownMenuItem(
                    //             value: e,
                    //             child: Text(e),
                    //           ))
                    //       .toList(),
                    //   onChanged: (val) {
                    //     setState(() {
                    //       isSelected = val as String;
                    //       switch (isSelected) {
                    //         case "????????????":
                    //           aspectnameInEnglish = "money and finances";
                    //           break;
                    //         case "??????????":
                    //           aspectnameInEnglish = "Fun and Recreation";
                    //           break;
                    //         case "??????????":
                    //           aspectnameInEnglish = "career";
                    //           break;
                    //         case "??????????????":
                    //           aspectnameInEnglish = "Significant Other";
                    //           break;
                    //         case "??????????":
                    //           aspectnameInEnglish = "Physical Environment";
                    //           break;
                    //         case "????????":
                    //           aspectnameInEnglish = "Personal Growth";
                    //           break;

                    //         case "????????":
                    //           aspectnameInEnglish = "Health and Wellbeing";
                    //           break;
                    //         case "???????????? ????????????????":
                    //           aspectnameInEnglish = "Family and Friends";
                    //           break;
                    //       }
                    //     });
                    //   },
                    //   icon: const Icon(
                    //     Icons.arrow_drop_down_circle,
                    //     color: Color(0xFF66BF77),
                    //   ),
                    //   isDense: true,
                    //   validator: (value) {
                    //     print("here ere her");
                    //     if(value != widget.goalAspect) {
                    //       '???? ???????? ???????? ???????? ???????????? ?????????????? ??????????';
                    //                                   value  = widget.goalAspect ;

                    //     }

                    //     else
                    //        null;
                    //   },
                    //   decoration: const InputDecoration(
                    //     labelText: "?????????? ???????????? ",
                    //     prefixIcon: Icon(
                    //       Icons.pie_chart,
                    //       color: Color(0xFF66BF77),
                    //     ),
                    //     border: UnderlineInputBorder(),
                    //   ),
                    // ),
                    ,
                    const SizedBox(
                      height: 25,
                    ),
                    //due date .
                    DateTimeFormField(
                        //you chaneg in here =============================================
                        initialValue: isDataSelected
                            ? selectedDate
                            : noDateChosenForThisGoal,
                        //make it with time write now there is a way for only date
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: '?????????? ??????????????????',
                        ),
                        firstDate: DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now()
                            .add(const Duration(days: 360)), //oneYear
                        initialDate:
                            DateTime.now().add(const Duration(days: 20)),
                        autovalidateMode: AutovalidateMode.always,
                        validator: (value) {
                          if (value != null &&
                              ((value.difference(DateTime.now()).inDays + 1) <
                                  freq.checkTotalTaskDuration.value)) {
                            return " ???????? ???????? ???????????? ?????????? ???????? ???? ???????? ?????????? , ?????????? ???????? ?????????? ?????????????? ????????";
                          }
                          // else if (!(RegExp(r'^[[\u0621-\u064A\040]]+$').hasMatch(value))){
                          //   return "?????? ?????????? ?????????? ???? ???????? ??????";

                          // }
                          // else if (!RegExp(r'^[??-??]+$').hasMatch(value)) {
                          //   return "    ?? ???? ?????????? ?????? ???? ?????????? ?????? ???????? ??????";
                          // }
                          else {
                            return null;
                          }
                        },
                        onDateSelected: (DateTime value) {
                          setState(() {
                            selectedDate = value;
                            goal?.dueDate = value;

                            isDataSelected = true;

                            ///to change the duration description  ;
                            if (_checkBox == true) {
                              int durationInNumber = selectedDate
                                      .difference(DateTime.now())
                                      .inDays +
                                  1;
                              duration = durationInNumber.toString();
                              duration = "$duration ?????????? ";

                              goalDuration = durationInNumber;
                              checkGoalDuration = durationInNumber;
                              // print("h")

                            }
                            if (_ListtileCheckBox == true) {
                              int durationInNumber = selectedDate
                                      .difference(DateTime.now())
                                      .inDays +
                                  1;
                              goalDuration = durationInNumber;
                              durationInNumber = durationInNumber;

                              double numberOfWork = (durationInNumber / 7);
                              int numberOfWork2 = numberOfWork.floor();
                              int numberofDyas = durationInNumber % 7;
                              duration = "$numberOfWork2 ??????????";
                              if (numberofDyas != 0) {
                                duration = "$duration ?? $numberofDyas?????????? ";
                              }
                            }
                          }

                              // }
                              );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("????????????  :"),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 124, 121, 121))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(duration,
                                    style: const TextStyle(
                                        color: Color.fromARGB(96, 0, 0, 0))),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: CheckboxListTile(
                            checkColor:
                                const Color.fromARGB(255, 255, 250, 250),
                            activeColor: const Color(0xFF66BF77),
                            value: _checkBox,
                            onChanged: (val) {
                              setState(() {
                                _checkBox = val;
                                if (noDateChosenForThisGoal == null &&
                                    !isDataSelected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          backgroundColor:
                                              Colors.yellow.shade300,
                                          content: Row(
                                            children: const [
                                              Icon(
                                                Icons.error,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Text(
                                                    "???????? ?????????? ?????????????????? ??????????",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )
                                            ],
                                          )));
                                  _checkBox = false;
                                } else if (val == true) {
                                  int durationInNumber = selectedDate
                                          .difference(DateTime.now())
                                          .inDays +
                                      1;
                                  duration = durationInNumber.toString();
                                  duration = "$duration ?????????? ";

                                  goalDuration = durationInNumber;
                                  checkGoalDuration = durationInNumber;
                                  _ListtileCheckBox = false;
                                } else if (_ListtileCheckBox == false) {
                                  goalDuration = 0;
                                  duration =
                                      "???????????????????? ?????????????? ???????????? ?????????? ?????????????????? ???? ????????????";
                                }
                              });
                            },
                            title: const Text(" ??????????????"),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: CheckboxListTile(
                            checkColor:
                                const Color.fromARGB(255, 255, 250, 250),
                            activeColor: const Color(0xFF66BF77),
                            value: _ListtileCheckBox,
                            onChanged: (val) {
                              setState(() {
                                _ListtileCheckBox = val;
//you add is.. to the old condition
                                if (!isDataSelected) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration:
                                              const Duration(milliseconds: 500),
                                          backgroundColor:
                                              Colors.yellow.shade300,
                                          content: Row(
                                            children: const [
                                              Icon(
                                                Icons.error,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Text(
                                                    "???????? ?????????? ?????????????????? ??????????",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )
                                            ],
                                          )));
                                  _ListtileCheckBox = false;
                                } else if (val == true) {
                                  int durationInNumber = selectedDate
                                          .difference(DateTime.now())
                                          .inDays +
                                      1;
                                  goalDuration = durationInNumber;
                                  checkGoalDuration = durationInNumber;

                                  double numberOfWork = (durationInNumber / 7);
                                  int numberOfWork2 = numberOfWork.floor();
                                  int numberofDyas = durationInNumber % 7;
                                  duration = "$numberOfWork2 ??????????";
                                  if (numberofDyas != 0) {
                                    duration =
                                        "$duration ?? $numberofDyas?????????? ";
                                  }

                                  _checkBox = false;
                                } else if (_checkBox == false) {
                                  goalDuration = 0;
                                  duration =
                                      "???????????????????? ?????????????? ???????????? ?????????? ?????????????????? ???? ????????????";
                                }
                              });
                            },
                            title: const Text(" ??????????????????"),
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text("??????????????  :"),
                        const SizedBox(
                          width: 5,
                        ),
                        RatingBar.builder(
                          initialRating: widget.importance.toDouble(),
                          itemCount: 3,
                          itemPadding: const EdgeInsets.all(9),
                          itemSize: 60,
                          tapOnlyMode: false,
                          itemBuilder: (context, index) {
                            switch (index) {
                              case 0:
                                return const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Icon(Icons.circle,
                                      color: Color(0xFF66BF77)),
                                );

                              case 1:
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.circle,
                                    color: Color(0xFF66BF77),
                                    size: 100,
                                  ),
                                );
                              case 2:
                                return const Icon(
                                  Icons.circle,
                                  color: Color(0xFF66BF77),
                                  size: 10000,
                                );

                              default:
                                return const Icon(
                                  Icons.sentiment_neutral,
                                  color: Colors.amber,
                                );
                            }
                          },
                          onRatingUpdate: (rating) {
                            setState(() {
                              importance = rating.toInt();
                            });
                          },
                        )
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (isDataSelected && checkGoalDuration != 0) {
                              setState(
                                () {
                                  if (goalDuration == 0) {
                                    goalDuration = widget.goalDuration;
                                  }
                                },
                              );
                              //add condtion for when the duration is changed and it exceed the the totalof taskduration
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EditTask(
                                    id: widget.id,
                                    goalTask: goalTasks,
                                    isr: widget.isr,
                                    goalDurtion: goalDuration);
                              }));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      backgroundColor: Colors.yellow.shade300,
                                      content: Row(
                                        children: const [
                                          Icon(
                                            Icons.error,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Text(
                                                "???????????? ???????????? ?????? ?????????? ???????? ??????????",
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )
                                        ],
                                      )));
                            }
                          },
                          child: const CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            radius: 12,
                            child: Center(
                                child: Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            )),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.03,
                        ),
                        txt(txt: "?????????? ????????", fontSize: 18),
                      ],
                    ),

                    //--------------------
                  ])))

          //here the tasks .
        ],
      ),
    );
  }
}
