// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import '/entities/habit.dart';

import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';
import '../assesment_page/alert_dialog.dart';

import '../../entities/aspect.dart';

//alertof completion //tasks // getbeck to the list page // goal dependency
class HabitDetails extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  final String HabitName;
  final String habitFrequency;
  final String habitAspect;
  final int id;

  const HabitDetails(
      {super.key,
      required this.isr,
      this.chosenAspectNames,
      required this.HabitName,
      required this.habitFrequency,
      required this.habitAspect,
      required this.id});

  @override
  State<HabitDetails> createState() => _AddHabitState();
}

class _AddHabitState extends State<HabitDetails> {
  final formKey = GlobalKey<FormState>();

  final _goalNmaeController = TextEditingController();
  final _habitFrequencyController = TextEditingController();

  String? isSelected;
  @override
  void initState() {
    super.initState();
    _goalNmaeController.text = widget.HabitName;

    _habitFrequencyController.text = widget.habitFrequency;
    for (int i = 0; i < widget.chosenAspectNames!.length; i++) {
      String name = widget.chosenAspectNames![i];
      if (name.contains(widget.habitAspect)) {
        isSelected = widget.chosenAspectNames![i];
      }
    }
  }

  String aspectnameInEnglish = "";
  Habit? habit = Habit();
  _AddHabit() async {
    habit = await widget.isr.getSepecificHabit(widget.id);

    habit?.titel = _goalNmaeController.text;
    habit?.frequency = _habitFrequencyController.text;
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    habit?.aspect.value = selected;

    widget.isr.UpdateHabit(habit!);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Goals_habit(iser: widget.isr);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return MaterialApp(
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF66BF77),
              title: const Text(
                "تعديل معلومات العادة",
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
                          'بالنقر على "تاكيد"لن يتم حفظ التغييرات التي قمت بها');
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
                  child: ListView(children: [
                    TextFormField(
                      controller: _goalNmaeController,
                      //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "من فضلك ادخل اسم العادة";
                        } else {
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
                          ? 'من فضلك اختر جانب الحياة المناسب للعادة'
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
                    //Frequency .
                    TextFormField(
                      controller: _habitFrequencyController,
                      //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "من فضلك ادخل عدد مرات تكرار العادة";
                        } else {
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
                  ]),
                ),
              ),
            ]),
            bottomSheet: ElevatedButton(
                child: const Text("تعديل"),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: const [
                        Icon(Icons.thumb_up_sharp),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text("تم حفظ التغييرات بنجاح "),
                        )
                      ],
                    )));

                    _AddHabit();
                  }
                }),
          )),
    );
  }
}
