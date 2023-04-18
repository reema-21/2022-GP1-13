import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:motazen/models/task_model.dart';
import '/entities/task.dart';

class TaskControleer extends GetxController {
  var checkTotalTaskDuration =
      0.obs; // to check whether the user Enterd a valid goal duration or not
  var taskDuration = 0.obs;
  var currentTaskDuration = 0.obs;
  var totalTasksDuration = 0.obs;
  var iscool = false.obs;
  var tem = 0.obs;
  var isSelected = "أيام".obs;

  Rx<List<Task>> goalTask =
      Rx<List<Task>>([]); // for saving the task depenecy  .
  Rx<List<String>> tasksMenue = Rx<List<String>>([]);
  Rx<List<String>> selectedTasks = Rx<List<String>>([]);
  var selectedOption = "".obs;

  var isEdit = false
      .obs; // to know what to do with the total duration in case of editing

  late Task task;
  var itemCount = 0.obs;
  var itemCountAdd = 0.obs;
  var itemCountDelete = 0.obs;
  var itemCountEdit = 0.obs;
  Rx<List<TaskData>> orginalTasks = Rx<List<TaskData>>([]);

  Rx<List<TaskData>> allTaskForDepency = Rx<List<TaskData>>([]);
  Rx<TaskData> tryTask = Rx<TaskData>(TaskData());

  TextEditingController inputTaskName = TextEditingController();

  bool addTask(String name, String duName, int val) {
    TaskData taskForDependency = TaskData();
    taskForDependency.name = name;
    //this is just to create the list to check for andy dependen to not delete .
    for (int i = 0; i < selectedTasks.value.length; i++) {
      taskForDependency.taskDependency.add(selectedTasks.value[i]);
    }
    // taskForDependency.taskDependency = selectedTasks.value ;

    allTaskForDepency.value.add(taskForDependency);

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
        taskDependency: selectedTasks.value,
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
    goalTask.value.removeAt(index);
    itemCount.value = goalTask.value.length;
  }

  void setInitionals(int taskduration, int currentTaskduraions,
      int totalDurtion, String selectedType) {
    int totalSummation = 0;
    for (int i = 0; i < goalTask.value.length; i++) {
      totalSummation = totalSummation + goalTask.value[i].duration;
    }

    taskDuration.value = taskduration;
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
        colorText: Colors.black,
        duration: const Duration(milliseconds: 1000),
        backgroundColor: const Color.fromARGB(255, 243, 9, 9),
        "",
        "لا يمكن زيادة الفترة ، فترة المهام ستصبح أعلى من فترة الهدف ",
        icon: const Icon(Icons.alarm),
      );

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
      taskDuration.value++;
    }
  }

  setdefult() {
    taskDuration.value = 0;
    tem.value = tem.value - currentTaskDuration.value;
    currentTaskDuration.value = 0;
  }

  dcrement() {
    if (taskDuration.value <= 0) {
      Get.snackbar("", "قيمة الفترة لا يمكن ان تكون اقل من واحد",
          icon: const Icon(Icons.alarm), barBlur: 20);
    } else {
      taskDuration.value--;

      switch (isSelected.value) {
        case "أيام":
          tem.value = tem.value - taskDuration.value;
          currentTaskDuration.value = taskDuration.value;

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
