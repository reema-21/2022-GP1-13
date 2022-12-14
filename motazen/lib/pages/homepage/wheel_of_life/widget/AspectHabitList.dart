// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable

import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/habit.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:motazen/theme.dart';

import '../../../goals_habits_tab/habit_edit.dart';

class AspectHabit extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const AspectHabit({super.key, required this.isr, required this.aspect});

  @override
  State<AspectHabit> createState() => _AspectGoal();
}

class _AspectGoal extends State<AspectHabit> {
  late List<Habit> habits;
  @override
  void initState() {
    habits = widget.aspect.habits.toList();
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
        nameInArabic = "????????????";
        break;
      case "Fun and Recreation":
        nameInArabic = "??????????";
        break;
      case "career":
        nameInArabic = "??????????";
        break;
      case "Significant Other":
        nameInArabic = "??????????????";
        break;
      case "Physical Environment":
        nameInArabic = "??????????";
        break;
      case "Personal Growth":
        nameInArabic = "????????";
        break;

      case "Health and Wellbeing":
        nameInArabic = "????????";
        break;
      case "Family and Friends":
        nameInArabic = "???????????? ????????????????";
        break;
    }
    return "?????????? $nameInArabic";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: chooseIcon(widget.aspect.name),
          title: Text(
            AspectName(widget.aspect.name),
            style: titleText2,
          ),
          automaticallyImplyLeading: true, // need color
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              final startData = habits[index].frequency;
              final aspectName = habit.aspect.value?.name;
              return Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.only(bottom: 4),
                child: Card(
                  elevation: 3,
                  // here is the code of each item you have
                  child: ListTile(
                    trailing: TextButton(
                      child: const Icon(Icons.delete),
                      onPressed: () async {
                        final action = await AlertDialogs.yesCancelDialog(
                            context,
                            ' ???? ?????? ?????????? ???? ?????? ?????? ????????????  ',
                            '???????????? ?????? ?????????? ???? ?????????? ???? ?????????????? ?????? ???????????? ');
                        if (action == DialogsAction.yes) {
                          widget.isr.deleteHabit(habit);
                        } else {}
                      },
                    ),
                    tileColor: (index % 2 != 0)
                        ? Colors.white
                        : const Color.fromARGB(33, 102, 191, 118),
                    subtitle: Text("?????????????? : $startData"), // if not null added
                    title: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(habit.titel),
                    ),
                    contentPadding: const EdgeInsets.all(7),
                    onTap: () {
                      // should return me to the page with add field
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditHbit(
                            isr: widget.isr, HabitId: habit.id); // must be the
                      }));
                    },
                  ),
                ),
              );
            }));
  }
}
