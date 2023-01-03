// ignore_for_file: file_names, non_constant_identifier_names, await_only_futures

import 'package:motazen/entities/LocalTask.dart';

import '/entities/aspect.dart';
import '/entities/goal.dart';
import '/entities/habit.dart';

import 'package:isar/isar.dart';

class IsarService {
  late Future<Isar> db;
  IsarService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      //if didn't opend before open one if iopen used an exsit one
      return await Isar.open(
          [
            AspectSchema,
            GoalSchema,
            LocalTaskSchema,
            HabitSchema,
          ] //still the habit schema
          ,
          inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  /// ADD GOALS , ADD TASKS , ADD ASPECT  */
  Future<bool> createGoal(Goal newgoal) async {
    //Add goals
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newgoal));
    return true;
  } //<int> because we want to get the id of the  ceated thing

  void UpdateTask(LocalTask tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.localTasks.put(tem);
    });
  }

  Future<LocalTask?> getSepecificTask(int id) async {
    final isar = await db;
    return await isar.localTasks.where().filter().idEqualTo(id).findFirst();
  }

  Future<LocalTask?> findSepecificTask2(String name) async {
    final isar = await db;
    return await isar.localTasks
        .filter()
        .nameContains(name)
        .goalIsNull()
        .findFirst();
  }

  void deleteTask3(LocalTask task) async {
    final isar = await db;

    await isar.writeTxn(() async {
      LocalTask? ttask = await isar.localTasks
          .filter()
          .nameContains(task.name)
          .goalIsNull()
          .findFirst();

      await isar.localTasks.delete(ttask!.id);
    });
  }

  Future<void> createHabit(Habit newHabit) async {
    //Add habits
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.habits.putSync(newHabit));

    isar.writeTxnSync<int>(() => isar.habits.putSync(newHabit));
  }

  Future<void> createAspect(Aspect newAspect) async {
    //Add aspect
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.aspects.putSync(newAspect));
  }

  /// ******************** */
  //we are listiening for data not just getting //
  Stream<List<Goal>> getAllGoals() async* {
    //Streams so that it is reflected when add immedeitly .
    final isar = await db;
    yield* isar.goals.where().watch(fireImmediately: true);
  }

  ///return a list of all goals
  Future<List<Goal>> getGoals() async {
    final isar = await db;
    return isar.goals.where().findAll();
  }

  Stream<List<Aspect>> getAllAspects() async* {
    final isar = await db;
    yield* isar.aspects.where().watch(fireImmediately: true);
  }

  Stream<List<Habit>> getAllHabits() async* {
    final isar = await db;
    yield* isar.habits.where().watch(fireImmediately: true);
  }

  Stream<List<Aspect>> getSelectedAspectsStream() async* {
    final isar = await db;
    yield* isar.aspects
        .filter()
        .isSelectedEqualTo(true)
        .watch(fireImmediately: true);
  }

  Future<LocalTask?> findSepecificTask(String name) async {
    final isar = await db;
    return await isar.localTasks.where().filter().nameEqualTo(name).findFirst();
  }

  // THER IS ANOTHE WAY IF YOU DON'T NEED IT AS STREAM .
  //just get the apsect --> i will use get because it is not sth that is changed or add frequenctly .

  Future<List<Aspect>> getAspectFirstTime() async {
    final isar = await db;
    return isar.aspects.where().findAll();
  }

  Future<Map<String, double>> getpointsAspects(List<Aspect> aspects) async {
    //get a list of aspect/points
    final isar = await db;
    Map<String, double> pointsList = {};
    for (int i = 0; i < aspects.length; i++) {
      String tempAspect = aspects[i].name;
      Aspect? tempPoints =
          await isar.aspects.where().idEqualTo(aspects[i].id).findFirst();
      pointsList[tempAspect] = tempPoints!.percentagePoints;
    }

    return pointsList;
  }

  void assignPointAspect(String aspectName, double points) async {
    final isar = await db;
    Aspect? tempAspect =
        await isar.aspects.filter().nameEqualTo(aspectName).findFirst();
    tempAspect!.percentagePoints = points;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(tempAspect)); // update that object
  }

  // to get all other collection records based on a specific Aspect
  // get points for a specfic aspect
  //get goals for a specfic aspect
  //get habits for a specific aspect

//NOTE!!!!!!! I am taking based on the name not the id !!!!!!!!!!!!!!!!/

  Future<List<Goal>> getAspectGoals(Aspect aspect) async {
    final isar = await db;
    return await isar.goals
        .filter()
        .aspect((q) => q.nameContains(aspect.name))
        .findAll();
  }

  Future<List<Habit>> getAspectHabits(Aspect aspect) async {
    final isar = await db;
    return await isar.habits
        .filter()
        .aspect((q) => q.nameContains(aspect.name))
        .findAll();
  }

  Future<List<Aspect>> getchoseAspect() async {
    ///remove if my implementation works
    final isar = await db;
    return await isar.aspects.filter().percentagePointsGreaterThan(0).findAll();
  }

  Future<Aspect?> findSepecificAspect(String name) async {
    final isar = await db;
    return await isar.aspects.where().filter().nameEqualTo(name).findFirst();
  }

// changes
  Future<void> saveTask(LocalTask task) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.localTasks.putSync(task));
  }

  Future<void> updateTask(LocalTask task) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.localTasks.putSync(task));
  }

  Future<void> deleteTask(int id) async {
    final isar = await db;
    isar.writeTxnSync<bool>(() => isar.localTasks.deleteSync(id));
  }

  Stream<List<LocalTask>> listenTasks() async* {
    final isar = await db;
    yield* isar.localTasks.where().watch(fireImmediately: true);
  }

  Future<Goal?> getSepecificGoal(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      return await isar.goals.get(id);
    });
    return null;
  }

  Future<Aspect?> getAspectByGoal(int goalId) async {
    final isar = await db;
    return await isar.aspects
        .where()
        .filter()
        .goals((q) => q.idEqualTo(goalId))
        .findFirstSync();
  }

  Future<Goal?> getSepecificGoall(int id) async {
    final isar = await db;

    return await isar.goals.where().filter().idEqualTo(id).findFirstSync();
  }

  Future<Habit?> getSepecificHabit(int id) async {
    final isar = await db;

    return await isar.habits.where().filter().idEqualTo(id).findFirstSync();
  }

  //updates the value of isSelected to true
  void selectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect =
        await isar.aspects.filter().nameEqualTo(name).findFirst();
    selectedAspect!.isSelected = true;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(selectedAspect)); // update that object
  }

//updates isSelected value to false for a single aspect
  void deselectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect =
        await isar.aspects.filter().nameEqualTo(name).findFirst();
    selectedAspect!.isSelected = false;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(selectedAspect)); // update that object
  }

//update the aspect points
  void updateAspectPercentage(int id, double percentage) async {
    final isar = await db;
    Aspect? updatedAspect =
        await isar.aspects.filter().idEqualTo(id).findFirst();
    updatedAspect!.percentagePoints = percentage;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(updatedAspect)); // update that object
  }

//return the isSelected value of a single aspect
  Future<bool> checkSelectionStatus(String name) async {
    final isar = await db;
    Aspect? aspect = await isar.aspects.filter().nameEqualTo(name).findFirst();
    return aspect!.isSelected;
  }

//returns a list of selected aspects
  Future<List<Aspect>> getSelectedAspects() async {
    final isar = await db;
    return await isar.aspects.filter().isSelectedEqualTo(true).findAll();
  }

//increments the amount of days a task has been completed
  void incrementAmountCompleted(int id) async {
    final isar = await db;
    LocalTask? completedTask =
        await isar.localTasks.filter().idEqualTo(id).findFirst();
    completedTask!.amountCompleted = completedTask.amountCompleted + 1;
    isar.writeTxnSync<int>(
        () => isar.localTasks.putSync(completedTask)); // update that object
  }

  //increments the amount of days a task has been completed
  void decrementAmountCompleted(int id) async {
    final isar = await db;
    LocalTask? completedTask =
        await isar.localTasks.filter().idEqualTo(id).findFirst();
    completedTask!.amountCompleted = completedTask.amountCompleted - 1;
    isar.writeTxnSync<int>(
        () => isar.localTasks.putSync(completedTask)); // update that object
  }

  //updates the completion percentage of a task
  void updateTaskPercentage(int id, double percentage) async {
    final isar = await db;
    LocalTask? completedTask =
        await isar.localTasks.filter().idEqualTo(id).findFirst();
    completedTask!.taskCompletionPercentage = percentage;
    isar.writeTxnSync<int>(
        () => isar.localTasks.putSync(completedTask)); // update that object
  }

  //updates the completion percentage of a goal
  void updateGoalPercentage(int id, double percentage) async {
    final isar = await db;
    Goal? completedGoal = await isar.goals.filter().idEqualTo(id).findFirst();
    completedGoal!.goalProgressPercentage = percentage;
    isar.writeTxnSync<int>(
        () => isar.goals.putSync(completedGoal)); // update that object
  }

//Delete //
  Future<void> cleanAspects() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.aspects.clear();
    });
  }

  void deleteAllAspects(List<dynamic>? aspectsChosen) async {
    final isar = await db;
    for (int i = 0; i < aspectsChosen!.length; i++) {
      Aspect x = aspectsChosen[i];

      await isar.writeTxn(() async {
        await isar.aspects.delete(x.id);
      });
    }
  }

  void deleteGoal(Goal goal) async {
    List<LocalTask> goalTasks = goal.task.toList();
    for (var i in goalTasks) {
      deleteTask2(i);
    }
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goals.delete(goal.id);
    });
  }

  void deleteTask2(LocalTask task) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.localTasks.delete(task.id);
    });
  }

  void deleteHabit(Habit habit) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.habits.delete(habit.id);
    });
  }

  void UpdateGoal(Goal tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.goals.put(tem);
    });
  }

  void UpdateHabit(Habit tem) async {
    final isar = await db;

    await isar.writeTxn(() async {
      await isar.habits.put(tem);
    });
  }
}
