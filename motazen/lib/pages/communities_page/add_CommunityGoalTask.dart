// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names, unused_element, unused_local_variable, use_build_context_synchronously, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/pages/add_goal_page/taskLocal_controller.dart';
import 'package:multiselect/multiselect.dart';
import '../assesment_page/alert_dialog.dart';
import '../goals_habits_tab/taskClass.dart';

class AddCommunityGoalTask extends StatefulWidget {
  int goalDurtion;
  List<LocalTask> goalTask;
  AddCommunityGoalTask(
      {super.key, required this.goalDurtion, required this.goalTask});

  @override
  State<AddCommunityGoalTask> createState() => _AddCommunityGoalTask();
}

class _AddCommunityGoalTask extends State<AddCommunityGoalTask> {
  //counter
  final TaskLocalControleer freq = Get.put(TaskLocalControleer());

  //counter
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];
  bool x = false;
  List<String> TasksNamedropmenue = [];
  List<String> selected = [];
  String? isSelected = "";
  late String TaskName;
  @override
  void initState() {
    super.initState();
  }

  AddTheEnterdTask(LocalTask newTask, List<String> tasks) async {
    List<String> Taskss = tasks;
    await Future.forEach(Taskss, (item) async {
      LocalTask? y = LocalTask();
      String name = item;

      newTask.TaskDependency.add(y); // to link task and it depends tasks ;
      // widget.isr.saveTask(y);// to link
    });
  }

  final formKey = GlobalKey<FormState>();

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
              // ignore: prefer_const_constructors
              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                      TasksNamedropmenue.add(name); //this might not been used
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
                              child: const Icon(Icons.delete),
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
                                    List<TaskData> x =
                                        freq.allTaskForDepency.value;

                                    for (int j = 0; j < x.length; j++) {
                                      List<String> dependencies =
                                          x[i].TaskDependency;
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
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
                                  } else {
                                    int x = freq.goalTask.value[index].duration;
                                    freq.dcrementTaskDuration(x);
                                    for (int i = 0;
                                        i < freq.TasksMenue.value.length;
                                        i++) {
                                      // delete the deleted task from the menue
                                      if (freq.TasksMenue.value[i] ==
                                          freq.goalTask.value[index].name) {
                                        freq.TasksMenue.value.removeAt(i);
                                        break;
                                      }
                                    }

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
            for (var i in freq.allTaskForDepency.value) {}
            freq.selectedTasks.value.clear();
            freq.inputTaskName.text = "";
            freq.TaskDuration.value = 0;
            freq.isSelected.value = "أيام";
            freq.currentTaskDuration.value = 0;

            freq.setvalue(durationName[0]);

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text(
                        " مهمة جديدة",
                        textDirection: TextDirection.rtl,
                      ),
                      content: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          TextFormField(
                            validator: (value) {
                              bool Repeated = false;
                              for (var i in freq.goalTask.value) {
                                if (i.name == value) {
                                  setState(() {
                                    Repeated = true;
                                  });
                                }
                              }
                              if (value == null || value.isEmpty) {
                                return "من فضلك ادخل اسم المهمة";
                              } else if (Repeated) {
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
                            options: freq.TasksMenue.value,
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
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            // TasksNamedropmenue.add(inputTaskName.text);

                                            LocalTask newTak = LocalTask();
                                            newTak.name =
                                                freq.inputTaskName.value.text;
                                            String durationDescribtion = "";
                                            switch (freq.isSelected.value) {
                                              case "أيام":
                                                newTak.duration =
                                                    freq.TaskDuration.value;
                                                durationDescribtion = "أيام";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;
                                                break;
                                              case "أسابيع":
                                                newTak.duration =
                                                    (freq.TaskDuration.value *
                                                        7);
                                                durationDescribtion = "أسابيع";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                              case "أشهر":
                                                newTak.duration =
                                                    (freq.TaskDuration.value *
                                                        30);
                                                durationDescribtion = "أشهر";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                              case "سنوات":
                                                newTak.duration =
                                                    (freq.TaskDuration.value *
                                                        360);
                                                durationDescribtion = "سنوات ";
                                                newTak.durationDescribtion =
                                                    durationDescribtion;

                                                break;
                                            }

                                            AddTheEnterdTask(newTak,
                                                freq.selectedTasks.value);
                                            freq.TasksMenue.value.add(
                                                freq.inputTaskName.value.text);
                                            setState(() {
                                              x = freq.addTask(
                                                  freq.inputTaskName.value.text,
                                                  freq.isSelected.value,
                                                  freq.TaskDuration.value);
                                            }); //ad the enterd to the tasks to the dependncy tasks .

                                            freq.TaskDuration.value = 0;

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
