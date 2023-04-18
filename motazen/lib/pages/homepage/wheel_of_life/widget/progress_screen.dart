import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/imporvment.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/homepage/wheel_of_life/widget/aspect_community_list.dart';
import 'package:motazen/pages/homepage/wheel_of_life/widget/aspect_goal_list.dart';
import 'package:motazen/pages/homepage/wheel_of_life/widget/aspect_habit_list.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../entities/goal.dart';

class ProgressScreen extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const ProgressScreen({super.key, required this.isr, required this.aspect});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  late List<GDPData> _chartData;
  List<Community> communities = [];
  CommunityController communityController = Get.find();
  @override
  initState() {
    super.initState();
    communities = communityController.findAspectComm(widget.aspect);
    List<Goal> notStartedGoalList = widget.aspect.goals
        .toList()
        .where((element) => element.goalProgressPercentage == 0)
        .toList();
    int numberOfNotStarted = notStartedGoalList.length;
    List<Goal> startedGoalList = widget.aspect.goals
        .toList()
        .where((element) =>
            element.goalProgressPercentage > 0 &&
            element.endDate.isAfter(DateTime.now()))
        .toList();
    int numberOfStarted = startedGoalList.length;
    List<Goal> lateGoalList = widget.aspect.goals
        .toList()
        .where((element) => element.endDate.isBefore(DateTime.now()))
        .toList();
    int numberOfLate = lateGoalList.length;

    _chartData = getChartData(numberOfLate, lateGoalList, numberOfStarted,
        startedGoalList, numberOfNotStarted, notStartedGoalList);
  } // here is the array

  List<Color> gradientColors = [const Color(0xff23b6e6), Colors.green.shade300];

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    //* a list of the aspect's improvements
    List<Imporvment> improvements = widget.aspect.imporvmentd.toList();

    return Scaffold(
      appBar: AppBar(
        actions: [
          aspectList.getSelectedIcon(widget.aspect.name),
          const SizedBox(
            width: 10,
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.green,
                ));
          },
        ),
        title: Text(
          widget.aspect.name,
          style: titleText2,
        ),
        centerTitle: true,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
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
                                        isr: widget.isr,
                                        aspect: widget.aspect));
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
                                child: customCircularIndicator(
                                    "المجتمعات",
                                    communities.length.toString(),
                                    'blueProgress.png',
                                    Colors.blue),
                                onTap: () => Get.to(() => AspectCommunityList(
                                      community: communities,
                                      aspect: widget.aspect,
                                    )),
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: SfCartesianChart(
                          enableAxisAnimation: true,
                          title: ChartTitle(text: "تطور الجانب "),
                          primaryXAxis: DateTimeAxis(
                            minorTicksPerInterval: 4,
                            minimum: improvements[0].date.toUtc(),
                            maximum: improvements[improvements.length - 1]
                                .date
                                .toUtc(),
                          ),
                          series: <ChartSeries>[
                            // Renders line chart
                            SplineAreaSeries<Imporvment, DateTime>(
                              yAxisName: "النقاط",
                              dataSource: improvements,
                              xValueMapper: (Imporvment improve, _) =>
                                  improve.date.toUtc(),
                              yValueMapper: (Imporvment improve, _) =>
                                  improve.sum,
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
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SfCircularChart(
                                    title: ChartTitle(
                                        text: 'الأداء المتعلق بأهدافي'),
                                    legend: Legend(
                                        isVisible: true,
                                        overflowMode:
                                            LegendItemOverflowMode.wrap),
                                    series: <CircularSeries>[
                                      DoughnutSeries<GDPData, String>(
                                          dataSource: _chartData,
                                          xValueMapper: (GDPData data, _) =>
                                              data.continent,
                                          yValueMapper: (GDPData data, _) =>
                                              data.gdp,
                                          pointColorMapper: (GDPData data, _) =>
                                              data.color,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true,
                                                  showZeroValue: false),
                                          explodeGesture:
                                              ActivationMode.singleTap,
                                          explode: true,
                                          onPointTap:
                                              (pointInteractionDetails) {},
                                          legendIconType: LegendIconType.circle,
                                          innerRadius: "70%")
                                    ],
                                  ))
                            ],
                          )),
                    ),
                  ]))),
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

List<GDPData> getChartData(
    int numberOfLate,
    List<Goal> lateGoalList,
    int numberOfStarted,
    List<Goal> startedGoalList,
    int numberOfNotStarted,
    List<Goal> notStartedGoalList) {
  // here you need to get the value
  // لم يتم البدء فيها  then ones with zero as progress
  // قيد التحقيق the ones where  progress greater than zero and due date is before today
  // متاأخرة those with due date before datetime.now

  final List<GDPData> chartData = [
    GDPData('لم يتم البدء فيها', numberOfNotStarted, color: Colors.grey),
    GDPData('قيد التحقيق', numberOfStarted, color: Colors.blue),
    GDPData('متأخره', numberOfLate,
        color: const Color.fromARGB(255, 218, 61, 50)),
  ];
  return chartData;
}

class GDPData {
  GDPData(this.continent, this.gdp, {required this.color});
  final String continent;
  final int gdp;
  final Color color;
}
