import 'package:flutter/material.dart';
import 'package:motazen/add_goal_page/task_controller.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import '../pages/assesment_page/aler2.dart';
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
  TextEditingController inputTaskName = TextEditingController();
  TextEditingController oneTaskduration = TextEditingController();
  String? isSelected = "";

  late String TaskName;
  void initState() {
    super.initState();

    inputTaskName.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      TaskName = inputTaskName.text;
    });
  }

  AddTheEnterdTask(int val, String duName) async {
    Task newTak = Task();
    newTak.name = inputTaskName.text;
    String durationDescribtion = "";
    switch (duName) {
      case "أيام":
        newTak.duration = val;
        durationDescribtion = "أيام";
        newTak.durationDescribtion = durationDescribtion;
        break;
      case "أسابيع":
        newTak.duration = (val * 7);
        durationDescribtion = "أسابيع";
        newTak.durationDescribtion = durationDescribtion;

        break;
      case "أشهر":
        newTak.duration = (val * 30);
        durationDescribtion = "أشهر";
        newTak.durationDescribtion = durationDescribtion;

        break;
      case "سنوات":
        newTak.duration = (val * 360);
        durationDescribtion = "سنوات $val";
        newTak.durationDescribtion = durationDescribtion;

        break;
    }

    inputTaskName.text = "";

    oneTaskduration.text = 0.toString();

    widget.isr.saveTask(newTak);
    setState(() {
      widget.goalTask.add(newTak);
    });
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
                padding: EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: widget.goalTask.length,
                    itemBuilder: (context, index) {
                      final goal = widget.goalTask[index];
                      final name = widget.goalTask[index].name;
                      final impo = widget.goalTask[index].duration;
                      final durationDescription =
                          widget.goalTask[index].durationDescribtion;
                      if (name != null) {
                        TasksNamedropmenue.add(name);
                      }
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
                                  int x = widget.goalTask[index].duration;
                                  freq.dcrementTaskDuration(x);
                                  widget.isr
                                      .deleteTask2(widget.goalTask[index]);
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
                            subtitle: Text(" الفترة :$diplayedduration"),
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
                          title: Text(
                            " مهمة جديدة",
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
                                Row(
                                  children: [
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
                                            freq.increment(widget.goalDurtion);
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
                                          freq.storeStatusOpen(true);

                                          if (freq.TaskDuration == 0) {
                                            freq.storeStatusOpen(false);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 20),
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

                                Container(
                                    child: Obx(() => ElevatedButton(
                                          onPressed: freq.iscool.value
                                              ? () {
                                                  print(freq.iscool.value);
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      // TasksNamedropmenue.add(inputTaskName.text);

                                                      AddTheEnterdTask(
                                                          freq.TaskDuration
                                                              .value,
                                                          freq.isSelected
                                                              .value);
                                                      freq.TaskDuration.value =
                                                          0;

                                                      freq.storeStatusOpen(
                                                          false);
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
                                        )))
                              ])),
                            ),
                          ));

                    });
              }),
        ),
      ),
    );
  }

  bool boolvalid = true;
}
