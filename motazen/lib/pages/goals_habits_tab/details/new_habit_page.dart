import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:provider/provider.dart';
import '../../../entities/habit.dart';
import '../../../isar_service.dart';
import '../../../theme.dart';
import '../edit/edit_habit.dart';

class HabitDetailPage extends StatefulWidget {
  final IsarService isr;
  final int habitId;
  const HabitDetailPage({super.key, required this.isr, required this.habitId});
  @override
  State<HabitDetailPage> createState() => _HabitDetailPageState();
}

class _HabitDetailPageState extends State<HabitDetailPage> {
  TextEditingController displayHabitNameControlller = TextEditingController();
  TextEditingController displayHabitfrequencyControlller =
      TextEditingController();
  String habitAspect = "";
  String frequency = "";
  int durationInNumber = 0;
  int durationIndex = 0;
  Habit? habit;
  late Image goalImage;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getHabitInformation();
    // might be deleted .
  }

  getHabitInformation() async {
    habit = await widget.isr.getSepecificHabit(widget.habitId);
    setState(() {
      displayHabitNameControlller.text = habit!.titel;
      displayHabitfrequencyControlller.text = habit!.frequency;
      durationIndex = habit!.durationIndString;
      durationInNumber = habit!.durationInNumber;
      habitAspect = habit!.aspect.value!.name;
      switch (habitAspect) {
        case "أموالي":
          habitAspect = "أموالي";
          goalImage = Image.asset('assets/images/money.png');
          break;
        case "متعتي":
          habitAspect = "متعتي";
          goalImage = Image.asset('assets/images/fun.png');
          break;
        case "مهنتي":
          habitAspect = "مهنتي";
          goalImage = Image.asset('assets/images/career.png');
          break;
        case "علاقاتي":
          habitAspect = "علاقاتي";
          goalImage = Image.asset('assets/images/Relationships.png');
          break;
        case "بيئتي":
          habitAspect = "بيئتي";
          goalImage = Image.asset('assets/images/Enviroment.png');
          break;
        case "ذاتي":
          habitAspect = "ذاتي";
          goalImage = Image.asset('assets/images/personal.png');
          break;

        case "صحتي":
          habitAspect = "صحتي";
          goalImage = Image.asset('assets/images/health.png');
          break;
        case "عائلتي واصدقائي":
          habitAspect = "عائلتي واصدقائي";
          goalImage = Image.asset('assets/images/familyfriends.png');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: const Text('معلومات العادة'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditHabit(
                isr: widget.isr,
                habitName: displayHabitNameControlller.text,
                habitFrequency: displayHabitfrequencyControlller.text,
                habitAspect: habitAspect,
                id: widget.habitId,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayHabitNameControlller.text,
                style: const TextStyle(fontSize: 30),
              ),
              Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                    child: goalImage),
              ),
              const SizedBox(height: 25),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 45,
                  decoration: BoxDecoration(
                      boxShadow: const [BoxShadow(blurRadius: 2.0)],
                      borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 253, 253, 254),
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(68, 102, 191, 119),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20))),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'التفاصيل',
                                  style: TextStyle(
                                      fontSize: 23, color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const Text(
                                  //   '',
                                  //   style: TextStyle(
                                  //     fontWeight: FontWeight.bold,
                                  //     fontSize: 18,
                                  //   ),
                                  // ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Text(
                                        'تكرار العادة:  ',
                                        style: TextStyle(
                                          color: Color(0xFF66BF77),
                                          fontSize: 23,
                                        ),
                                      ),
                                      Text(
                                        displayHabitfrequencyControlller.text,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 23),
                                      ),
                                    ],
                                  ),
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
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
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
