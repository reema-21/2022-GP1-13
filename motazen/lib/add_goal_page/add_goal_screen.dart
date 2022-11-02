import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/isar_service.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import"add_task.dart";

import '../entities/aspect.dart';
import '../entities/task.dart';
//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency 
class AddGoal extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  const AddGoal({super.key, required this.isr, this.chosenAspectNames});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  final formKey = GlobalKey<FormState>();
  late String _goalName;
  DateTime? selectedDate;
int goalDuration= 0 ; 
  String duration = "فضلاَ،اختر الطريقة الأمثل لحساب فترةالهدف من الأسفل";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _dueDateController = TextEditingController();
  bool isDataSelected = false;
  bool? _checkBox = false;
  bool? _ListtileCheckBox = false;

  String? isSelected ;
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

  _onBasicWaitingAlertPressed(context) async {
    return AlertDialog(
      title: new Text("تنبيه"),
      content: new Text("من فضلك ادخل رقم الاستحقاق أولا "),
      actions: <Widget>[
        new ElevatedButton(
          child: new Text("تم"),
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
    newgoal.importance = importance;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    newgoal.aspect.value = selected;
if (!isDataSelected){
newgoal.dueDate = DateTime.utc(1989, 11, 9);
}
newgoal.DescriptiveGoalDuration=duration; 
newgoal.goalDuration=goalDuration; 
    widget.isr.createGoal(newgoal);
     Navigator.push(context, MaterialPageRoute(builder: (context) {
     return Goals_habit(iser: widget.isr);
   }));
  
  }

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
                         Navigator.push(context, MaterialPageRoute(builder: (context) {return Goals_habit(iser: widget.isr,);}));
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
                          if (value == null || value.isEmpty)
                            return "من فضلك ادخل اسم الهدف";
                          // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                          //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                          // } 
                          else {
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
                      SizedBox(
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
                          color: const Color(0xFF66BF77),
                        ),
                        validator: (value) => value == null
                            ? 'من فضلك اختر جانب الحياة المناسب للهدف'
                            : null,
                        decoration: InputDecoration(
                          labelText: "جوانب الحياة ",
                          prefixIcon: Icon(
                            Icons.pie_chart,
                            color: const Color(0xFF66BF77),
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      SizedBox(
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
                      SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Text("الفترة  :",style: TextStyle(color: Colors.black38),),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                                height: 35,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(duration),
                                ),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 124, 121, 121)))),
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
                              checkColor: Color.fromARGB(255, 255, 250, 250),
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
                                    goalDuration=durationInNumber;
                                    _ListtileCheckBox = false;
                                  }
                                });
                              },
                              title: Text(" بالأيام"),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 150,
                            child: CheckboxListTile(
                              checkColor: Color.fromARGB(255, 255, 250, 250),
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
                                    goalDuration=durationInNumber;

                                    double numberOfWork =
                                        (durationInNumber / 7);
                                    int numberOfWork2 = numberOfWork.floor();
                                    int numberofDyas = durationInNumber % 7;
                                    duration =
                                        numberOfWork2.toString() + " أسبوع";
                                    if (numberofDyas != 0) {
                                      duration = duration +
                                          " و " +
                                          numberofDyas.toString() +
                                          "يوماً ";
                                    }

                                    _checkBox = false;
                                  }
                                });
                              },
                              title: Text(" بالأسابيع"),
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text("الأهمية  :"),
                          SizedBox(
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

                                  break;
                                case 1:
                                  return const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.circle,
                                      color: Color(0xFF66BF77),
                                      size: 100,
                                    ),
                                  );
                                  break;
                                case 2:
                                  return Icon(
                                    Icons.circle,
                                    color: const Color(0xFF66BF77),
                                    size: 10000,
                                  );

                                  break;
                                default:
                                  return Icon(
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
                      //here the tasks .
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green.shade50,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(context, TaskScreen.route());
                              },
                              icon: const Icon(Icons.add),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "إضافة مهمة",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      StreamBuilder<List<Task>>(
                        stream: widget.isr.listenTasks(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text("حصل خطأ");
                          }
                          if (snapshot.hasData && snapshot.data!.isEmpty) {
                            return const Text("ليس لديك مهام");
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text("جاري التحميل");
                          }
                          return Expanded(
                            child: ListView.separated(
                              itemCount: snapshot.data!.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 6),
                              itemBuilder: (context, index) {
                                final task =
                                    snapshot.data!.reversed.elementAt(index);
                                return Container(
                                  padding: EdgeInsets.fromLTRB(0, 6, 24, 12),
                                  width: double.infinity,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.lightBlue.shade50,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(task.taskImportance!),
                                      Text(
                                        task.name!,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
            bottomSheet:
               ElevatedButton(
                  child: const Text("إضافة"),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {

ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Row(children: [Icon(Icons.thumb_up_sharp),SizedBox(width: 20),Expanded(child: Text("تمت اضافة الهدف "),)],))
);

                      _Addgoal();
                    }
                  }),
            )),
      );
  }
}
