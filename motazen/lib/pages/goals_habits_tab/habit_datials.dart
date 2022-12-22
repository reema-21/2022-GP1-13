// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously,

import 'package:flutter/material.dart';
import 'package:motazen/isarService.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import '../../data/data.dart';
import '../add_habit_page/editMy_controller.dart';
import '/entities/habit.dart';

import '../assesment_page/alert_dialog.dart';
import 'package:get/get.dart';
import '../../entities/aspect.dart';

//alertof completion //tasks // getbeck to the list page // goal dependency
class HabitDetails extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  final String HabitName;
  final String habitFrequency;
  final String habitAspect;
  final int durationInInt;
  final int duraioninString;
  final int id;

  const HabitDetails({
    super.key,
    required this.isr,
    this.chosenAspectNames,
    required this.HabitName,
    required this.habitFrequency,
    required this.habitAspect,
    required this.durationInInt,
    required this.duraioninString,
    required this.id,
  });

  @override
  State<HabitDetails> createState() => _AddHabitState();
}

class _AddHabitState extends State<HabitDetails> {
  final formKey2 = GlobalKey<FormState>();
  late int durationIndString;
  late int durationInInt;
  final _goalNmaeController = TextEditingController();
  final EditMyControleer freq = Get.put(EditMyControleer());
  final List<String> durations = ['اليوم', 'الأسبوع', 'الشهر', 'السنة'];
  String? isDuration;
  int durationIndexString = 0;

  String duratioSelected = "";

  String? isSelected;
  @override
  void initState() {
    super.initState();
    _goalNmaeController.text = widget.HabitName;
    freq.setvalue(widget.durationInInt);
    isDuration = durations[widget.duraioninString];
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

    habit?.durationIndString = durationIndexString;
    habit?.durationInNumber = freq.frequency.toInt();
    duratioSelected = freq.frequency.string + duratioSelected;
    habit?.frequency = duratioSelected;

    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    habit?.aspect.value = selected;

    widget.isr.UpdateHabit(habit!);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const navBar(
        selectedIndex: 1,
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
                        return const navBar(
                          selectedIndex: 1,
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
                key: formKey2,
                child: ListView(children: [
                  TextFormField(
                    controller: _goalNmaeController,
                    //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "من فضلك ادخل اسم العادة";
                      } else {
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
                  DropdownButtonFormField(
                    value: isSelected,
                    items: aspectList.selectedArabic
                        .map((e) => DropdownMenuItem(
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

                  Row(
                    children: [
                      const Text("عدد مرات التكرار"),
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF66BF77),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 15,
                            ),
                            onPressed: () {
                              freq.increment();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx((() => Text(
                            freq.frequency.toString(),
                            style: const TextStyle(fontSize: 20),
                          ))),
                      const SizedBox(width: 10),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF66BF77),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove,
                              color: Colors.white, size: 15),
                          onPressed: () {
                            freq.dcrement();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  DropdownButtonFormField(
                    value: isDuration,
                    items: durations
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        isDuration = val as String;
                        switch (isDuration) {
                          case "اليوم":
                            duratioSelected = " مرات في اليوم ";
                            durationIndexString = 0;
                            break;
                          case "الأسبوع":
                            duratioSelected = " مرات في الأسبوع ";
                            durationIndexString = 1;
                            break;
                          case "الشهر":
                            duratioSelected = " مرات في الشهر ";
                            durationIndexString = 2;
                            break;
                          case "السنة":
                            duratioSelected = " مرات في السنة  ";
                            durationIndexString = 3;
                            break;
                        }
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Color(0xFF66BF77),
                    ),
                    validator: (value) =>
                        value == null ? 'من فضلك معدل التكرار' : null,
                    decoration: const InputDecoration(
                      labelText: "خلال ",
                      prefixIcon: Icon(
                        Icons.av_timer_outlined,
                        color: Color(0xFF66BF77),
                      ),
                      border: UnderlineInputBorder(),
                    ),
                  ),

                  //frequency.
                ]),
              ),
            ),
          ]),
          bottomSheet: ElevatedButton(
              child: const Text("تعديل"),
              onPressed: () {
                if (formKey2.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Row(
                    children: const [
                      Icon(
                        Icons.thumb_up_sharp,
                        color: kWhiteColor,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text("تم حفظ التغييرات بنجاح "),
                      )
                    ],
                  )));

                  _AddHabit();
                }
              }),
        ));
  }
}
