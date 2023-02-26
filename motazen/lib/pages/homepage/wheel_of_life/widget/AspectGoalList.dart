// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:motazen/theme.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import '../../../../entities/goal.dart';
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

  String AspectName(String name) {
    String nameInArabic = "";
    switch (name) {
      case "أموالي":
        nameInArabic = "أموالي";
        break;
      case "متعتي":
        nameInArabic = "متعتي";
        break;
      case "مهنتي":
        nameInArabic = "مهنتي";
        break;
      case "علاقتي":
        nameInArabic = "علاقاتي";
        break;
      case "بيئتي":
        nameInArabic = "بيئتي";
        break;
      case "ذاتي":
        nameInArabic = "ذاتي";
        break;

      case "صحتي":
        nameInArabic = "صحتي";
        break;
      case "عائلتي واصدقائي":
        nameInArabic = "عائلتي وأصدقائي";
        break;
    }
    return "أهداف $nameInArabic";
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                AspectName(widget.aspect.name),
                textDirection: TextDirection.rtl,
                style: titleText2,
              ),
              const SizedBox(
                width: 10,
              ),
              aspectList.getSelectedIcon(widget.aspect.name),
            ],
          ),
          automaticallyImplyLeading: true, // need color
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              final startData = goals[index].startData;
              final endDate = goals[index].endDate;
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
            }));
  }
}
