import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_goal_page/add_goal_screen.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:motazen/pages/goals_habits_tab/details/new_goal_detail.dart';
import 'package:motazen/theme.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
import '/entities/goal.dart';

class GoalListScreen extends StatefulWidget {
  final IsarService isr;
  const GoalListScreen({super.key, required this.isr});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  DateTime temGoalDataTime = DateTime.utc(1989, 11, 9);
  late String dueDataDescription;

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return StreamBuilder<List<Goal>>(
      stream: IsarService().getAllGoals(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final goals = snapshot.data;
          if (goals!.isEmpty) {
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "ليس لديك أهداف ",
                    style: TextStyle(color: Colors.black12, fontSize: 30),
                  ),
                  GestureDetector(
                    child:
                        const Icon(Icons.add, color: Colors.black12, size: 30),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return AddGoal(
                              isr: widget.isr,
                              goalsTasks: const [],
                            );
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            ); // here add a plust button to add
          }
          return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final endDate = goals[index].endDate;
                dueDataDescription =
                    "تاريخ الاستحقاق :${intl.DateFormat.yMMMEd().format(endDate)}";

                // }

                final aspectName = goal.aspect.value?.name;
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 4, right: 4, left: 4),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 5,
                      // here is the code of each item you have
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ListTile(
                            trailing: TextButton(
                                child:
                                    Icon(Icons.delete, color: Colors.grey[500]),
                                onPressed: () async {
                                  if (goal.communities.isEmpty) {
                                    final action =
                                        await AlertDialogs.yesCancelDialog(
                                            context,
                                            ' هل انت متاكد من حذف هذا الهدف  ',
                                            'بالنقر على "تاكيد"لن تتمكن من استرجاع الهدف  ');
                                    if (action == DialogsAction.yes) {
                                      widget.isr.deleteGoal(goal);
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            duration:
                                                const Duration(seconds: 1),
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 196, 48, 37),
                                            content: Row(
                                              children: const [
                                                Icon(
                                                  Icons.error,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(width: 20),
                                                Expanded(
                                                  child: Text(
                                                      "لا يمكن حذف هذا الهدف  "),
                                                )
                                              ],
                                            )));
                                  }
                                }),
                            tileColor: Colors.white,
                            leading: aspectList.getSelectedIcon(aspectName!),
                            subtitle: Text(
                              dueDataDescription,
                              style: TextStyle(
                                  color: endDate.isBefore(DateTime.now())
                                      ? Colors.red
                                      : Colors.black),
                            ), // if not null added
                            title: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                goal.titel,
                                style: TextStyle(
                                    color: endDate.isBefore(DateTime.now())
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(7),
                            onTap: () {
                              // should return me to the page with add field
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ShowCaseWidget(
                                        builder: Builder(
                                            builder: (context) =>
                                                GoalDetailPage(
                                                  isr: widget.isr,
                                                  goalId: goal.id,
                                                ))); // must be the
                                  },
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          LinearPercentIndicator(
                            animation: true,
                            animationDuration: 600,
                            curve: Curves.easeIn,
                            percent: goal.goalProgressPercentage,
                            lineHeight: 7,
                            isRTL: true,
                            progressColor: kPrimaryColor,
                            backgroundColor: kPrimaryColor.withOpacity(0.3),
                            barRadius: const Radius.circular(10),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
