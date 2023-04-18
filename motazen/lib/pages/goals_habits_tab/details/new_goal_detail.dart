import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/pages/goals_habits_tab/edit/edit_goal.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../entities/goal.dart';
import '../../../isar_service.dart';
import '../../../theme.dart';

class GoalDetailPage extends StatefulWidget {
  final IsarService isr;
  final int goalId;
  const GoalDetailPage({super.key, required this.isr, required this.goalId});

  @override
  State<GoalDetailPage> createState() => _GoalDetailPageState();
}

bool tasksOpened = false;
GlobalKey _taskShowCase = GlobalKey();

class _GoalDetailPageState extends State<GoalDetailPage> {
  TextEditingController displayGoalNameControlller = TextEditingController();
  String goalAspect = ""; //for the dropMenu A must
  int importance = 0; //for the importance if any
  int goalDuration = 0;
  String goalDurationDescription = "-";
  String goalImportanceDescription = "-";
  late DateTime endDate;
  late DateTime startDate;
  String dueDataDescription = "";
  List<LocalTask> goalTasks = [];
  late Image goalImage;
  Goal? goal;
  bool firstTime = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGoalInformation();
    // might be deleted .
  }

  showTheShowCase() async {
    if (goalTasks.isNotEmpty) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      firstTime = prefs.getBool('showShowCase') ?? true;
      setState(() {});
      if (tasksOpened && firstTime) {
        WidgetsBinding.instance.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context).startShowCase([_taskShowCase]));
        await prefs.setBool('showShowCase', false);
      }
    }
  }

  getGoalInformation() async {
    goal = await widget.isr.getSepecificGoall(widget.goalId);
    endDate = goal!.endDate;
    startDate = goal!.startData;
    setState(() {
      displayGoalNameControlller.text = goal!.titel;
      goalAspect = goal!.aspect.value!.name;

      switch (goalAspect) {
        case "أموالي":
          goalAspect = "أموالي";
          goalImage = Image.asset('assets/images/money.png');
          break;
        case "متعتي":
          goalAspect = "متعتي";
          goalImage = Image.asset('assets/images/fun.png');
          break;
        case "مهنتي":
          goalAspect = "مهنتي";
          goalImage = Image.asset('assets/images/career.png');
          break;
        case "علاقاتي":
          goalAspect = "علاقاتي";
          goalImage = Image.asset('assets/images/Relationships.png');
          break;
        case "بيئتي":
          goalAspect = "بيئتي";
          goalImage = Image.asset('assets/images/Enviroment.png');
          break;
        case "ذاتي":
          goalAspect = "ذاتي";
          goalImage = Image.asset('assets/images/personal.png');
          break;

        case "صحتي":
          goalAspect = "صحتي";
          goalImage = Image.asset('assets/images/health.png');
          break;
        case "عائلتي واصدقائي":
          goalAspect = "عائلتي واصدقائي";
          goalImage = Image.asset('assets/images/familyfriends.png');
          break;
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
        goalDurationDescription = goal!.descriptiveGoalDuration;
      }
      goalTasks = goal!.task.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text('معلومات الهدف'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditGoal(
              endDate: endDate,
              startDate: startDate,
              isr: widget.isr,
              selected: aspectList.selected,
              goalName: displayGoalNameControlller.text,
              goalAspect: goalAspect,
              importance: importance,
              goalDuration: goalDuration,
              goalDurationDescription: goalDurationDescription,
              goalImportanceDescription: goalImportanceDescription,
              dueDataDescription: dueDataDescription,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayGoalNameControlller.text,
                style: const TextStyle(fontSize: 30),
              ),
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                    child: goalImage),
              ),
              const SizedBox(height: 25),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 45,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(blurRadius: 2.0)],
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(68, 102, 191, 119),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text(
                                          'تاريخ البدء: ',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.green),
                                        ),
                                        Text(
                                          intl.DateFormat.yMMMEd()
                                              .format(startDate),
                                          style: const TextStyle(
                                              fontSize: 19,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          ' تاريخ الإستحقاق: ',
                                          style: TextStyle(
                                              fontSize: 19, color: Colors.red),
                                        ),
                                        Text(
                                          intl.DateFormat.yMMMEd()
                                              .format(endDate),
                                          style: const TextStyle(
                                              fontSize: 19, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          'الفترة المتاحة: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black54),
                                        ),
                                        Text(
                                          goalDurationDescription,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.calendar_month,
                                  size: 50,
                                  color: Color(0x4D000000),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   '',
                                  //   style: TextStyle(
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'الأهمية: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF66BF77),
                                        ),
                                      ),
                                      Text(
                                        goalImportanceDescription,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'جانب الحياة: ',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF66BF77),
                                        ),
                                      ),
                                      Text(
                                        goalAspect,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 61,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CircularPercentIndicator(
                                          radius: 70,
                                          lineWidth: 15,
                                          circularStrokeCap:
                                              CircularStrokeCap.round,
                                          percent: goal!.goalProgressPercentage,
                                          animation: true,
                                          animationDuration: 600,
                                          progressColor: kPrimaryColor,
                                          backgroundColor:
                                              kPrimaryColor.withOpacity(0.3),
                                          center: Text(
                                            '${(goal!.goalProgressPercentage * 100).round().toString()}%',
                                            style: titleText,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 45,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(blurRadius: 2.0)],
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tasksOpened = !tasksOpened;
                            });
                            showTheShowCase();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(68, 102, 191, 119),
                                borderRadius: tasksOpened
                                    ? const BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        topLeft: Radius.circular(20))
                                    : BorderRadius.circular(20.0)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                textDirection: TextDirection.rtl,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: const [
                                      Text(
                                        'المهام المرتبطة: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    tasksOpened
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    size: 40,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (tasksOpened)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: goalTasks.isNotEmpty
                                  ? getAllTasks()
                                  : [
                                      const Center(
                                          child: Text('لا توجد مهام حاليًا'))
                                    ],
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  getAllTasks() {
    List<Widget> listOfTasks = [];
    for (int i = 0; i < goalTasks.length; i++) {
      if (i == 0) {
        listOfTasks.add(Showcase(
          key: _taskShowCase,
          description: "أضغط هنا لاستعراض المهام",
          child: GestureDetector(
            onTap: () {
              dialogBox(context, goalTasks[i]);
            },
            child: Center(
                child: Text(
              goalTasks[i].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
          ),
        ));
      } else {
        listOfTasks.add(GestureDetector(
          onTap: () {
            dialogBox(context, goalTasks[i]);
          },
          child: Center(
              child: Text(
            goalTasks[i].name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
        ));
      }
    }
    return listOfTasks;
  }

  dynamic dialogBox(BuildContext context, final goal) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(
            "مهام الهدف",
            textAlign: TextAlign.right,
            style: titleText2,
          ),
          content: buildView(context, goal),
        );
      },
    );
  }

  Widget buildView(BuildContext context, final goal) {
    return SizedBox(
      width: double.maxFinite,
      height: 100,
      child: Card(
        // here is the code of each item you have
        child: Column(
          children: [
            ListTile(
              leading: const Icon(
                Icons.task,
                color: Color(0xFF66BF77),
              ),
              title: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  goal.name,
                  style: subTitle,
                ),
              ),
            ),
            LinearPercentIndicator(
              isRTL: true,
              animation: true,
              animationDuration: 600,
              curve: Curves.easeIn,

              ///check later why the value isn't updated بكودها
              percent: goal.taskCompletionPercentage >= .99
                  ? goal.taskCompletionPercentage
                  : 0.01 + goal.taskCompletionPercentage,
              lineHeight: 7,
              progressColor: kPrimaryColor,
              backgroundColor: kPrimaryColor.withOpacity(0.3),
              barRadius: const Radius.circular(10),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
