import 'package:flutter/material.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/add_habit_page/add_habit.dart';
import 'package:motazen/pages/assesment_page/aler2.dart';
import 'package:motazen/pages/goals_habits_tab/details/new_habit_page.dart';
import 'package:provider/provider.dart';
import '../../controllers/aspect_controller.dart';
import '/entities/habit.dart';

class HabitListScreen extends StatefulWidget {
  final IsarService isr;
  const HabitListScreen({super.key, required this.isr});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return StreamBuilder<List<Habit>>(
      stream: IsarService().getAllHabits(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final habits = snapshot.data;
          if (habits!.isEmpty) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ليس لديك عادات ",
                  style: TextStyle(color: Colors.black12, fontSize: 30),
                ),
                GestureDetector(
                  child: const Icon(Icons.add, color: Colors.black12, size: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddHabit(
                        isr: widget.isr,
                      ); // must be the
                    }));
                  },
                )
              ],
            )); // here add a plust button to add
          }
          return ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                final startData = habits[index].frequency;
                final aspectName = habit.aspect.value?.name;
                return Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: const EdgeInsets.only(bottom: 4, right: 4, left: 4),
                  child: Card(
                    elevation: 3,
                    // here is the code of each item you have
                    child: ListTile(
                      trailing: TextButton(
                        child: Icon(
                          Icons.delete,
                          color: Colors.grey[500],
                        ),
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
                      tileColor: (index % 2 == 0)
                          ? Colors.white
                          : const Color.fromARGB(33, 102, 191, 118),
                      leading: aspectList.getSelectedIcon(aspectName!),
                      subtitle:
                          Text("التكرار : $startData"), // if not null added
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
                              isr: widget.isr,
                              habitId: habit.id); // must be the
                        }));
                      },
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
