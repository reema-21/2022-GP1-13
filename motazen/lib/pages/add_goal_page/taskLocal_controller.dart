//ignore_for_file: non_constant_identifier_names, file_names, unused_local_variable

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/goals_habits_tab/taskClass.dart';

// create  a class called task
//the class have the same name property except having a list that
// when save in here save

class TaskLocalControleer extends GetxController {
  var checkTotalTaskDuration =
      0.obs; // to check whether the user Enterd a valid goal duration or not
  var TaskDuration = 0.obs;
  var currentTaskDuration = 0.obs;
  var totalTasksDuration = 0.obs;
  var iscool = false.obs;
  var tem = 0.obs;
  var isSelected = "أيام".obs;

  Rx<List<LocalTask>> goalTask =
      Rx<List<LocalTask>>([]); // for saving the task depenecy  .
  Rx<List<LocalTask>> newTasksAddedInEditing = Rx<List<LocalTask>>([]);
  Rx<List<LocalTask>> DeletedTasks = Rx<List<LocalTask>>([]);
  Rx<List<LocalTask>> EditedTasksInEditing = Rx<List<LocalTask>>([]);
  Rx<List<String>> TasksMenue = Rx<List<String>>([]);
  Rx<List<String>> selectedTasks = Rx<List<String>>([]);
  var selectedOption = "".obs;

  var isEdit = false
      .obs; // to know what to do with the total duration in case of editing

  late LocalTask task;
  var itemCount = 0.obs;
  var itemCountAdd = 0.obs;
  var itemCountDelete = 0.obs;
  var itemCountEdit = 0.obs;
  Rx<List<TaskData>> OrginalTasks = Rx<List<TaskData>>([]);

  Rx<List<TaskData>> allTaskForDepency = Rx<List<TaskData>>([]);
  Rx<TaskData> tryTask = Rx<TaskData>(TaskData());

  TextEditingController inputTaskName = TextEditingController();
  addEditTask(String name, String duName, int val) {
    LocalTask newTak = LocalTask(userID: IsarService.getUserID);
    newTak.name = name;
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
        durationDescribtion = "سنوات ";
        newTak.durationDescribtion = durationDescribtion;

        break;
    }

    newTasksAddedInEditing.value.add(newTak);
    itemCountAdd.value = goalTask.value.length;
    inputTaskName.clear();
  }

  bool addTask(String name, String duName, int val) {
    TaskData TaskForDependency = TaskData();
    TaskForDependency.name = name;
    //this is just to create the list to check for andy dependen to not delete .
    for (int i = 0; i < selectedTasks.value.length; i++) {
      TaskForDependency.TaskDependency.add(selectedTasks.value[i]);
    }

    allTaskForDepency.value.add(TaskForDependency);

    LocalTask newTak = LocalTask(userID: IsarService.getUserID);
    newTak.name = name;

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
        durationDescribtion = "سنوات ";
        newTak.durationDescribtion = durationDescribtion;

        break;
    }

    goalTask.value.add(newTak);
    itemCount.value = goalTask.value.length;
    inputTaskName.clear();

    return true;
  }

  removeTask(int index) {
    // i am suppose that they will have the same index
    allTaskForDepency.value.removeAt(index);

    for (var i in allTaskForDepency.value) {}

    goalTask.value.removeAt(index);
    itemCount.value = goalTask.value.length;
  }

  AssignTaks(List<LocalTask> currentGoalTask) {
    goalTask.value.clear();
    goalTask.value.addAll(currentGoalTask);

    itemCount.value = goalTask.value.length;
    //Assign the alldependency values ;
  }

  void setInitionals(int taskduration, int currentTaskduraions,
      int totalDurtion, String selectedType) {
    int totalSummation = 0;
    for (int i = 0; i < goalTask.value.length; i++) {
      totalSummation = totalSummation + goalTask.value[i].duration;
    }

    TaskDuration.value = taskduration;
    currentTaskDuration.value = currentTaskduraions;
    tem.value = totalDurtion;
    totalTasksDuration.value = totalDurtion;
    checkTotalTaskDuration.value = totalDurtion;
    isSelected.value = selectedType;
  }

  void storeStatusOpen(bool isOpen) {
    iscool(isOpen);
  }

  void storeStatusEditi(bool isOpen) {
    isEdit(isOpen);
  }

  setvalue(String x) {
    isSelected.value = x;
  }

  increment(num goalduration) {
    switch (isSelected.value) {
      case "أيام":
        currentTaskDuration.value = currentTaskDuration.value + 1;
        tem.value = tempIncrementTaskDuration();
        break;
      case "أسابيع":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 7);
        tem.value = tempIncrementTaskDuration();

        break;
      case "أشهر":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 30);
        tem.value = tempIncrementTaskDuration();

        break;
      case "سنوات":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 360);
        tem.value = tempIncrementTaskDuration();

        break;
    }

    if (tem > goalduration) {
      Get.snackbar(
          "", "لا يمكن زيادة الفترة ، فترة المهام ستصبح أعلى من فترة الهدف ",
          icon: const Icon(Icons.error),
          backgroundColor: const Color.fromARGB(255, 138, 36, 36),
          borderRadius: 0,
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 5),
          duration: const Duration(milliseconds: 1200),
          snackPosition: SnackPosition.BOTTOM);

      switch (isSelected.value) {
        case "أيام":
          currentTaskDuration.value = currentTaskDuration.value - 1;
          tem.value = tempIncrementTaskDuration();
          break;
        case "أسابيع":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 7);
          tem.value = tempIncrementTaskDuration();

          break;
        case "أشهر":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 30);
          tem.value = tempIncrementTaskDuration();

          break;
        case "سنوات":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 360);
          tem.value = tempIncrementTaskDuration();

          break;
      }
    } else if (currentTaskDuration.value > goalduration) {
      switch (isSelected.value) {
        case "أيام":
          currentTaskDuration.value = currentTaskDuration.value - 1;
          tem.value = tempIncrementTaskDuration();
          break;
        case "أسابيع":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 7);
          tem.value = tempIncrementTaskDuration();

          break;
        case "أشهر":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 30);
          tem.value = tempIncrementTaskDuration();

          break;
        case "سنوات":
          currentTaskDuration.value = currentTaskDuration.value - (1 * 360);
          tem.value = tempIncrementTaskDuration();

          break;
      }
      storeStatusOpen(false);

      /////////////////////////////////////////////////////////////////////////////////////////

      Get.snackbar(
          "", "لا يمكن زيادة الفترة ، فترة المهام ستصبح أعلى من فترة الهدف ",
          icon: const Icon(Icons.error),
          backgroundColor: const Color.fromARGB(255, 138, 36, 36),
          borderRadius: 0,
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 5),
          duration: const Duration(milliseconds: 1200),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      TaskDuration.value++;
    }
  }

  setdefult() {
    TaskDuration.value = 0;
    tem.value = tem.value - currentTaskDuration.value;
    currentTaskDuration.value = 0;
  }

  dcrement() {
    if (TaskDuration.value <= 0) {
      Get.snackbar("", "قيمة الفترة لا يمكن أن يكون أقل من واحد ",
          icon: const Icon(Icons.error),
          backgroundColor: const Color.fromARGB(255, 138, 36, 36),
          borderRadius: 0,
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 5),
          duration: const Duration(milliseconds: 1200),
          snackPosition: SnackPosition.BOTTOM);
    } else {
      TaskDuration.value--;

      switch (isSelected.value) {
        case "أيام":
          tem.value = tem.value - TaskDuration.value;
          currentTaskDuration.value = TaskDuration.value;

          break;
        case "أسابيع":
          tem.value = tem.value - (1 * 7);
          currentTaskDuration.value = currentTaskDuration.value - (1 * 7);

          break;
        case "أشهر":
          tem.value = tem.value - (1 * 30);

          currentTaskDuration.value = currentTaskDuration.value - (1 * 30);

          break;
        case "سنوات":
          tem.value = tem.value - (1 * 360);

          currentTaskDuration.value = currentTaskDuration.value - (1 * 360);

          break;
      }
    }
  }

  int tempIncrementTaskDuration() {
    int tem = totalTasksDuration.value;
    tem = tem + currentTaskDuration.value;
    return tem;
  }

  incrementTaskDuration() {
    if (isEdit.value) {
      totalTasksDuration.value = 0;
      checkTotalTaskDuration.value = 0;
      for (int i = 0; i < goalTask.value.length; i++) {
        totalTasksDuration.value =
            totalTasksDuration.value + goalTask.value[i].duration;
        checkTotalTaskDuration.value =
            checkTotalTaskDuration.value + goalTask.value[i].duration;
      }
    } else {
      totalTasksDuration.value =
          totalTasksDuration.value + currentTaskDuration.value;
      checkTotalTaskDuration.value =
          checkTotalTaskDuration.value + currentTaskDuration.value;
    }
  }

  dcrementTaskDuration(int deletedTaskDuration) {
    totalTasksDuration.value = totalTasksDuration.value - deletedTaskDuration;
    checkTotalTaskDuration.value =
        checkTotalTaskDuration.value - deletedTaskDuration;
  }

  //!For the communities joind users
  incrementCommunity() {
    switch (isSelected.value) {
      case "أيام":
        currentTaskDuration.value = currentTaskDuration.value + 1;
        tem.value = tempIncrementTaskDuration();
        break;
      case "أسابيع":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 7);
        tem.value = tempIncrementTaskDuration();

        break;
      case "أشهر":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 30);
        tem.value = tempIncrementTaskDuration();

        break;
      case "سنوات":
        currentTaskDuration.value = currentTaskDuration.value + (1 * 360);
        tem.value = tempIncrementTaskDuration();

        break;
    }
    TaskDuration.value++;
  }
}
