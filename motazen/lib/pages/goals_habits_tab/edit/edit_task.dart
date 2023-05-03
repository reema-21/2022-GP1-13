// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:motazen/entities/local_task.dart';
import 'package:motazen/models/task_model.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/controllers/localtask_controller.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:multiselect/multiselect.dart';
import '../../../../entities/goal.dart';

class EditTask extends StatefulWidget {
  final IsarService isr;
  final int goalDurtion;
  List<LocalTask> goalTask;
  final int id;
  EditTask(
      {super.key,
      required this.isr,
      required this.goalDurtion,
      required this.goalTask,
      required this.id});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TaskLocalControleer freq = Get.put(TaskLocalControleer());
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];

  TextEditingController inputTaskName = TextEditingController();
  String? isSelected = "";
  late String taskName;
  late int taskduration;
  late int totalDurtion;
  late int currentTaskduraions;
  late String selectedtype;
  bool x = false;

  //the main goal is to make the list in the controoler == to the goal list
  @override
  void initState() {
    getTasks().then((value) {
// this value already have the dependencies in it
      freq.assignTasks(value);
      int totalSummation =
          0; //to know that is the total duration we have up now
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          totalSummation = totalSummation + value[i].duration;
        }
      }
      totalDurtion = totalSummation; // total of occupied duration untill now
//values if the user wants to add task
      getDepenendyTasks();

      inputTaskName.addListener(_updateText);
    });

    super.initState();
  }

  void getDepenendyTasks() async {
    for (var i in freq.goalTask.value) {
      // create the array for the alldependncy
      //create the object
      //fetch the tasks so that you can get its dependency
      //assign value and add to the list
      LocalTask? tem = LocalTask(userID: IsarService.getUserID);
      TaskData task = TaskData();
      tem = await widget.isr.findSepecificTaskByID(i.id);
      if (tem != null) {
        task.name = tem.name;

        for (var j in tem.taskDependency.toList()) {
          task.taskDependency.add(j.name);
        }
        freq.allTaskForDepency.value.add(task);
      }
    }
  }

  Future<List<LocalTask>> getTasks() async {
    Goal? goal = Goal(userID: IsarService.getUserID);
    goal = await widget.isr.getSepecificGoall(widget.id);
    return goal!.task.toList();
  }

  void _updateText() {
    setState(() {
      taskName = inputTaskName.text;
    });
  }

  LocalTask? task = LocalTask(userID: IsarService.getUserID);
  updateTask(LocalTask updateTask, List<String> tasks, int index) async {
    task = await widget.isr.findSepecificTaskByID(updateTask.id);

    //taskDependency is my IsarLinks
    task!.name = updateTask.name;
    task!.duration = updateTask.duration;
    task!.durationDescribtion = updateTask.durationDescribtion;
    // to clear the previos dependcey of a task
    // i will check if the task have any dependy that is not in the current selected one i will delete and then add it again .
    //you migh need to link it to the goal .

    List<LocalTask> currentDependy = task!.taskDependency.toList();
    currentDependy = task!.taskDependency.toList();
    if (freq.selectedTasks.value.isEmpty) {
      for (var i in currentDependy) {
        widget.isr.deleteTaskByIdSync(i.id);

        widget.isr.saveTask(i);
      }
    } else {
      bool isDeleted = true;
      // this part down is for add more to the isarLink and it works
      for (int i = 0; i < currentDependy.length; i++) {
        isDeleted = true;

        for (int j = 0; j < tasks.length; j++) {
          if (currentDependy[i].name == tasks[j]) {
            isDeleted = false;
            break;
          }

          if (isDeleted) {
            widget.isr.deleteTaskByIdSync(currentDependy[i].id);
            widget.isr.saveTask(currentDependy[i]);
            return true;
          }
        }
      }
      await Future.forEach(tasks, (item) async {
        LocalTask? y = LocalTask(userID: IsarService.getUserID);
        String name = item;

        y = await widget.isr.findSepecificTask(name);
        task!.taskDependency.add(y!); // to link task and it depends tasks ;
      });
    }

// i will try a new short one  .

    widget.isr.saveTask(task!);
  }

  addTheEnterdTask(LocalTask newTask, List<String> enteredTasks) async {
    //you should 1- store the task 2- link the task to the goal ans the goal to the task

    List<String> tasks = [];
    for (int i = 0; i < freq.selectedTasks.value.length; i++) {
      tasks.add(freq.selectedTasks.value[i]);
    }
    await Future.forEach(tasks, (item) async {
      LocalTask? y = LocalTask(userID: IsarService.getUserID);
      String name = item;

      y = await widget.isr.findSepecificTask(name);
      newTask.taskDependency.add(y!); // to link task and it depends tasks ;
    });

    List<LocalTask> t = newTask.taskDependency.toList();

    await Future.forEach(t, (item) async {
      task!.taskDependency.remove(item);
    });
    widget.isr.saveTask(newTask);
    Goal? goal = Goal(userID: IsarService.getUserID);
    goal = await widget.isr.getSepecificGoall(widget.id);
    goal!.task.add(newTask);
    widget.isr.createGoal(goal);
    newTask.goal.value = goal;
    widget.isr.saveTask(newTask);

    getTasks().then((value) {
      //regive the freq.goal ta
      freq.assignTasks(value);
      int totalSummation =
          0; //to know that is the total duration we have up now
      if (value.isNotEmpty) {
        for (int i = 0; i < value.length; i++) {
          totalSummation = totalSummation + value[i].duration;
        }
      }
      totalDurtion = totalSummation; // total of occupied duration untill now
//values if the user wants to add task
      inputTaskName.addListener(_updateText);
    });
  }

  final _editTaskFormKey = GlobalKey<FormState>(
      debugLabel: 'editTaskFormKey-${UniqueKey().toString()}');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF66BF77),
        title: const Text(
          "تعديل معلومات المهام",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
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
                  child: Obx(
                    () => ListView.builder(
                        itemCount: freq.itemCount.value,
                        itemBuilder: (context, index) {
                          final name = freq.goalTask.value[index].name;
                          final impo = freq.goalTask.value[index].duration;
                          final durationDescription =
                              freq.goalTask.value[index].durationDescribtion;

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
                                leading: IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Color(0xFF66BF77)),
                                    onPressed: () {
                                      //------------------------------------i might need to assign the value in here -------------------//
                                      freq.storeStatusOpen(true);

                                      selectedtype = freq.goalTask.value[index]
                                          .durationDescribtion;
                                      currentTaskduraions =
                                          freq.goalTask.value[index].duration;
                                      List<LocalTask> dependency = freq
                                          .goalTask.value[index].taskDependency
                                          .toList();
                                      for (int i = 0;
                                          i < dependency.length;
                                          i++) {
                                        freq.selectedTasks.value
                                            .add(dependency[i].name);
                                      }

                                      switch (selectedtype) {
                                        case "أيام":
                                          taskduration = freq
                                              .goalTask.value[index].duration;
                                          break;
                                        case "أسابيع":
                                          taskduration = freq.goalTask
                                                  .value[index].duration ~/
                                              7;
                                          break;
                                        case "أشهر":
                                          taskduration = freq.goalTask
                                                  .value[index].duration ~/
                                              30;

                                          break;
                                        case "سنوات":
                                          taskduration = freq.goalTask
                                                  .value[index].duration ~/
                                              360;
                                          break;
                                      }

                                      freq.setInitionals(taskduration, 0,
                                          totalDurtion, selectedtype);
                                      setState(() {
                                        freq.inputTaskName.text =
                                            freq.goalTask.value[index].name;
                                        freq.tasksMenue.value.clear();
                                        for (int i = 0;
                                            i < freq.goalTask.value.length;
                                            i++) {
                                          if (i == index) {
                                            continue;
                                          }
                                          freq.tasksMenue.value
                                              .add(freq.goalTask.value[i].name);
                                        }
                                        freq.selectedTasks.value.clear();
                                        List<LocalTask> dependency = freq
                                            .goalTask
                                            .value[index]
                                            .taskDependency
                                            .toList();
                                        for (int i = 0;
                                            i < dependency.length;
                                            i++) {
                                          freq.selectedTasks.value
                                              .add(dependency[i].name);
                                        }
                                      });
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text(
                                                  "تعديل المهمة",
                                                ),
                                                content: Form(
                                                  key: _editTaskFormKey,
                                                  child: SingleChildScrollView(
                                                      child: Column(children: [
                                                    TextFormField(
                                                      validator: (value) {
                                                        bool repeated = false;
                                                        for (int i = index + 1;
                                                            i <
                                                                freq
                                                                    .goalTask
                                                                    .value
                                                                    .length;
                                                            i++) {
                                                          if (freq
                                                                  .goalTask
                                                                  .value[i]
                                                                  .name ==
                                                              value) {
                                                            setState(() {
                                                              repeated = true;
                                                            });
                                                          }
                                                        }
                                                        for (int i = 0;
                                                            i < index;
                                                            i++) {
                                                          if (freq
                                                                  .goalTask
                                                                  .value[i]
                                                                  .name ==
                                                              value) {
                                                            setState(() {
                                                              repeated = true;
                                                            });
                                                          }
                                                        }

                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return "من فضلك ادخل اسم المهمة";
                                                        } else if (repeated) {
                                                          return "يوجد مهمة بنفس الاسم";
                                                        } else {
                                                          return null;
                                                        }
                                                      },
                                                      controller:
                                                          freq.inputTaskName,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: "اسم المهمة",
                                                        prefixIcon: Icon(
                                                          Icons
                                                              .verified_user_outlined,
                                                          color:
                                                              Color(0xFF66BF77),
                                                        ),
                                                        border:
                                                            OutlineInputBorder(),
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
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: const Color(
                                                                0xFF66BF77),
                                                          ),
                                                          child: Center(
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              onPressed: () {
                                                                freq.increment(
                                                                    widget
                                                                        .goalDurtion);
                                                                if (freq.taskDuration
                                                                        .toInt() !=
                                                                    0) {
                                                                  freq.storeStatusOpen(
                                                                      true);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Obx((() => Text(
                                                              freq.taskDuration
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          20),
                                                            ))),
                                                        const SizedBox(
                                                            width: 10),
                                                        Container(
                                                          width: 30,
                                                          height: 30,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: const Color(
                                                                0xFF66BF77),
                                                          ),
                                                          child: IconButton(
                                                            icon: const Icon(
                                                                Icons.remove,
                                                                color: Colors
                                                                    .white,
                                                                size: 15),
                                                            onPressed: () {
                                                              freq.dcrement();
                                                              freq.storeStatusOpen(
                                                                  true);

                                                              if (freq.taskDuration
                                                                      .toInt() ==
                                                                  0) {
                                                                freq.storeStatusOpen(
                                                                    false);
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        Obx(
                                                          () => DropdownButton(
                                                            //changes
                                                            value: freq
                                                                .isSelected
                                                                .value,

                                                            items: durationName
                                                                .map((e) =>
                                                                    DropdownMenuItem(
                                                                      value: e,
                                                                      child:
                                                                          Text(
                                                                              e),
                                                                    ))
                                                                .toList(),
                                                            onChanged: (value) {
                                                              setState(() {
                                                                isSelected =
                                                                    value;
                                                                for (int i = 0;
                                                                    i <
                                                                        durationName
                                                                            .length;
                                                                    i++) {
                                                                  if (value!.contains(
                                                                      durationName[
                                                                          0])) {
                                                                    freq.setvalue(
                                                                        durationName[
                                                                            0]);
                                                                  } else if (value
                                                                      .contains(
                                                                          durationName[
                                                                              1])) {
                                                                    freq.setvalue(
                                                                        durationName[
                                                                            1]);
                                                                  } else if (value
                                                                      .contains(
                                                                          durationName[
                                                                              2])) {
                                                                    freq.setvalue(
                                                                        durationName[
                                                                            2]);
                                                                  } else {
                                                                    freq.setvalue(
                                                                        durationName[
                                                                            3]);
                                                                  }
                                                                }

                                                                switch (freq
                                                                    .isSelected
                                                                    .value) {
                                                                  case "أيام":
                                                                    freq.setdefult();
                                                                    freq.storeStatusOpen(
                                                                        false);

                                                                    break;
                                                                  case "أسابيع":
                                                                    freq.setdefult();
                                                                    freq.storeStatusOpen(
                                                                        false);

                                                                    break;
                                                                  case "أشهر":
                                                                    freq.setdefult();
                                                                    freq.storeStatusOpen(
                                                                        false);

                                                                    break;
                                                                  case "سنوات":
                                                                    freq.storeStatusOpen(
                                                                        false);

                                                                    freq.setdefult();

                                                                    break;
                                                                }
                                                              });
                                                            },
                                                            icon: const Icon(
                                                              Icons
                                                                  .arrow_drop_down_circle,
                                                              color: Color(
                                                                  0xFF66BF77),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    DropDownMultiSelect(
                                                      options:
                                                          freq.tasksMenue.value,
                                                      //need to be righted
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            "تعتمد على  المهام:",
                                                        prefixIcon: Icon(
                                                          Icons.splitscreen,
                                                          color:
                                                              Color(0xFF66BF77),
                                                        ),
                                                      ),
                                                      onChanged: (value) {
                                                        freq.selectedTasks
                                                            .value = value;
                                                        //here you can save the tasks and link it
                                                      },
                                                      selectedValues: freq
                                                          .selectedTasks.value,
                                                    ),
                                                    const SizedBox(
                                                      height: 30,
                                                    ),
                                                    Obx(() => ElevatedButton(
                                                          // there was this line to make sure that a change in the duration happend
                                                          onPressed:
                                                              freq.iscool.value
                                                                  ? () {
                                                                      if (_editTaskFormKey
                                                                          .currentState!
                                                                          .validate()) {
                                                                        setState(
                                                                            () {
                                                                          freq
                                                                              .goalTask
                                                                              .value[index]
                                                                              .taskDependency
                                                                              .clear(); // add the dependednt task

                                                                          for (int i = 0;
                                                                              i < freq.selectedTasks.value.length;
                                                                              i++) {
                                                                            for (int j = 0;
                                                                                j < freq.goalTask.value.length;
                                                                                j++) {
                                                                              if (freq.goalTask.value[j].name == freq.selectedTasks.value[i]) {
                                                                                freq.goalTask.value[index].taskDependency.add(freq.goalTask.value[j]);
                                                                              }
                                                                            }
                                                                          }

                                                                          freq.goalTask.value[index].name = freq
                                                                              .inputTaskName
                                                                              .value
                                                                              .text;

                                                                          freq.allTaskForDepency.value[index].name = freq
                                                                              .inputTaskName
                                                                              .value
                                                                              .text; // this for editing the all if it is changed
                                                                          //----------------- you should adjust the dependny also ---------------//

                                                                          freq
                                                                              .allTaskForDepency
                                                                              .value[index]
                                                                              .taskDependency = [];
                                                                          for (var i in freq
                                                                              .selectedTasks
                                                                              .value) {
                                                                            freq.allTaskForDepency.value[index].taskDependency.add(i);
                                                                          }

                                                                          //-----the above part  is ajesting the depencies for the dleteion part -----//

                                                                          String
                                                                              durationDescribtion =
                                                                              "";
                                                                          switch (freq
                                                                              .isSelected
                                                                              .value) {
                                                                            case "أيام":
                                                                              freq.goalTask.value[index].duration = freq.taskDuration.value;
                                                                              durationDescribtion = "أيام";
                                                                              freq.goalTask.value[index].durationDescribtion = durationDescribtion;
                                                                              break;
                                                                            case "أسابيع":
                                                                              freq.goalTask.value[index].duration = (freq.taskDuration.value * 7);
                                                                              durationDescribtion = "أسابيع";
                                                                              freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                              break;
                                                                            case "أشهر":
                                                                              freq.goalTask.value[index].duration = (freq.taskDuration.value * 30);
                                                                              durationDescribtion = "أشهر";
                                                                              freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                              break;
                                                                            case "سنوات":
                                                                              freq.goalTask.value[index].duration = (freq.taskDuration.value * 360);
                                                                              durationDescribtion = "سنوات ";
                                                                              freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                              break;
                                                                          }
                                                                          List<String>
                                                                              tasks =
                                                                              [];
                                                                          for (int i = 0;
                                                                              i < freq.selectedTasks.value.length;
                                                                              i++) {
                                                                            tasks.add(freq.selectedTasks.value[i]);
                                                                          }
                                                                          setState(
                                                                              () {
                                                                            x = true;
                                                                          });

                                                                          updateTask(
                                                                              freq.goalTask.value[index],
                                                                              tasks,
                                                                              index);
                                                                          freq.editedTasksInEditing
                                                                              .value
                                                                              .add(freq.goalTask.value[index]);
                                                                          freq.taskDuration.value =
                                                                              0;

                                                                          freq.storeStatusOpen(
                                                                              false);
                                                                          freq.storeStatusEditi(
                                                                              true); //to know what to do with the total of the duration after editing the task
                                                                          freq.incrementTaskDuration();
                                                                          freq.storeStatusEditi(
                                                                              false); //to know what to do with the total of the duration after editing the task

                                                                          freq.currentTaskDuration.value =
                                                                              0;

                                                                          freq.setvalue(
                                                                              durationName[0]);
                                                                        });
                                                                      }
                                                                      if (x) {
                                                                        x = false;

                                                                        Navigator.pop(
                                                                            context);
                                                                      }
                                                                    }
                                                                  : null,
                                                          child: const Text(
                                                              "حفظ التعديلات"),
                                                        ))
                                                  ])),
                                                ));
                                          });
                                    }),

                                trailing: TextButton(
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.grey[500],
                                    ),
                                    onPressed: () async {
                                      final action =
                                          await AlertDialogs.yesCancelDialog(
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
                                                x[i].taskDependency;
                                            for (int k = 0;
                                                k < dependencies.length;
                                                k++) {
                                              if (dependencies[k] ==
                                                  freq.goalTask.value[index]
                                                      .name) {
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
                                                    duration: const Duration(
                                                        seconds: 1),
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
                                          int x = freq
                                              .goalTask.value[index].duration;
                                          freq.dcrementTaskDuration(x);

                                          bool oldTask = false;
                                          for (int i = 0;
                                              i < widget.goalTask.length;
                                              i++) {
                                            if (widget.goalTask[i].name ==
                                                freq.goalTask.value[index]
                                                    .name) {
                                              oldTask = true;
                                              break;
                                            }
                                          }
                                          if (oldTask) {
                                            widget.isr.deleteTaskByIdAsync(
                                                freq.goalTask.value[index]);
                                          } else {
                                            widget.isr.deleteTask(
                                                freq.goalTask.value[index]);
                                          }

                                          //here i am try to collect all the deleted tasks so that i can take it back if the users did cancle the chenges
                                          freq.deletedTasks.value
                                              .add(freq.goalTask.value[index]);
                                          //if error or sth you might need to update the count of the array

                                          setState(() {
                                            freq.removeTask(index);
                                            totalDurtion = totalDurtion -
                                                x; //adddedddddddddddddddddddddddddd
                                          });
                                        }
                                      }
                                    }),

                                // if not null added
                                title: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(name),
                                ),
                                subtitle: Text(" الفترة :$diplayedduration"),
                              ));
                        }),
                  ))),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color.fromARGB(255, 252, 252, 252),
          onPressed: () {
            setState(() {
              freq.inputTaskName.text = "";
              freq.selectedTasks.value.clear();
              freq.tasksMenue.value.clear();

              for (int i = 0; i < freq.goalTask.value.length; i++) {
                freq.tasksMenue.value.add(freq.goalTask.value[i].name);
              }
            });
            freq.setInitionals(0, 0, totalDurtion, durationName[0]);
            showDialog(
                barrierDismissible: true,
                context: context,
                builder: (BuildContext context) {
                  if (freq.taskDuration.toInt() == 0) {
                    freq.storeStatusOpen(false);
                  }
                  return AlertDialog(
                      title: const Text(
                        " مهمة جديدة",
                      ),
                      content: Form(
                        key: _editTaskFormKey,
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
                                        if (_editTaskFormKey.currentState!
                                            .validate()) {
                                          setState(() {
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
                                            freq.tasksMenue.value.clear();
                                            freq.selectedTasks.value.clear();
                                            freq.setvalue(durationName[0]);
                                            freq.selectedTasks.value.clear();
                                          });
                                        }
                                        if (x) {
                                          x = false;
                                          Navigator.pop(context);
                                        }
                                      }
                                    : null,
                                child: const Text("اضافة"),
                              ))
                        ])),
                      ));
                });
          },
          child: const Icon(Icons.add, color: Color(0xFF66BF77))),
    );
  }

  bool boolvalid = true;
}
