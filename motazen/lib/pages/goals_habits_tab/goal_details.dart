// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import '../../entities/task.dart';
import '/entities/goal.dart';
import '/isar_service.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../entities/aspect.dart';
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
  final List<Task> goalTasks;
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
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  int goalDuration = 0;
  List<Task> goalTasks = [];
  String duration = "فضلاَ،اختر الطريقة الأمثل لحساب فترةالهدف من الأسفل";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();

  final _dueDateController = TextEditingController();
  bool isDataSelected = false;
  bool? _checkBox = false;
  bool? _ListtileCheckBox = false;

  String? isSelected;
  @override
  void initState() {
    goalTasks = widget.goalTasks;
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
    _checkBox = widget.daysisSelected;
    _ListtileCheckBox = widget.weekisSelected;
    if (!widget.dueDataDescription.contains("لايوجد تاريخ استحقاق")) {
      selectedDate = widget.temGoalDataTime;
    }

    super.initState();
    _goalNmaeController.addListener(_updateText);
    _dueDateController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {});
  }

  _onBasicWaitingAlertPressed(context) async {
    await Alert(
      context: context,
      desc: "من فضلك اختر تاريخ الاستحقاق أولا",
    ).show();
  }

  String aspectnameInEnglish = "";
  Goal? goal = Goal();
  Addgoal() async {
    goal = await widget.isr.getSepecificGoall(widget.id);
    goal?.titel = _goalNmaeController.text;
    goal?.importance = importance;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    goal?.aspect.value = selected;
    if (!isDataSelected) {
      goal?.dueDate = DateTime.utc(1989, 11, 9);
    }
    goal?.DescriptiveGoalDuration = duration;
    goal?.goalDuration;
    var task = [];
    task = widget.goalTasks;

    for (int i = 0; i < widget.goalTasks.length; i++) {
      Task? y = Task();
      String name = "";

      name = task[i].name;

      y = await widget.isr.findSepecificTask(name);
      goal!.task.add(y!);
    }
    widget.isr.UpdateGoal(goal!);
    Get.to(() => const navBar());
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: const Color(0xFF66BF77),
              title: const Text(
                "تعديل معلومات الهدف",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    // ignore: prefer_const_constructors
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.white),
                    onPressed: () async {
                      final action = await AlertDialogs.yesCancelDialog(
                          context,
                          ' هل انت متاكد من الرجوع ',
                          'بالنقر على "تاكيد"لن يتم حفظ اي تغييرات قمت بها ');
                      if (action == DialogsAction.yes) {
                        Get.to(() => const navBar());
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
                                Icons.verified_user_outlined,
                                color: Color(0xFF66BF77),
                              ),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          /// Aspect selectio

                          DropdownButtonFormField(
                            value: isSelected,
                            items: widget.chosenAspectNames
                                ?.map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              setState(() {
                                isSelected = val as String;
                                switch (isSelected) {
                                  case "أموالي":
                                    aspectnameInEnglish = "money and finances";
                                    break;
                                  case "متعتي":
                                    aspectnameInEnglish = "Fun and Recreation";
                                    break;
                                  case "مهنتي":
                                    aspectnameInEnglish = "career";
                                    break;
                                  case "علاقاتي":
                                    aspectnameInEnglish = "Significant Other";
                                    break;
                                  case "بيئتي":
                                    aspectnameInEnglish =
                                        "Physical Environment";
                                    break;
                                  case "ذاتي":
                                    aspectnameInEnglish = "Personal Growth";
                                    break;

                                  case "صحتي":
                                    aspectnameInEnglish =
                                        "Health and Wellbeing";
                                    break;
                                  case "عائلتي وأصدقائي":
                                    aspectnameInEnglish = "Family and Friends";
                                    break;
                                }
                              });
                            },
                            icon: const Icon(
                              Icons.arrow_drop_down_circle,
                              color: Color(0xFF66BF77),
                            ),
                            isDense: true,
                            validator: (value) => value == null
                                ? 'من فضلك اختر جانب الحياة المناسب للهدف'
                                : null,
                            decoration: const InputDecoration(
                              labelText: "جوانب الحياة ",
                              prefixIcon: Icon(
                                Icons.pie_chart,
                                color: Color(0xFF66BF77),
                              ),
                              border: UnderlineInputBorder(),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          //due date .
                          DateTimeFormField(
                            initialValue: selectedDate,
                            //make it with time write now there is a way for only date
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(color: Colors.black45),
                              errorStyle: TextStyle(color: Colors.redAccent),
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.event_note),
                              labelText: 'تاريخ الاستحقاق',
                            ),
                            firstDate:
                                DateTime.now().add(const Duration(days: 1)),
                            lastDate: DateTime.now()
                                .add(const Duration(days: 360)), //oneYear
                            initialDate:
                                DateTime.now().add(const Duration(days: 20)),
                            autovalidateMode: AutovalidateMode.always,
                            // validator: (DateTime? e) =>
                            //     (e?.day ?? 0) == 2 ? 'Please not the first day' : null,
                            onDateSelected: (DateTime value) {
                              selectedDate = value;
                              isDataSelected = true;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("الفترة  :"),
                              const SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                    height: 35,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 124, 121, 121))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(duration),
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
                                      if (selectedDate == null) {
                                        _onBasicWaitingAlertPressed(context);
                                        _checkBox = false;
                                      } else if (val == true) {
                                        int durationInNumber = selectedDate!
                                                .difference(DateTime.now())
                                                .inDays +
                                            1;
                                        duration = durationInNumber.toString();
                                        goalDuration = durationInNumber;
                                        _ListtileCheckBox = false;
                                      }
                                    });
                                  },
                                  title: const Text(" بالأيام"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
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

                                      if (selectedDate == null) {
                                        _onBasicWaitingAlertPressed(context);
                                        _ListtileCheckBox = false;
                                      } else if (val == true) {
                                        int durationInNumber = selectedDate!
                                                .difference(DateTime.now())
                                                .inDays +
                                            1;
                                        goalDuration = durationInNumber;

                                        double numberOfWork =
                                            (durationInNumber / 7);
                                        int numberOfWork2 =
                                            numberOfWork.floor();
                                        int numberofDyas = durationInNumber % 7;
                                        duration = "$numberOfWork2 أسبوع";
                                        if (numberofDyas != 0) {
                                          duration =
                                              "$duration و $numberofDyasيوماً ";
                                        }

                                        _checkBox = false;
                                      }
                                    });
                                  },
                                  title: const Text(" بالأسابيع"),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ],
                          ),
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
                          Row(children: [
                            SizedBox(
                                height: 40,
                                width: 112,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              const Color(0xFF66BF77)),
                                      elevation: MaterialStateProperty.all(7),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Row(
                                        children: const [
                                          Text("إضافة المهام"),
                                          Padding(
                                            padding: EdgeInsets.all(0.0),
                                            child: Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return EditTask(
                                            goalTask: goalTasks,
                                            isr: widget.isr,
                                            goalDurtion: widget.goalDuration);
                                      }));
                                    })),
                          ])
                        ])))

                //here the tasks .
              ],
            ),
            bottomSheet: ElevatedButton(
                child: const Text("حفظ التغييرات"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: const [
                        Icon(Icons.thumb_up_sharp),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text("تمت حفظ اتلغييرات"),
                        )
                      ],
                    )));

                    Addgoal();
                  }
                })));
  }
}
