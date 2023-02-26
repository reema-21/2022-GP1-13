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
        case "أموالي":
          habitAspect = "أموالي";
          break;
        case "متعتي":
          habitAspect = "متعتي";
          break;
        case "مهنتي":
          habitAspect = "مهنتي";
          break;
        case "علاقتي":
          habitAspect = "علاقاتي";
          break;
        case "بيئتي":
          habitAspect = "بيئتي";
          break;
        case "ذاتي":
          habitAspect = "ذاتي";
          break;

        case "صحتي":
          habitAspect = "صحتي";
          break;
        case "عائلتي واصدقائي":
          habitAspect = "عائلتي وأصدقائي";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var aspectList = Provider.of<WheelData>(context);

    return Stack(
      children: [
        /// box
        Container(
          height: height,
          width: width,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        ClipPath(
          clipper: MyClipper(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.height / 2,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF66BF77),
                  Color(0xFF11249F),
                ],
              ),
            ),
          ),
        ),

        /// scaffold

        Scaffold(
          /// appbar
          appBar: AppBar(
            title: const Text(
              "معلومات العادة",
              style: TextStyle(color: Colors.white),
            ),
            //backgroundColor: kWhiteColor,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: kWhiteColor),
          ),

          /// floating button
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniStartFloat,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HabitDetails(
                    isr: widget.isr,
                    HabitName: displayHabitNameControlller.text,
                    habitFrequency: displayHabitfrequencyControlller.text,
                    habitAspect: habitAspect,
                    id: widget.HabitId,
                    duraioninString: durationIndex,
                    durationInInt: durationInNumber,
                    chosenAspectNames: aspectList.selected,
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

          /// backcolor
          //backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: Colors.transparent,

          /// body
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        width: width,
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: const Color(0xff1E1E1E).withOpacity(0.06),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "اسم العادة: ",
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Color(0xFF66BF77),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  displayHabitNameControlller.text,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                const Text(
                                  "جانب الحياة:",
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Color(0xFF66BF77),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  habitAspect,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "عدد مرات تكرار العادة: ",
                                  style: TextStyle(
                                    fontSize: 23,
                                    color: Color(0xFF66BF77),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    displayHabitfrequencyControlller.text,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 3, size.height / 3, size.width, size.height / 5);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
