// ignore_for_file: file_names, non_constant_identifier_names, unused_local_variable
//man
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
    return "عادات $nameInArabic";
  }

  @override
  Widget build(BuildContext context) {
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
              chooseIcon(widget.aspect.name)
            ],
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
                            ' هل انت متاكد من حذف هذه العادة  ',
                            'بالنقر على تأكيد لن تتمكن من استرجاع تلك العادة ');
                        if (action == DialogsAction.yes) {
                          widget.isr.deleteHabit(habit);
                        } else {}
                      },
                    ),
                    tileColor: (index % 2 != 0)
                        ? Colors.white
                        : const Color.fromARGB(33, 102, 191, 118),
                    subtitle: Text("التكرار : $startData"), // if not null added
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
