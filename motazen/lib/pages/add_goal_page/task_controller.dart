// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:motazen/pages/goals_habits_tab/taskClass.dart';

import '/entities/task.dart';
// create  a class called task
//the class have the same name property except having a list that
// when save in here save

class TaskControleer extends GetxController {
  var checkTotalTaskDuration =
      0.obs; // to check whether the user Enterd a valid goal duration or not
  var TaskDuration = 0.obs;
  var currentTaskDuration = 0.obs;
  var totalTasksDuration = 0.obs;
  var iscool = false.obs;
  var tem = 0.obs;
  var isSelected = "أيام".obs;

  Rx<List<Task>> goalTask =
      Rx<List<Task>>([]); // for saving the task depenecy  .
  Rx<List<String>> TasksMenue = Rx<List<String>>([]);
  Rx<List<String>> selectedTasks = Rx<List<String>>([]);
  var selectedOption = "".obs;

  var isEdit = false
      .obs; // to know what to do with the total duration in case of editing

  late Task task;
  var itemCount = 0.obs;
  var itemCountAdd = 0.obs;
  var itemCountDelete = 0.obs;
  var itemCountEdit = 0.obs;
  Rx<List<TaskData>> OrginalTasks = Rx<List<TaskData>>([]);

  Rx<List<TaskData>> allTaskForDepency = Rx<List<TaskData>>([]);
  Rx<TaskData> tryTask = Rx<TaskData>(TaskData());

  TextEditingController inputTaskName = TextEditingController();

  bool addTask(String name, String duName, int val) {
    TaskData TaskForDependency = TaskData();
    TaskForDependency.name = name;
    //this is just to create the list to check for andy dependen to not delete .
    for (int i = 0; i < selectedTasks.value.length; i++) {
      TaskForDependency.TaskDependency.add(selectedTasks.value[i]);
    }
    // TaskForDependency.TaskDependency = selectedTasks.value ;

    allTaskForDepency.value.add(TaskForDependency);

    String durationDescribtion = "";
    int duraitionn = 0;
    switch (duName) {
      case "أيام":
        duraitionn = val;
        durationDescribtion = "أيام";
        durationDescribtion = durationDescribtion;
        break;
      case "أسابيع":
        duraitionn = (val * 7);
        durationDescribtion = "أسابيع";
        durationDescribtion = durationDescribtion;

        break;
      case "أشهر":
        duraitionn = (val * 30);
        durationDescribtion = "أشهر";
        durationDescribtion = durationDescribtion;

        break;
      case "سنوات":
        duraitionn = (val * 360);
        durationDescribtion = "سنوات ";
        durationDescribtion = durationDescribtion;

        break;
    }
    Task newTak = Task(
        name: name,
        TaskDependency: selectedTasks.value,
        amountCompleted: 0,
        duration: duraitionn,
        durationDescribtion: durationDescribtion,
        taskCompletionPercentage: 0);

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
          icon: const Icon(Icons.alarm), barBlur: 20);

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
          icon: const Icon(Icons.alarm), barBlur: 20);
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
      Get.snackbar("", "قيمة الفترة لا يمكن ان تكون اقل من واحد",
          icon: const Icon(Icons.alarm), barBlur: 20);
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
}
