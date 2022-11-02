import 'package:flutter/material.dart';
import 'package:motazen/entities/habit.dart';

import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/isar_service.dart';
import '../assesment_page/alert_dialog.dart';

import 'package:rflutter_alert/rflutter_alert.dart';


import '../entities/aspect.dart';
import '../entities/task.dart';
//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency 
class AddHabit extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  const AddHabit({super.key, required this.isr, this.chosenAspectNames});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final formKey = GlobalKey<FormState>();
  late String _habitName;
  late String _habitFrequecy;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _habitFrequencyController = TextEditingController();


  String? isSelected ;
  @override
  void initState() {
    super.initState();
    _goalNmaeController.addListener(_updateText);
    _habitFrequencyController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _habitName = _goalNmaeController.text;
      _habitFrequecy=_habitFrequencyController.text;
    });
  }


  Habit newhabit = Habit();
  String aspectnameInEnglish = "";
  _AddHabit() async {
    newhabit.titel = _habitName;
    newhabit.frequency = _habitFrequecy;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    newhabit.aspect.value = selected;

    widget.isr.createHabit(newhabit);
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
                "إضافة عادة جديدة",
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
                          'بالنقر على "تاكيد"لن يتم حفظ معلومات العادة  ');
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
                            return "من فضلك ادخل اسم العادة";
                          // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                          //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                          // } 
                          else {
                            print("hi");
                            return null;
                          }
                        },

                        decoration: const InputDecoration(
                          labelText: "اسم العادة",
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
                            ? 'من فضلك اختر جانب الحياة المناسب للعادة'
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
                      //Frequency .
                      TextFormField(
                        controller: _habitFrequencyController,
                        //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "من فضلك ادخل عدد مرات تكرار العادة";
                          // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                          //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                          // } 
                          else {
                            print("hi");
                            return null;
                          }
                        },

                        decoration: const InputDecoration(
                          labelText: "عدد مرات تكرار العادة",
                          prefixIcon: Icon(
                            Icons.verified_user_outlined,
                            color: Color(0xFF66BF77),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                     
                    
                    ]
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

 _AddHabit();                    }
                  }),
            )),
      );
  }
}
