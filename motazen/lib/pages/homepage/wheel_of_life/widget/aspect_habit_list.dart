import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/habit.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:motazen/pages/goals_habits_tab/details/new_habit_page.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                widget.aspect.name,
                style: titleText2,
              ),
              const SizedBox(
                width: 10,
              ),
              aspectList.getSelectedIcon(widget.aspect.name)
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
                        }
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
                        return HabitDetailPage(
                            isr: widget.isr, habitId: habit.id); // must be the
                      }));
                    },
                  ),
                ),
              );
            }));
  }
}
