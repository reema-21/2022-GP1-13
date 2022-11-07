import 'package:flutter/material.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';

import '../assesment_page/alert_dialog.dart';

class EditTask extends StatefulWidget {
  final IsarService isr;
  final int goalDurtion;
  List<Task> goalTask;
  EditTask(
      {super.key,
      required this.isr,
      required this.goalDurtion,
      required this.goalTask});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TaskControleer freq = Get.put(TaskControleer());
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];
  num goalduration = 32;
  TextEditingController inputTaskName = TextEditingController();
  String? isSelected = "";
  late String TaskName;
  late int taskduration;
  late int totalDurtion;
  late int currentTaskduraions;
  late String selectedtype;

  void initState() {
    super.initState();
    int totalSummation = 0;
    for (int i = 0; i < widget.goalTask.length; i++) {
      totalSummation = totalSummation + widget.goalTask[i].duration;
    }
    totalDurtion = totalSummation;

    freq.AssignTaks(widget.goalTask);

    //values if the user wants to add task
    inputTaskName.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      TaskName = inputTaskName.text;
    });
  }

  Task? task = Task();
  UpdateTask(Task UpdateTask) async {
    task = await widget.isr.getSepecificTask(UpdateTask.id);
    task!.name = UpdateTask.name;
    task!.duration = UpdateTask.duration;
    task!.durationDescribtion = UpdateTask.durationDescribtion;
    widget.isr.saveTask(task!);
  }

  AddTheEnterdTask(Task newTask) async {
    widget.isr.saveTask(newTask);
  }

  @override
  final formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF66BF77),
            title: const Text(
              "تعديل معلومات الهدف",
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
                      padding: EdgeInsets.all(8.0),
                      child: Obx(
                        () => ListView.builder(
                            itemCount: freq.itemCount.value,
                            itemBuilder: (context, index) {
                              final goal = freq.goalTask.value[index];
                              final name = freq.goalTask.value[index].name;
                              final impo = freq.goalTask.value[index].duration;
                              final durationDescription = freq
                                  .goalTask.value[index].durationDescribtion;

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
                                    diplayedduration =
                                        "$y $durationDescription";
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
                                    diplayedduration =
                                        "$y $durationDescription";
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
                                    diplayedduration =
                                        "$y $durationDescription";
                                  }

                                  break;
                              }

                              return Card(
                                  elevation: 3,
                                  // here is the code of each item you have
                                  child: ListTile(
                                    leading: IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          int number = 1;

                                          selectedtype = freq.goalTask
                                              .value[index].durationDescribtion;
                                          currentTaskduraions = freq
                                              .goalTask.value[index].duration;
                                          switch (selectedtype) {
                                            case "أيام":
                                              taskduration = freq.goalTask
                                                  .value[index].duration;
                                              //  print("here is the info");
                                              //  print(currentTaskduraions);
                                              //  print(selectedtype);
                                              //  print(totalDurtion);
                                              //  print(taskduration);
                                              //  print ("end of the info ");

                                              break;
                                            case "أسابيع":
                                              taskduration = (freq
                                                          .goalTask
                                                          .value[index]
                                                          .duration /
                                                      7)
                                                  .toInt();
                                              //  print("here is the info");
                                              //                                        print(currentTaskduraions);
                                              //                                        print(selectedtype);
                                              //                                        print(totalDurtion);
                                              //                                        print(taskduration);
                                              //                                        print ("end of the info ");

                                              break;
                                            case "أشهر":
                                              taskduration = (freq
                                                          .goalTask
                                                          .value[index]
                                                          .duration /
                                                      30)
                                                  .toInt();

                                              print("here is the info");
                                              print(currentTaskduraions);
                                              print(selectedtype);
                                              print(totalDurtion);
                                              print(taskduration);
                                              print("end of the info ");
                                              break;
                                            case "سنوات":
                                              taskduration = (freq
                                                          .goalTask
                                                          .value[index]
                                                          .duration /
                                                      360)
                                                  .toInt();
                                              print("here is the info");
                                              print(currentTaskduraions);
                                              print(selectedtype);
                                              print(totalDurtion);
                                              print(taskduration);
                                              print("end of the info ");
                                              break;
                                          }

                                          freq.setInitionals(taskduration, 0,
                                              totalDurtion, selectedtype);
                                          setState(() {
                                            freq.inputTaskName.text =
                                                freq.goalTask.value[index].name;
                                          });
                                          showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                    title: Text(
                                                      "تعديل المهمة",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                    content: Directionality(
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      child: Form(
                                                        key: formKey,
                                                        child:
                                                            SingleChildScrollView(
                                                                child: Column(
                                                                    children: [
                                                              Container(
                                                                child:
                                                                    TextFormField(
                                                                  validator:
                                                                      (value) {
                                                                    if (value ==
                                                                            null ||
                                                                        value
                                                                            .isEmpty) {
                                                                      return "من فضلك ادخل اسم المهمة";
                                                                      // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                                                                      //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                                                                      // }
                                                                    } else {
                                                                      return null;
                                                                    }
                                                                  },
                                                                  controller: freq
                                                                      .inputTaskName,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    labelText:
                                                                        "اسم المهمة",
                                                                    prefixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .verified_user_outlined,
                                                                      color: Color(
                                                                          0xFF66BF77),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                      "الفترة"),
                                                                  const SizedBox(
                                                                    width: 15,
                                                                  ),
                                                                  Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      color: Color(
                                                                          0xFF66BF77),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          IconButton(
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .add,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          freq.increment(
                                                                              goalduration);
                                                                          if (freq.TaskDuration !=
                                                                              0) {
                                                                            freq.storeStatusOpen(true);
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Obx(
                                                                      (() =>
                                                                          Text(
                                                                            "${freq.TaskDuration.toString()}",
                                                                            style:
                                                                                TextStyle(fontSize: 20),
                                                                          ))),
                                                                  SizedBox(
                                                                      width:
                                                                          10),
                                                                  Container(
                                                                    width: 30,
                                                                    height: 30,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              25),
                                                                      color: Color(
                                                                          0xFF66BF77),
                                                                    ),
                                                                    child:
                                                                        IconButton(
                                                                      icon: Icon(
                                                                          Icons
                                                                              .remove,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              15),
                                                                      onPressed:
                                                                          () {
                                                                        freq.dcrement();
                                                                        freq.storeStatusOpen(
                                                                            true);

                                                                        if (freq.TaskDuration ==
                                                                            0) {
                                                                          freq.storeStatusOpen(
                                                                              false);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  Obx(
                                                                    () =>
                                                                        DropdownButton(
                                                                      //changes
                                                                      value: freq
                                                                          .isSelected
                                                                          .value,

                                                                      items: durationName
                                                                          .map((e) => DropdownMenuItem(
                                                                                value: e,
                                                                                child: Text(e),
                                                                              ))
                                                                          .toList(),
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          isSelected =
                                                                              value;
                                                                          for (int i = 0;
                                                                              i < durationName.length;
                                                                              i++) {
                                                                            if (value!.contains(durationName[0])) {
                                                                              freq.setvalue(durationName[0]);
                                                                            } else if (value!.contains(durationName[1])) {
                                                                              freq.setvalue(durationName[1]);
                                                                            } else if (value!.contains(durationName[2])) {
                                                                              freq.setvalue(durationName[2]);
                                                                            } else {
                                                                              freq.setvalue(durationName[3]);
                                                                            }
                                                                          }

                                                                          switch (freq
                                                                              .isSelected
                                                                              .value) {
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
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .arrow_drop_down_circle,
                                                                        color: Color(
                                                                            0xFF66BF77),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Container(
                                                                  child: Obx(() =>
                                                                      ElevatedButton(
                                                                        onPressed: freq.iscool.value
                                                                            ? () {
                                                                                print(freq.iscool.value);
                                                                                if (formKey.currentState!.validate()) {
                                                                                  setState(() {
                                                                                    Task newTak = Task();
                                                                                    newTak.name = freq.inputTaskName.value.text;
                                                                                    String durationDescribtion = "";
                                                                                    switch (freq.isSelected.value) {
                                                                                      case "أيام":
                                                                                        newTak.duration = freq.TaskDuration.value;
                                                                                        durationDescribtion = "أيام";
                                                                                        newTak.durationDescribtion = durationDescribtion;
                                                                                        break;
                                                                                      case "أسابيع":
                                                                                        newTak.duration = (freq.TaskDuration.value * 7);
                                                                                        durationDescribtion = "أسابيع";
                                                                                        newTak.durationDescribtion = durationDescribtion;

                                                                                        break;
                                                                                      case "أشهر":
                                                                                        newTak.duration = (freq.TaskDuration.value * 30);
                                                                                        durationDescribtion = "أشهر";
                                                                                        newTak.durationDescribtion = durationDescribtion;

                                                                                        break;
                                                                                      case "سنوات":
                                                                                        newTak.duration = (freq.TaskDuration.value * 360);
                                                                                        durationDescribtion = "سنوات ";
                                                                                        newTak.durationDescribtion = durationDescribtion;

                                                                                        break;
                                                                                    }

                                                                                    // TasksNamedropmenue.add(inputTaskName.text);
                                                                                    UpdateTask(newTak);
                                                                                    freq.TaskDuration.value = 0;

                                                                                    freq.storeStatusOpen(false);
                                                                                    freq.incrementTaskDuration();
                                                                                    freq.currentTaskDuration.value = 0;

                                                                                    freq.setvalue(durationName[0]);
                                                                                  });
                                                                                }
                                                                                Navigator.of(context).pop(true);
                                                                              }
                                                                            : null,
                                                                        child: const Text(
                                                                            "حفظ التعديلات"),
                                                                      )))
                                                            ])),
                                                      ),
                                                    ));
                                              });
                                        }),

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
                                              widget.goalTask[index].duration;
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
                                      child: Text("$name"),
                                    ),
                                    subtitle:
                                        Text(" الفترة :$diplayedduration"),
                                  ));
                            }),
                      ))),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                setState(() {
                  inputTaskName.text = "";
                });
                freq.setInitionals(0, 0, totalDurtion, durationName[0]);
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          " مهمه جديدة",
                          textDirection: TextDirection.rtl,
                        ),
                        content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                                child: Column(children: [
                              Container(
                                child: TextFormField(
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
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(children: [
                                Text("الفترة"),
                                const SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color(0xFF66BF77),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      onPressed: () {
                                        freq.increment(goalduration);
                                        if (freq.TaskDuration != 0) {
                                          freq.storeStatusOpen(true);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Obx((() => Text(
                                      "${freq.TaskDuration.toString()}",
                                      style: TextStyle(fontSize: 20),
                                    ))),
                                SizedBox(width: 10),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Color(0xFF66BF77),
                                  ),
                                  child: IconButton(
                                    icon: Icon(Icons.remove,
                                        color: Colors.white, size: 15),
                                    onPressed: () {
                                      freq.dcrement();
                                      if (freq.TaskDuration == 0) {
                                        freq.storeStatusOpen(false);
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
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
                                          } else if (value!
                                              .contains(durationName[1])) {
                                            freq.setvalue(durationName[1]);
                                          } else if (value!
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
                                      Icons.arrow_drop_down_circle,
                                      color: Color(0xFF66BF77),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ]),
                              Container(
                                  child: Obx(() => ElevatedButton(
                                        onPressed: freq.iscool.value
                                            ? () {
                                                print(freq.iscool.value);
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  setState(() {
                                                    Task newTak = Task();
                                                    newTak.name = freq
                                                        .inputTaskName
                                                        .value
                                                        .text;
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
                                                        freq.TaskDuration
                                                            .value);
                                                    // TasksNamedropmenue.add(inputTaskName.text);

                                                    freq.TaskDuration.value = 0;

                                                    freq.storeStatusOpen(false);
                                                    freq.incrementTaskDuration();
                                                    freq.currentTaskDuration
                                                        .value = 0;

                                                    freq.setvalue(
                                                        durationName[0]);
                                                    // TasksName.add(inputTaskName.text);
                                                    // print("i am at the prssed button after adding");
                                                    // print (TasksName);
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  });
                                                }
                                              }
                                            : null,
                                        child: const Text("اضافة"),
                                      ))),
                            ])),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }

  bool boolvalid = true;
}
