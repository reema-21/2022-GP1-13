// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, unused_element

import 'package:flutter/material.dart';
import '../assesment_page/alert_dialog.dart';
import 'task_controller.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import 'package:get/get.dart';

class AddTask extends StatefulWidget {
  final IsarService isr;
  int goalDurtion;
  List<Task> goalTask;
  AddTask(
      {super.key,
      required this.isr,
      required this.goalDurtion,
      required this.goalTask});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  //counter
  final TaskControleer freq = Get.put(TaskControleer());

  //counter
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];

  List<String> TasksNamedropmenue = [];
  List<String> selected = [];
  String? isSelected = "";

  late String TaskName;
  @override
  void initState() {
    super.initState();

    // inputTaskName.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      // TaskName = inputTaskName.text;
    });
  }

  AddTheEnterdTask(Task newTask) async {
    widget.isr.saveTask(newTask);
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xFF66BF77),
            title: const Text(
              "إضافة مهمة جديدة",
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
                    child: Obx(() => ListView.builder(
                        itemCount: freq.itemCount.value,
                        itemBuilder: (context, index) {
                          final name = freq.goalTask.value[index].name;
                          final impo = freq.goalTask.value[index].duration;
                          final durationDescription =
                              freq.goalTask.value[index].durationDescribtion;
                          TasksNamedropmenue.add(name);
                          String diplayedduration = "";
                          switch (durationDescription) {
                            case "أيام":
                              if (impo == 1) {
                                diplayedduration = " يوم  ";
                              } else if (impo == 2) {
                                diplayedduration = " يومان";
                              } else {
                                diplayedduration =
                                    "$impo  $durationDescription";
                              }

                              break;
                            case "أسابيع":
                              if (impo == 7) {
                                diplayedduration = " إسبوع  ";
                              } else if (impo == 14) {
                                diplayedduration = "إسبوعان ";
                              } else {
                                double x = impo / 7;
                                int y = x.toInt();
                                diplayedduration = "$y $durationDescription";
                              }

                              break;
                            case "أشهر":
                              if (impo == 30) {
                                diplayedduration = " شهر  ";
                              } else if (impo == 60) {
                                diplayedduration = "شهران ";
                              } else {
                                double x = impo / 30;
                                int y = x.toInt();
                                diplayedduration = "$y $durationDescription";
                              }

                              break;
                            case "سنوات":
                              if (impo == 360) {
                                diplayedduration = " سنة  ";
                              } else if (impo == 720) {
                                diplayedduration = "سنتان ";
                              } else {
                                double x = impo / 360;
                                int y = x.toInt();
                                diplayedduration = "$y $durationDescription";
                              }

                              break;
                          }

                          return Card(
                              elevation: 3,
                              // here is the code of each item you have
                              child: ListTile(
                                trailing: TextButton(
                                  child: const Icon(Icons.delete),
                                  onPressed: () async {
                                    final action =
                                        await AlertDialogs.yesCancelDialog(
                                            context,
                                            ' هل انت متاكد من حذف هذه المهمة  ',
                                            'بالنقر على "تاكيد"لن تتمكن من استرجاع المهمة ');
                                    if (action == DialogsAction.yes) {
                                      int x =
                                          freq.goalTask.value[index].duration;
                                      freq.dcrementTaskDuration(x);
                                      widget.isr.deleteTask2(
                                          freq.goalTask.value[index]);
                                      setState(() {
                                        freq.removeTask(index);
                                      });
                                    } else {}
                                  },
                                ),
                                // if not null added
                                title: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(name),
                                ),
                                subtitle: Text(" الفترة :$diplayedduration"),
                              ));
                        }))),
              )
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
                            " مهمة جديدة",
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
                                      // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                                      //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                                      // }
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: freq.inputTaskName,
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
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    const Text("الفترة"),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFF66BF77),
                                      ),
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                          onPressed: () {
                                            freq.increment(widget.goalDurtion);
                                            if (freq.TaskDuration != 0) {
                                              freq.storeStatusOpen(true);
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Obx((() => Text(
                                          freq.TaskDuration.toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ))),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: const Color(0xFF66BF77),
                                      ),
                                      child: IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.white, size: 15),
                                        onPressed: () {
                                          freq.dcrement();
                                          freq.storeStatusOpen(true);

                                          if (freq.TaskDuration == 0) {
                                            freq.storeStatusOpen(false);
                                          }
                                        },
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Obx(
                                      () => DropdownButton(
                                        //changes
                                        value: freq.isSelected.value,

                                        items: durationName
                                            .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e),
                                                ))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            isSelected = value;
                                            for (int i = 0;
                                                i < durationName.length;
                                                i++) {
                                              if (value!
                                                  .contains(durationName[0])) {
                                                freq.setvalue(durationName[0]);
                                              } else if (value
                                                  .contains(durationName[1])) {
                                                freq.setvalue(durationName[1]);
                                              } else if (value
                                                  .contains(durationName[2])) {
                                                freq.setvalue(durationName[2]);
                                              } else {
                                                freq.setvalue(durationName[3]);
                                              }
                                            }

                                            switch (freq.isSelected.value) {
                                              case "أيام":
                                                freq.setdefult();
                                                freq.storeStatusOpen(false);

                                                break;
                                              case "أسابيع":
                                                freq.setdefult();
                                                freq.storeStatusOpen(false);

                                                break;
                                              case "أشهر":
                                                freq.setdefult();
                                                freq.storeStatusOpen(false);

                                                break;
                                              case "سنوات":
                                                freq.storeStatusOpen(false);

                                                freq.setdefult();

                                                break;
                                            }
                                          });
                                        },
                                        icon: const Icon(
                                          size: 30,
                                          Icons.arrow_drop_down_circle,
                                          color: Color(0xFF66BF77),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Obx(() => ElevatedButton(
                                      onPressed: freq.iscool.value
                                          ? () {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  // TasksNamedropmenue.add(inputTaskName.text);

                                                  Task newTak = Task();
                                                  newTak.name = freq
                                                      .inputTaskName.value.text;
                                                  String durationDescribtion =
                                                      "";
                                                  switch (
                                                      freq.isSelected.value) {
                                                    case "أيام":
                                                      newTak.duration = freq
                                                          .TaskDuration.value;
                                                      durationDescribtion =
                                                          "أيام";
                                                      newTak.durationDescribtion =
                                                          durationDescribtion;
                                                      break;
                                                    case "أسابيع":
                                                      newTak.duration = (freq
                                                              .TaskDuration
                                                              .value *
                                                          7);
                                                      durationDescribtion =
                                                          "أسابيع";
                                                      newTak.durationDescribtion =
                                                          durationDescribtion;

                                                      break;
                                                    case "أشهر":
                                                      newTak.duration = (freq
                                                              .TaskDuration
                                                              .value *
                                                          30);
                                                      durationDescribtion =
                                                          "أشهر";
                                                      newTak.durationDescribtion =
                                                          durationDescribtion;

                                                      break;
                                                    case "سنوات":
                                                      newTak.duration = (freq
                                                              .TaskDuration
                                                              .value *
                                                          360);
                                                      durationDescribtion =
                                                          "سنوات ";
                                                      newTak.durationDescribtion =
                                                          durationDescribtion;

                                                      break;
                                                  }
                                                  AddTheEnterdTask(newTak);

                                                  freq.addTask(
                                                      freq.inputTaskName.value
                                                          .text,
                                                      freq.isSelected.value,
                                                      freq.TaskDuration.value);

                                                  freq.TaskDuration.value = 0;

                                                  freq.storeStatusOpen(false);
                                                  freq.incrementTaskDuration();
                                                  freq.currentTaskDuration
                                                      .value = 0;

                                                  freq.setvalue(
                                                      durationName[0]);
                                                });
                                              }
                                            }
                                          : null,
                                      child: const Text("اضافة"),
                                    ))
                              ])),
                            ),
                          ));
                    });
              }),
        ));
  }

  bool boolvalid = true;
}
