import 'package:flutter/material.dart';
import '/entities/goal.dart';
import '/pages/goals_habits_tab/goal_edit.dart';
import "/isar_service.dart";

import '../add_goal_page/get_chosen_aspect.dart';
import '../assesment_page/alert_dialog.dart';

class GoalListScreen extends StatefulWidget {
  final IsarService isr;
  const GoalListScreen({super.key, required this.isr});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<Goal>>(
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
                  child: const Icon(Icons.add, color: Colors.black12, size: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return getChosenAspect(
                        iser: widget.isr,
                        goalsTasks: const [],
                        page: 'Goal',
                      ); // must be the
                    }));
                  },
                )
              ],
            )); // here add a plust button to add
          }
          return ListView.builder(
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final startData = goals[index].dueDate;
                final aspectName = goal.aspect.value?.name;
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 4),
                  child: GestureDetector(
                    onTap: () {},
                    child: Card(
                      elevation: 3,
                      // here is the code of each item you have
                      child: ListTile(
                        trailing: TextButton(
                          child: const Icon(Icons.delete),
                          onPressed: () async {
                            final action = await AlertDialogs.yesCancelDialog(
                                context,
                                ' هل انت متاكد من حذف هذا الهدف  ',
                                'بالنقر على "تاكيد"لن تتمكن من استرجاع الهدف ا  ');
                            if (action == DialogsAction.yes) {
                              widget.isr.deleteGoal(goal);
                            } else {}
                          },
                        ),
                        tileColor: (index % 2 == 0)
                            ? Colors.white
                            : const Color.fromARGB(33, 102, 191, 118),
                        leading: chooseIcon(aspectName),
                        subtitle: Text(
                            "تاريخ الاستحقاق : $startData"), // if not null added
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(goal.titel),
                        ),
                        contentPadding: const EdgeInsets.all(7),
                        onTap: () {
                          // should return me to the page with add field
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditGoal(
                              isr: widget.isr,
                              goalId: goal.id,
                            ); // must be the
                          }));
                        },
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
    ));
  }
}