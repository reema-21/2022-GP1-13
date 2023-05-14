// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/models/task_model.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/controllers/localtask_controller.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:get/get.dart';
import 'package:multiselect/multiselect.dart';

class AddTask extends StatefulWidget {
  final IsarService isr;
  int goalDurtion;
  List<LocalTask> goalTask;
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
  final TaskLocalControleer freq = Get.put(TaskLocalControleer());

  //counter //is this code needed
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];
  bool x = false;
  List<String> tasksNamedropmenue = [];
  List<String> selected = [];
  String? isSelected = "";
  late String taskName;
  @override
  void initState() {
    super.initState();
  }

  addTheEnterdTask(LocalTask newTask, List<String> enteredTasks) async {
    List<String> tasks = enteredTasks;
    await Future.forEach(tasks, (item) async {
      LocalTask? y = LocalTask(userID: IsarService.getUserID);
      String name = item;

      y = await widget.isr.findSepecificTask(name);
      newTask.taskDependency.add(y!); // to link task and it depends tasks ;
    });

    widget.isr.saveTask(newTask);
  }

  final _addTaskFormKey = GlobalKey<FormState>(
      debugLabel: 'AddTaskFormKey-${UniqueKey().toString()}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF66BF77),
        title: const Text(
          "إضافة مهمة جديدة",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () {
                freq.selectedTasks.value.clear();
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
                      tasksNamedropmenue.add(name); //this might not been used
                      String diplayedduration = "";
                      switch (durationDescription) {
                        case "أيام":
                          if (impo == 1) {
                            diplayedduration = " يوم  ";
                          } else if (impo == 2) {
                            diplayedduration = " يومان";
                          } else {
                            diplayedduration = "$impo  $durationDescription";
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
                              child:
                                  Icon(Icons.delete, color: Colors.grey[500]),
                              onPressed: () async {
                                final action = await AlertDialogs.yesCancelDialog(
                                    context,
                                    ' هل انت متاكد من حذف هذه المهمة  ',
                                    'بالنقر على "تاكيد"لن تتمكن من استرجاع المهمة ');
                                if (action == DialogsAction.yes) {
                                  bool isDependent =
                                      false; // prevent the user from deleting any task the depends by other tasks
                                  for (int i = 0;
                                      i < freq.goalTask.value.length;
                                      i++) {
                                    log("in here");
                                    log(freq.goalTask.value[i].taskDependency
                                        .toList()
                                        .length
                                        .toString());

                                    freq.goalTask.value[i].taskDependency
                                        .toList()
                                        .forEach((element) {
                                      log(element.id.toString());
                                      log(freq.goalTask.value[index].id
                                          .toString());
                                      if (element.id ==
                                          freq.goalTask.value[index].id) {
                                        isDependent = true;
                                        log("here");
                                      }
                                    });
                                  }

                                  for (int i = 0;
                                      i < freq.goalTask.value.length;
                                      i++) {
                                    List<TaskData> x =
                                        freq.allTaskForDepency.value;

                                    for (int j = 0; j < x.length; j++) {
                                      List<String> dependencies =
                                          x[i].taskDependency;
                                      for (int k = 0;
                                          k < dependencies.length;
                                          k++) {
                                        if (dependencies[k] ==
                                            freq.goalTask.value[index].name) {
                                          isDependent = true;
                                          break;
                                        }
                                      }
                                    }
                                  }
                                  if (isDependent) {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 1),
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 196, 48, 37),
                                              content: Row(
                                                children: const [
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 20),
                                                  Expanded(
                                                    child: Text(
                                                        "لا يمكن حذف هذه المهمة  "),
                                                  )
                                                ],
                                              )));
                                    }
                                  } else {
                                    int x = freq.goalTask.value[index].duration;
                                    freq.dcrementTaskDuration(x);
                                    for (int i = 0;
                                        i < freq.tasksMenue.value.length;
                                        i++) {
                                      // delete the deleted task from the menue
                                      if (freq.tasksMenue.value[i] ==
                                          freq.goalTask.value[index].name) {
                                        freq.tasksMenue.value.removeAt(i);
                                        break;
                                      }
                                    }
                                    widget.isr
                                        .deleteTask(freq.goalTask.value[index]);

                                    setState(() {
                                      freq.removeTask(index);
                                    });
                                  }
                                }
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 252, 252, 252),
          child: const Icon(Icons.add, color: Color(0xFF66BF77)),
          onPressed: () {
            freq.selectedTasks.value.clear();
            freq.inputTaskName.text = "";
            freq.taskDuration.value = 0;
            freq.isSelected.value = "أيام";
            freq.currentTaskDuration.value = 0;

            freq.setvalue(durationName[0]);

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(
                        " مهمة جديدة",
                      ),
                      content: Form(
                        key: _addTaskFormKey,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          TextFormField(
                            validator: (value) {
                              bool repeated = false;
                              for (var i in freq.goalTask.value) {
                                if (i.name == value) {
                                  setState(() {
                                    repeated = true;
                                  });
                                }
                              }
                              if (value == null || value.isEmpty) {
                                return "من فضلك ادخل اسم المهمة";
                              } else if (repeated) {
                                return "يوجد مهمة بنفس الاسم";
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
                                      if (freq.taskDuration.toInt() != 0) {
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
                                    freq.taskDuration.toString(),
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

                                    if (freq.taskDuration.toInt() == 0) {
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
                                        if (value!.contains(durationName[0])) {
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
                            height: 20,
                          ),
                          DropDownMultiSelect(
                            options: freq.tasksMenue.value,
                            //need to be righted
                            decoration: const InputDecoration(
                              labelText: "تعتمد على المهام :",
                              prefixIcon: Icon(
                                Icons.splitscreen,
                                color: Color(0xFF66BF77),
                              ),
                            ),
                            onChanged: (value) {
                              freq.selectedTasks.value = value;
                              //here you can save the tasks and link it
                            },
                            selectedValues: freq.selectedTasks.value,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Obx(() => ElevatedButton(
                                onPressed: freq.iscool.value
                                    ? () {
                                        if (_addTaskFormKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            // tasksNamedropmenue.add(inputTaskName.text);

                                            LocalTask newTak = LocalTask(
                                                userID: IsarService.getUserID);
                                            newTak.name =
                                                freq.inputTaskName.value.text;
                                            String durationDescribtion = "";
                                            switch (freq.isSelected.value) {
                                              case "أيام":
                                                newTak.duration =
                                                    freq.taskDuration.value;
                                                durationDescribtion = "أيام";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;
                                                break;
                                              case "أسابيع":
                                                newTak.duration =
                                                    (freq.taskDuration.value *
                                                        7);
                                                durationDescribtion = "أسابيع";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                              case "أشهر":
                                                newTak.duration =
                                                    (freq.taskDuration.value *
                                                        30);
                                                durationDescribtion = "أشهر";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                              case "سنوات":
                                                newTak.duration =
                                                    (freq.taskDuration.value *
                                                        360);
                                                durationDescribtion = "سنوات ";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                            }

                                            addTheEnterdTask(newTak,
                                                freq.selectedTasks.value);
                                            freq.tasksMenue.value.add(
                                                freq.inputTaskName.value.text);
                                            setState(() {
                                              x = freq.addTask(
                                                  freq.inputTaskName.value.text,
                                                  freq.isSelected.value,
                                                  freq.taskDuration.value);
                                            }); //ad the enterd to the tasks to the dependncy tasks .

                                            freq.taskDuration.value = 0;

                                            freq.storeStatusOpen(false);
                                            freq.incrementTaskDuration();
                                            freq.currentTaskDuration.value = 0;

                                            freq.setvalue(durationName[0]);
                                          });
                                          if (x) {
                                            Navigator.pop(context);
                                          }
                                        }
                                      }
                                    : null,
                                child: const Text("اضافة"),
                              ))
                        ])),
                      ));
                });
          }),
    );
  }

  bool boolvalid = true;
}
