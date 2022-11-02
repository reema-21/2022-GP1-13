import 'package:flutter/material.dart';
import 'package:motazen/add_goal_page/get_chosen_aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/entities/habit.dart';
import 'package:motazen/goals_habits_tab/getchosenAspect_editing.dart';
import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/goals_habits_tab/goal_list_screen.dart';
import 'package:motazen/isar_service.dart';

import 'package:intl/intl.dart' as intl;

import 'getChosenAspectEh.dart';

//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency
class EditHbit extends StatefulWidget {
  final IsarService isr;
  final int HabitId;
  const EditHbit({super.key, required this.isr, required this.HabitId});

  @override
  State<EditHbit> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditHbit> {
  TextEditingController displayHabitNameControlller = TextEditingController();
    TextEditingController displayHabitfrequencyControlller = TextEditingController();

  String habitAspect = ""; //for the dropMenu A must
  String frequency = ""; //for the importance if any
 
  Habit? habit ;
  bool isLoading = false;
 

  @override
  void initState() {
    super.initState();
    getHabitInformation();
    // might be deleted .
  }

  getHabitInformation() async {
   
    habit = await widget.isr.getSepecificHabit(widget.HabitId);

    setState(() {
      displayHabitNameControlller.text = habit!.titel;
      displayHabitfrequencyControlller.text = habit!.frequency;

      print(displayHabitNameControlller.text);
      habitAspect = habit!.aspect.value!.name;
      switch (habitAspect) {
        case "money and finances":
          habitAspect = "أموالي";
          break;
        case "Fun and Recreation":
          habitAspect = "متعتي";
          break;
        case "career":
          habitAspect = "مهنتي";
          break;
        case "Significant Other":
          habitAspect = "علاقاتي";
          break;
        case "Physical Environment":
          habitAspect = "بيئتي";
          break;
        case "Personal Growth":
          habitAspect = "ذاتي";
          break;

        case "Health and Wellbeing":
          habitAspect = "صحتي";
          break;
        case "Family and Friends":
          habitAspect = "عائلتي وأصدقائي";
          break;
      }});}
    
  

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: const Color(0xFF66BF77),
                  title: const Text(
                    "معلومات العادة",
                    style: TextStyle(color: Colors.white),
                  ),
                  actions: [
                    IconButton(
                        // ignore: prefer_const_constructors
                        icon:
                            Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Goals_habit(iser: widget.isr);
                          }));
                        })
                  ],
                ),
                body: Stack(children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "اسم العادة:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                displayHabitNameControlller.text,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Container(
                              child: Text(
                                "جانب الحياة:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                habitAspect,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                         Container(
                              child: Text(
                                "عدد مرات تكرار العادة العادة:",
                                style: TextStyle(fontSize: 23),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Text(
                                displayHabitfrequencyControlller.text,
                                style: TextStyle(
                                    fontSize: 22, color: Colors.black54),
                              ),
                            )
                          ],
                        ),
                  ),
                ]
                ),
                bottomSheet: TextButton(
                    child: const Text("تعديل"),
                    onPressed: () {
                     
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return   getChosenAspectEh(
                        isr: widget.isr,
                        
                        habitAspect: habitAspect,
                        habitFrequency: displayHabitfrequencyControlller.text,
                        HabitName: displayHabitNameControlller.text,
                    
                        id :widget.HabitId,
                      ); ; // must be the
                    }));
                    
                    }))));
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
