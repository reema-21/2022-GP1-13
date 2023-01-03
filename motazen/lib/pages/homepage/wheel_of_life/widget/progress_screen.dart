// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/wheel_of_life/widget/AspectGoalList.dart';
import 'package:motazen/pages/homepage/wheel_of_life/widget/AspectHabitList.dart';
import 'package:motazen/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProgressScreen extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const ProgressScreen({super.key, required this.isr, required this.aspect});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  // here is the array
  // create object of aspectImprovemnet each time and then add it to the array .
  final List<AspectImporvment> chartData = [
    AspectImporvment(DateTime.now(),
        35), //DateTime will start from the Date of  the selection and end with last date when and improvment happend
    // the points will start from the result of the assesment and then the increasing each day untill today
    AspectImporvment(DateTime.utc(2022, 12, 25), 28),
    AspectImporvment(DateTime.utc(2022, 12, 29), 34),
    AspectImporvment(DateTime.utc(2022, 12, 30), 32),
    AspectImporvment(DateTime.utc(2023, 1, 2), 40)
  ];
  Icon chooseIcon(String? x) {
    Icon rightIcon = const Icon(Icons.abc);
    switch (x) {
      //Must include all the aspect characters and specify an icon for that
      case "Health and Wellbeing":
        {
          // statements;
          rightIcon = const Icon(Icons.spa, color: Color(0xFFffd400));
        }
        break;

      case "career":
        {
          //statements;
          rightIcon = const Icon(Icons.work, color: Color(0xff0065A3));
        }
        break;
      case "Family and Friends":
        {
          //statements;
          rightIcon = const Icon(Icons.person, color: Color(0xFFff9100));
        }
        break;

      case "Significant Other":
        {
          //statements;
          rightIcon = const Icon(
            Icons.favorite,
            color: Color(0xffff4949),
          );
        }
        break;
      case "Physical Environment":
        {
          //statements;
          rightIcon = const Icon(
            Icons.home,
            color: Color(0xFF9E19F0),
          );
        }
        break;
      case "money and finances":
        {
          //statements;
          rightIcon = const Icon(
            Icons.attach_money,
            color: Color(0xff54e360),
          );
        }
        break;
      case "Personal Growth":
        {
          //statements;
          rightIcon = const Icon(
            Icons.psychology,
            color: Color(0xFF2CDDCB),
          );
        }
        break;
      case "Fun and Recreation":
        {
          //statements;
          rightIcon = const Icon(
            Icons.games,
            color: Color(0xff008adf),
          );
        }
        break;
    }

    return rightIcon;
  }

  String AspectName(String name) {
    String nameInArabic = "";
    switch (name) {
      case "money and finances":
        nameInArabic = "أموالي";
        break;
      case "Fun and Recreation":
        nameInArabic = "متعتي";
        break;
      case "career":
        nameInArabic = "مهنتي";
        break;
      case "Significant Other":
        nameInArabic = "علاقاتي";
        break;
      case "Physical Environment":
        nameInArabic = "بيئتي";
        break;
      case "Personal Growth":
        nameInArabic = "ذاتي";
        break;

      case "Health and Wellbeing":
        nameInArabic = "صحتي";
        break;
      case "Family and Friends":
        nameInArabic = "عائلتي وأصدقائي";
        break;
    }
    return nameInArabic;
  }

  List<Color> gradientColors = [const Color(0xff23b6e6), Colors.green.shade300];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              // ignore: prefer_const_constructors
              icon: Icon(Icons.arrow_back_ios_new, color: kPrimaryColor),
              onPressed: () {
                // for (int i = 0;
                //     i < freq.newTasksAddedInEditing.value.length;
                //     i++)
                Navigator.of(context).pop();
              }),
        ],

        leading: chooseIcon(widget.aspect.name),
        title: Text(
          AspectName(widget.aspect.name),
          style: titleText2,
        ),
        automaticallyImplyLeading: true, // need color
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color.fromARGB(255, 236, 239, 240),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: customCircularIndicator(
                              "الأهداف",
                              widget.aspect.goals.length.toString(),
                              "greenProgress.png",
                              Colors.green,
                            ),
                            onTap: () {
                              Get.to(AspectGoal(
                                  isr: widget.isr, aspect: widget.aspect));
                            }),
                        GestureDetector(
                          child: customCircularIndicator(
                              "العادات",
                              widget.aspect.habits.length.toString(),
                              'yellowProgress.png',
                              Colors.yellow),
                          onTap: () {
                            Get.to(AspectHabit(
                                isr: widget.isr, aspect: widget.aspect));
                          },
                        ),

                        GestureDetector(
                          child: customCircularIndicator("المجتمعات", "3",
                              'blueProgress.png', Colors.blue),
                          onTap: () {},
                        ),

                        // Fixed for now need to be changed
                      ],
                    )),
              ),
              const SizedBox(
                height: 25,
              ),
              //----------------------------- here is the line chart ---------------------- //

              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color.fromARGB(255, 236, 239, 240),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SfCartesianChart(
                    enableAxisAnimation: true,
                    title: ChartTitle(text: "تطور الجانب "),
                    primaryXAxis: DateTimeAxis(
                      minorTicksPerInterval: 4,
                      minimum: chartData[0].day,
                      maximum: chartData[chartData.length - 1].day,
                    ),
                    series: <ChartSeries>[
                      // Renders line chart
                      SplineAreaSeries<AspectImporvment, DateTime>(
                        yAxisName: "النقاط",
                        dataSource: chartData,
                        xValueMapper: (AspectImporvment improve, _) =>
                            improve.day,
                        yValueMapper: (AspectImporvment improve, _) =>
                            improve.points,
                        gradient: LinearGradient(
                            colors: gradientColors
                                .map((e) => e.withOpacity(0.3))
                                .toList()),
                      )
                    ]),
              ),

              //----------------------------- here is the line chart ---------------------- //
              const SizedBox(
                height: 25,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color.fromARGB(255, 236, 239, 240),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.7),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'أهم أهدافك',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 102, 191, 119),
                                fontSize: 25),
                          ),
                        ),
                        //take a list of the most recent goal
                        // send the goal name and the goal points
                        customLinearIndicator(
                            "الهدف 1", 60, Colors.green.shade300, Colors.grey),
                        customLinearIndicator(
                            "الهدف 2", 65, Colors.green.shade300, Colors.grey),
                        customLinearIndicator(
                            "الهدف 3", 20, Colors.green.shade300, Colors.grey),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  customCircularIndicator(
      String label, String text, String imageName, Color c1) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/images/$imageName',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 43, 42, 42),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                )

                ///
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), color: c1),
              )
            ],
          )
        ],
      ),
    );
  }

  customLinearIndicator(String label, double val, Color c1, Color c2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 25,
                value: 1 - (val / 100.0),
                backgroundColor: c1,
                valueColor: AlwaysStoppedAnimation(c2),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class AspectImporvment {
  AspectImporvment(this.day, this.points);
  final DateTime day;
  final double points;
}
