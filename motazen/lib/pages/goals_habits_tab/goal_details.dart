// ignore_for_file: camel_case_types, non_constant_identifier_names, unused_field, unused_local_variable, must_call_super
//new
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
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../entities/aspect.dart';
import 'Edit_task.dart';

//alertof completion //tasks // getbeck to the list page // goal dependency
class goalDetails extends StatefulWidget {
  final IsarService isr;
  final String goalName;
  final String goalAspect;
  final int importance; //for the importance if any
  final int goalDuration;
  final String goalDurationDescription;
  final String goalImportanceDescription;
  final DateTime endDate;
  final DateTime startDate;
  final List<Aspect> selected;
  final String dueDataDescription;
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
    required this.dueDataDescription,
    required this.endDate,
    required this.startDate,
    required this.id,
    required this.goalTasks,
    required this.selected,
  });

  @override
  State<goalDetails> createState() => _goalDetailsState();
}

class _goalDetailsState extends State<goalDetails> {
  Future<List<LocalTask>> getTasks() async {
    Goal? goal = Goal(userID: IsarService.getUserID);
    goal = await widget.isr.getSepecificGoall(widget.id);
    return goal!.task.toList();
  }

  final TaskLocalControleer freq = Get.put(TaskLocalControleer());

  final formKey = GlobalKey<FormState>();
  int goalDuration = 0;
  List<LocalTask> goalTasks = [];
  List<LocalTask> oldgoalTasks = [];
  int checkGoalDuration = 0;

  DateTimeRange? selectedDates;

  String duration = "لا يوجد فترة";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _goalaspectController = TextEditingController();
  final _dueDateController = TextEditingController();
  String? isSelected;

  @override
  void initState() {
    goalDuration = widget.goalDuration;
    int sum = 0;
    goalTasks = widget.goalTasks;
    for (int i = 0; i < goalTasks.length; i++) {
      sum = sum + goalTasks[i].duration;
      LocalTask x = LocalTask(userID: IsarService.getUserID);
      x.name = goalTasks[i].name;
      x.duration = goalTasks[i].duration;
      x.durationDescribtion = goalTasks[i].durationDescribtion;
      oldgoalTasks.add(x);
    }
    freq.checkTotalTaskDuration.value = sum;
    checkGoalDuration = widget.goalDuration;
    _goalNmaeController.text = widget.goalName;
    importance = widget.importance;
    for (int i = 0; i < widget.selected.length; i++) {
      String name = widget.selected[i].name;
      if (name.contains(widget.goalAspect)) {
        isSelected = widget.selected[i].name;
      }
    }
    _goalaspectController.text = isSelected!;

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

  Goal? goal = Goal(userID: IsarService.getUserID);

  Addgoal() async {
    goal = await widget.isr.getSepecificGoall(widget.id);
    goal?.titel = _goalNmaeController.text;
    goal?.importance = importance;
    Aspect? selected = await widget.isr.findSepecificAspect(isSelected!);
    goal?.aspect.value = selected;
    selected!.goals.add(goal!);
    widget.isr.createAspect(selected);
    goal?.DescriptiveGoalDuration = duration;
    goal?.goalDuration = goalDuration;

    var task = [];
    task = widget.goalTasks;

    for (int i = 0; i < widget.goalTasks.length; i++) {
      LocalTask? y = LocalTask(userID: IsarService.getUserID);
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

    if (selectedDates != null) {
      goal!.endDate = selectedDates!.end;
      goal!.startData = selectedDates!.start;
    } else {
      goal!.endDate = goal!.endDate;
      goal!.startData = goal!.startData;
    }
    widget.isr.UpdateGoal(goal!);
    freq.TaskDuration = 0.obs;
    freq.currentTaskDuration = 0.obs;
    freq.totalTasksDuration = 0.obs;
    freq.iscool = false.obs;
    freq.tem = 0.obs;
    freq.isSelected = "أيام".obs;
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
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
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
                        child: Text("تمت تعديل الهدف "),
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
            "تعديل معلومات الهدف",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      ' هل انت متاكد من الرجوع ',
                      'بالنقر على "تأكيد"لن يتم حفظ أي تغييرات قمت بها ');
                  if (action == DialogsAction.yes) {
                    // here is should make sure to fetch the tasks to take itis depenency before saving it
                    List<LocalTask> g = [];
                    Goal? goal = Goal(userID: IsarService.getUserID);
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
                        LocalTask? y = LocalTask(userID: IsarService.getUserID);
                        String name = item;

                        y = await widget.isr.findSepecificTask(name);
                        oldgoalTasks[i]
                            .TaskDependency
                            .add(y!); // to link task and it depends tasks ;
                      });

                      widget.isr.saveTask(oldgoalTasks[i]);
                      Goal? goal = Goal(userID: IsarService.getUserID);
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
                    freq.isSelected = "أيام".obs;
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
                            return "من فضلك ادخل اسم الهدف";
                          } else {
                            return null;
                          }
                        },

                        decoration: const InputDecoration(
                          labelText: "اسم الهدف",
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
                                    child: Text(
                                        "لا يمكن تغيير جانب حياة الهدف ",
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
                            labelText: "جانب الحياة ",
                            prefixIcon: Icon(
                              Icons.verified_user_outlined,
                              color: Color.fromARGB(255, 164, 175, 166),
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      //due date .
                      durationWidget(context),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text("الأهمية  :"),
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
                              if (goalDuration != 0) {
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
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            SizedBox(width: 20),
                                            Expanded(
                                              child: Text(
                                                  "لإضافة المهام يجب تحديد فترة الهدف",
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
                          txt(txt: "إضافة مهام", fontSize: 18),
                        ],
                      ),

                      //--------------------
                    ])))

            //here the tasks .
          ],
        ));
  }

  Container durationWidget(BuildContext context) {
    return Container(
        height: screenHeight(context) * 0.07,
        width: screenWidth(context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () async {
                    DateTimeRange? newDate = await showDateRangePicker(
                      initialDateRange: selectedDates ??
                          DateTimeRange(
                              start: widget.startDate, end: widget.endDate),
// make here the goal selectd in datails '
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 0)),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: Colors.white,
                              onSurface: kPrimaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      if (newDate != null) {
                        if (newDate.duration.inDays <
                            freq.checkTotalTaskDuration.value) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(milliseconds: 1000),
                              backgroundColor:
                                  const Color.fromARGB(255, 243, 9, 9),
                              content: Row(
                                children: const [
                                  Icon(
                                    Icons.error,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Text(
                                        "فترة الهدف ستصبح أقل من فترة المهام المدخلة",
                                        style: TextStyle(color: Colors.black)),
                                  )
                                ],
                              )));
                        } else {
                          goalDuration = newDate.duration.inDays;
                          duration = '${goalDuration.toString()} يوما';
                          selectedDates = newDate;
                        }
                      }
                    });
                  },
                  child: const Icon(
                    Icons.calendar_month,
                    color: kPrimaryColor,
                  )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  txt(txt: '${goalDuration.toString()} يوما', fontSize: 16),
                ],
              )),
            ],
          ),
        ));
  }
}
