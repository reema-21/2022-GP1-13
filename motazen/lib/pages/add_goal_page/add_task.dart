import '/isar_service.dart';

import '../../entities/task.dart';
import 'add_goal_screen.dart';
import "task_importance.dart";
import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  static Route route() {
    return MaterialPageRoute(builder: ((context) => const TaskScreen()));
  }

  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  TextEditingController _textEditingController = TextEditingController();
  final IsarService isr = IsarService();

  final String selectImportance = '';
  List<Task>? tasks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new Task"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 24, left: 12, right: 12),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: TextField(
                    controller: _textEditingController,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Task Name',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 24, left: 12, right: 12),
                  decoration: BoxDecoration(
                      color: Colors.lightBlue.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 6),
                    scrollDirection: Axis.horizontal,
                    itemCount: _importanceList.length,
                    itemBuilder: (context, index) => ChoiceChip(
                      selected: _importanceList.elementAt(index).isChecked,
                      selectedColor: _importanceList[index].color,
                      label: Text(_importanceList[index].title),
                      onSelected: (value) {
                        _importanceList = _importanceList
                            .map((e) => e.copyWith(isChecked: false))
                            .toList();
                        _importanceList[index] =
                            _importanceList[index].copyWith(isChecked: value);

                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              addTask(
                _textEditingController.text,
                _importanceList
                    .firstWhere((element) => element.isChecked)
                    .title,
              );

              _textEditingController.clear();
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddGoal(isr: isr);
                },
              ));
            },
            child: const Text("add Task"),
          ),
        ],
      ),
    );
  }

  List<TaskImportance> _importanceList = [
    TaskImportance(
      color: Colors.yellow,
      title: "not importance",
    ),
    TaskImportance(
      color: Colors.orange,
      title: "importance",
    ),
    TaskImportance(
      color: Colors.red,
      title: "very importance",
    ),
  ];

  Future<void> addTask(String taskName, String importance) async {
    if (taskName.isEmpty) return;
    final Task task = Task()
      ..name = taskName
      ..taskImportance = importance;
    await isr.saveTask(task);
  }
}
