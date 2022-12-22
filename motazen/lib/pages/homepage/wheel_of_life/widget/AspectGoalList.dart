// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isarService.dart';
import 'package:motazen/theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../entities/goal.dart';
import '../../../assesment_page/aler2.dart';
import '../../../goals_habits_tab/goal_edit.dart';

class AspectGoal extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const AspectGoal({super.key, required this.isr, required this.aspect});

  @override
  State<AspectGoal> createState() => _AspectGoal();
}

class _AspectGoal extends State<AspectGoal> {
  late List<Goal> goals;
  @override
  void initState() {
    goals = widget.aspect.goals.toList();
    super.initState();
  }

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
    return "أهداف $nameInArabic";
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: chooseIcon(widget.aspect.name),
              title: Text(
                AspectName(widget.aspect.name),
                textDirection: TextDirection.rtl,
                style: titleText2,
              ),
              automaticallyImplyLeading: true, // need color
              backgroundColor: Colors.white,
            ),
            body: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  final startData = goals[index].dueDate;
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
                              tileColor: Colors.white,
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
                })));
  }
}
