// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import '/entities/goal.dart';
import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
<<<<<<< Updated upstream:motazen/lib/pages/add_goal_page/add_goal_screen.dart
=======
import '../goals_habits_tab/goal_list_screen.dart';
import 'add_Task2.dart';

>>>>>>> Stashed changes:motazen/lib/add_goal_page/add_goal_screen.dart

import '../../entities/aspect.dart';

//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency
class AddGoal extends StatefulWidget {
  final List<Task> goalsTasks;
  final IsarService isr;
  final List<String>? chosenAspectNames;
  const AddGoal({super.key, required this.isr, this.chosenAspectNames,  required this.goalsTasks});

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

  String? isSelected;
  @override
  void initState() {
    importance = 0;
    super.initState();
    _goalNmaeController.addListener(_updateText);
    _dueDateController.addListener(_updateText);
<<<<<<< Updated upstream:motazen/lib/pages/add_goal_page/add_goal_screen.dart
  }
=======

  } 
>>>>>>> Stashed changes:motazen/lib/add_goal_page/add_goal_screen.dart

  void _updateText() {
    setState(() {
      _goalName = _goalNmaeController.text;
    });
  }

  _onBasicWaitingAlertPressed(context) async {
    return AlertDialog(
      title: const Text("تنبيه"),
      content: const Text("من فضلك ادخل رقم الاستحقاق أولا "),
      actions: <Widget>[
        ElevatedButton(
          child: const Text("تم"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Goal newgoal = Goal();
  String aspectnameInEnglish = "";
  _Addgoal() async {
    newgoal.titel = _goalName;
    print ("here1");
    newgoal.importance = importance;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    newgoal.aspect.value = selected;
<<<<<<< Updated upstream:motazen/lib/pages/add_goal_page/add_goal_screen.dart
    if (!isDataSelected) {
      newgoal.dueDate = DateTime.utc(1989, 11, 9);
    }
    newgoal.DescriptiveGoalDuration = duration;
    newgoal.goalDuration = goalDuration;
    widget.isr.createGoal(newgoal);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Goals_habit(iser: widget.isr);
    }));
=======
if (!isDataSelected){
newgoal.dueDate = DateTime.utc(1989, 11, 9);
}
    print ("here2");

newgoal.DescriptiveGoalDuration=duration; 
newgoal.goalDuration=goalDuration; 

  if (widget.goalsTasks !=null){
var task =[];
       task = widget.goalsTasks;
  
  if (widget.goalsTasks != null){
  for(int i = 0 ; i<widget.goalsTasks!.length ; i++){
    Task? y = Task() ; 
    String name ="";
    print ("here3");

   name = task[i].name;
   print(name);
 
     y = await widget.isr.findSepecificTask(name);
     print (y!.name);
   newgoal.task.add(y!) ;

  }
  }
  }
    widget.isr.createGoal(newgoal);
        print ("here4");

     Navigator.push(context, MaterialPageRoute(builder: (context) {
     return Goals_habit(iser: widget.isr);
   }));
  
>>>>>>> Stashed changes:motazen/lib/add_goal_page/add_goal_screen.dart
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            key: _scaffoldkey,
            appBar: AppBar(
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
                          ' هل انت متاكد من الرجوع ',
                          'بالنقر على "تاكيد"لن يتم حفظ معلومات الهدف  ');
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
            body: Stack(children: [
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
                          } else {
                            print("hi");
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
                        height: 25,
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
                        firstDate: DateTime.now().add(const Duration(days: 1)),
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
                        height: 12,
                      ),
                      Row(
                        children: [
                          const Text(
                            "الفترة  :",
                            style: TextStyle(color: Colors.black38),
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

                                  if (selectedDate == null) {
                                    _onBasicWaitingAlertPressed(context);
                                    _ListtileCheckBox = true;
                                  } else if (val == true) {
                                    int durationInNumber = selectedDate!
                                            .difference(DateTime.now())
                                            .inDays +
                                        1;
                                    goalDuration = durationInNumber;

                                    double numberOfWork =
                                        (durationInNumber / 7);
                                    int numberOfWork2 = numberOfWork.floor();
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
                              print(importance);
                            },
                          )
                        ],
                      ),
                      ElevatedButton(
                  child: const Text("مهمة إضافة"),
                  onPressed: () {
                                             Navigator.push(context, MaterialPageRoute(builder: (context) {return                     AddTask(isr: widget.isr,goalDurtion: goalDuration,goalId:1);
;}));

                    }
                      )
                    ]
                  ),
                ),
              ),
            ]),
            bottomSheet: ElevatedButton(
                child: const Text("إضافة"),
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
          )),
    );
  }
}
