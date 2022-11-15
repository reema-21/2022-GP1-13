// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import '../../entities/aspect.dart';
import '../../entities/task.dart';
import '../assesment_page/alert_dialog.dart';
import '../goals_habits_tab/goal_habits_pages.dart';
import 'add_Task2.dart';

class AddGoal extends StatefulWidget {
  List<Task> goalsTasks = [];
  final IsarService isr;
  final List<String>? chosenAspectNames;
  AddGoal(
      {super.key,
      required this.isr,
      this.chosenAspectNames,
      required this.goalsTasks});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  final formKey = GlobalKey<FormState>();
  late String _goalName;
  DateTime? selectedDate;
  int goalDuration = 0;
  String duration = "فضلاَ،اختر الطريقة الأمثل لحساب فترةالهدف من الأسفل";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _dueDateController = TextEditingController();
  bool isDataSelected = false;
  bool? _checkBox = false;
  bool? _ListtileCheckBox = false;
  final TaskControleer freq = Get.put(TaskControleer());

  String? isSelected;
  @override
  void initState() {
    importance = 0;
    super.initState();
    _goalNmaeController.addListener(_updateText);
    _dueDateController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _goalName = _goalNmaeController.text;
    });
  }

  Goal newgoal = Goal();
  String aspectnameInEnglish = "";
  _Addgoal() async {
    newgoal.titel = _goalName;
    newgoal.importance = importance;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    newgoal.aspect.value = selected;
    if (!isDataSelected) {
      newgoal.dueDate = DateTime.utc(1989, 11, 9);
    }

    newgoal.DescriptiveGoalDuration = duration;
    newgoal.goalDuration = goalDuration;
    widget.goalsTasks = freq.goalTask.value;
    var task = [];
    task = freq.goalTask.value;

    for (int i = 0; i < freq.goalTask.value.length; i++) {
      Task? y = Task();
      String name = "";

      name = task[i].name;

      y = await widget.isr.findSepecificTask(name);
      newgoal.task.add(y!);
    }
    widget.isr.createGoal(newgoal);
    //
//
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Goals_habit(iser: widget.isr);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                    children: const [
                      Icon(Icons.thumb_up_sharp),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text("تمت اضافة الهدف "),
                      )
                    ],
                  )));

                  _Addgoal();
                }
              }),
          key: _scaffoldkey,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF66BF77),
            title: const Text(
              "إضافة هدف جديد",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  onPressed: () async {
                    final action = await AlertDialogs.yesCancelDialog(
                        context,
                        ' هل انت متاكد من الرجوع للخلف',
                        'بالنقر على "تأكيد" لن يتم حفظ معلومات الهدف  ');
                    if (action == DialogsAction.yes) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Goals_habit(
                          iser: widget.isr,
                        );
                      }));
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
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _goalNmaeController,
                          //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "من فضلك ادخل اسم الهدف";
                            }
                            // else if (!(RegExp(r'^[[\u0621-\u064A\040]]+$').hasMatch(value))){
                            //   return "اسم الهدف يحتوي عى حروف فقط";

                            // }
                            // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                            //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                            // }
                            else {
                              return null;
                            }
                          },

                          decoration: const InputDecoration(
                            labelText: "اسم الهدف",
                            prefixIcon: Icon(
                              Icons.task,
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
                                  aspectnameInEnglish = "Physical Environment";
                                  break;
                                case "ذاتي":
                                  aspectnameInEnglish = "Personal Growth";
                                  break;

                                case "صحتي":
                                  aspectnameInEnglish = "Health and Wellbeing";
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
                          height: 30,
                        ),
                        //due date .
                        DateTimeFormField(
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
                            newgoal.dueDate = value;
                            isDataSelected = true;
                          },
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Text(
                              "الفترة  :",
                            ),
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
                                    child: Text(duration,
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(96, 0, 0, 0))),
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
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: CheckboxListTile(
                                  checkColor:
                                      const Color.fromARGB(255, 255, 250, 250),
                                  activeColor: const Color(0xFF66BF77),
                                  value: _checkBox,
                                  onChanged: (val) {
                                    setState(() {
                                      _checkBox = val;
                                      if (selectedDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration:
                                                    const Duration(seconds: 1),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 196, 48, 37),
                                                content: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.error,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      child: Text(
                                                          "أدخل تاريخ الاستحقاق أولًا"),
                                                    )
                                                  ],
                                                )));
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
                                  title: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Text(" بالأيام"),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 0),
                                child: CheckboxListTile(
                                  checkColor:
                                      const Color.fromARGB(255, 255, 250, 250),
                                  activeColor: const Color(0xFF66BF77),
                                  value: _ListtileCheckBox,
                                  onChanged: (val) {
                                    setState(() {
                                      _ListtileCheckBox = val;

                                      if (selectedDate == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 196, 48, 37),
                                                content: Row(
                                                  children: const [
                                                    Icon(Icons.error,
                                                        color: Colors.white),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      child: Text(
                                                          "أدخل تاريخ الاستحقاق"),
                                                    )
                                                  ],
                                                )));
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
                              initialRating: 0,
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
                        const SizedBox(
                          height: 30,
                        ),
                        Row(children: [
                          SizedBox(
                              height: 40,
                              width: 112,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        const Color(0xFF66BF77)),
                                    elevation: MaterialStateProperty.all(7),
                                  ),
                                  onPressed: isDataSelected
                                      ? () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddTask(
                                                goalTask: widget.goalsTasks,
                                                isr: widget.isr,
                                                goalDurtion: goalDuration);
                                          }));
                                        }
                                      : () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Row(
                                            children: const [
                                              Icon(Icons.warning),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Text(
                                                    "لإضافة المهام يجب تحديد فترة الهدف أولا"),
                                              )
                                            ],
                                          )));
                                        },
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
                                  )))
                        ]),
                      ],
                    )),
              ),
            ],
          )),
    );
  }
}
