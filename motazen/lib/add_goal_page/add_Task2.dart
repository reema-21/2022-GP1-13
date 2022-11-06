// ignore_for_file: non_constant_identifier_names, file_names,

import 'package:flutter/material.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import '../pages/assesment_page/aler2.dart';

class AddTask extends StatefulWidget {
  final IsarService isr;
  final int goalDurtion;
  final List<Task> goalTask;
  const AddTask(
      {super.key,
      required this.isr,
      required this.goalDurtion,
      required this.goalTask});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //counter
  num numberduration = 0;

  //counter
  String? isSelected;
  num totalTasksDuration = 0;
  num goalduration = 10;
  List<String> TasksNamedropmenue = [];
  List<String> selected = [];
  TextEditingController inputTaskName = TextEditingController();
  TextEditingController oneTaskduration = TextEditingController();

  late String TaskName;
  @override
  void initState() {
    super.initState();
    inputTaskName.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      TaskName = inputTaskName.text;
    });
  }

  List<String> durationName = ['Days', 'Weeks', 'Months', 'Years'];
  int x = 1;
  AddTheEnterdTask() async {
    Task newTak = Task();
    newTak.name = inputTaskName.text;
    x = 1;
    newTak.duration = 5;
    inputTaskName.text = "";
    isSelected = null;

    totalTasksDuration = totalTasksDuration - numberduration;
    oneTaskduration.text = 0.toString();

    widget.isr.saveTask(newTak);
    setState(() {
      go = false;
      widget.goalTask.add(newTak);
    });
  }

  // Widget TaskDepencenies( ){

  //     return DropDownMultiSelect(
  //       onChanged: (List<String> x) {
  //         setState(() {
  //           selected =x;

  //         });
  //       },
  //       options:TasksNamedropmenue,
  //       selectedValues: selected,
  //       whenEmpty: 'Select Something',
  //     );
  //   }

  // String input="";
  final formKey = GlobalKey<FormState>();
  bool go = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF66BF77),
          title: const Text(
            "إضافة هدف جديد",
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
        body: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  itemCount: widget.goalTask.length,
                  itemBuilder: (context, index) {
                    final name = widget.goalTask[index].name;
                    if (name != null) {
                      TasksNamedropmenue.add(name);
                    }

                    return Card(
                        elevation: 3,
                        // here is the code of each item you have
                        child: ListTile(
                          trailing: TextButton(
                            child: const Icon(Icons.delete),
                            onPressed: () async {
                              final action = await AlertDialogs.yesCancelDialog(
                                  context,
                                  ' هل انت متاكد من حذف هذه المهمة  ',
                                  'بالنقر على "تاكيد"لن تتمكن من استرجاع المهمة ');
                              if (action == DialogsAction.yes) {
                                widget.isr.deleteTask2(widget.goalTask[index]);
                                setState(() {
                                  widget.goalTask
                                      .remove(widget.goalTask[index]);
                                });
                              } else {}
                            },
                          ),
                          // if not null added
                          title: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text("$name"),
                          ),
                        ));
                  }),
            )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "أضف مهمه جديدة",
                        textDirection: TextDirection.rtl,
                      ),
                      content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                              child: Column(children: [
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "من فضلك ادخل اسم المهمة";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: inputTaskName,
                                  decoration: const InputDecoration(
                                    labelText: "اسم المهمة",
                                    prefixIcon: Icon(
                                      Icons.verified_user_outlined,
                                      color: Color(0xFF66BF77),
                                    ),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),

                                //  TaskDepencenies(),
                                ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        // TasksNamedropmenue.add(inputTaskName.text);

                                        AddTheEnterdTask();
                                        // TasksName.add(inputTaskName.text);
                                        // print("i am at the prssed button after adding");
                                        // print (TasksName);
                                      });
                                    }
                                  },
                                  child: const Text("إضافة"),
                                ),
                              ]),
                            ),
                          )),
                    );
                  });
            }),
      ),
    );
  }
}
