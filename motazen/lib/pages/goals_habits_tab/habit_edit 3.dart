// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../data/data.dart';
import '/entities/habit.dart';
import 'habit_datials.dart';

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
  TextEditingController displayHabitfrequencyControlller =
      TextEditingController();

  String habitAspect = ""; //for the dropMenu A must
  String frequency = ""; //for the importance if any
  int durationInNumber = 0;
  int durationIndex = 0;
  Habit? habit;
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
      durationIndex = habit!.durationIndString;
      durationInNumber = habit!.durationInNumber;
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
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "معلومات العادة",
            style: titleText,
          ),
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: kBlackColor),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return HabitDetails(
                  isr: widget.isr,
                  chosenAspectNames: aspectList.selectedArabic,
                  HabitName: displayHabitNameControlller.text,
                  habitFrequency: displayHabitfrequencyControlller.text,
                  habitAspect: habitAspect,
                  id: widget.HabitId,
                  duraioninString: durationIndex,
                  durationInInt: durationInNumber,
                ); // must be the
              }));
            });
          },
          backgroundColor: const Color.fromARGB(255, 252, 252, 252),
          child: const Icon(
            Icons.edit,
            color: Color(0xFF66BF77),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(children: [
          Expanded(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: ListView(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        const Text(
                          "اسم العادة: ",
                          style: TextStyle(fontSize: 23),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          displayHabitNameControlller.text,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.black54),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          "جانب الحياة:",
                          style: TextStyle(fontSize: 23),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          habitAspect,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.black54),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Text(
                          "عدد مرات تكرار العادة: ",
                          style: TextStyle(fontSize: 23),
                        ),
                        Text(
                          displayHabitfrequencyControlller.text,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                              fontSize: 22, color: Colors.black54),
                        )
                      ],
                    )
                  ])))
        ]));
  }
}
