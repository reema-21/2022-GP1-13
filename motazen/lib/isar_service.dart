import '/entities/aspect.dart';
import '/entities/goal.dart';
import '/entities/task.dart';
import '/entities/habit.dart';
import '/entities/point.dart';

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
            TaskSchema,
            HabitSchema,
            PointSchema
          ] //still the habit schema
          ,
          inspector: true);
    }
    return Future.value(Isar.getInstance());
  }

  /// ADD GOALS , ADD TASKS , ADD ASPECT  */
  Future<void> createGoal(Goal newgoal) async {
    //Add goals
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newgoal));
  } //<int> because we want to get the id of the  ceated thing

  Future<void> createHabit(Habit newHabit) async {
    //Add habits
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.habits.putSync(newHabit));
  }

  Future<void> createTask(Task newTask) async {
    //Add task
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.tasks.putSync(newTask));
  }

  Future<void> createAspect(Aspect newAspect) async {
    //Add aspect
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.aspects.putSync(newAspect));
  }

  Future<void> createPoint(Point newPoint) async {
    //Add point .
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.points.putSync(newPoint));
  }

  /// ******************** */
  //we are listiening for data not just getting //
  Stream<List<Goal>> getAllGoals() async* {
    //Streams so that it is reflected when add immedeitly .
    final isar = await db;
    yield* isar.goals.where().watch(fireImmediately: true);
  }

  Stream<List<Aspect>> getAllAspects() async* {
    final isar = await db;
    yield* isar.aspects.where().watch(fireImmediately: true);
  }

  Stream<List<Task>> getAllTasks() async* {
    final isar = await db;
    yield* isar.tasks.where().watch(fireImmediately: true);
  }

  Stream<List<Habit>> getAllHabits() async* {
    final isar = await db;
    yield* isar.habits.where().watch(fireImmediately: true);
  }

  Stream<List<Point>> getAllPoints() async* {
    final isar = await db;
    yield* isar.points.where().watch(fireImmediately: true);
  }

  // THER IS ANOTHE WAY IF YOU DON'T NEED IT AS STREAM .
  //just get the apsect --> i will use get because it is not sth that is changed or add frequenctly .

  Future<List<Aspect>> getAspectFirstTime() async {
    final isar = await db;
    return isar.aspects.where().findAll();
  }

  Future<List<Point>> getpointsFirstTime() async {
    final isar = await db;
    return isar.points.where().findAll();
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
  Future<List<Point>> getAspectPoints(Aspect aspect) async {
    final isar = await db;
    return await isar.points
        .filter()
        .aspect((q) => q.nameContains(aspect.name))
        .findAll();
  }

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
    final isar = await db;
    return await isar.aspects.filter().percentagePointsGreaterThan(0).findAll();

        }


  Future<Aspect?> findSepecificAspect(String name) async {
    final isar = await db;
    return await isar.aspects.where().filter().nameEqualTo(name).findFirst();
  }

  //update the value of isSelected
  void selectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect =
        await isar.aspects.filter().nameEqualTo(name).findFirst();
    selectedAspect!.isSelected = true;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(selectedAspect)); // update that object
  }

  void deselectAspect(String name) async {
    final isar = await db;
    Aspect? selectedAspect =
        await isar.aspects.filter().nameEqualTo(name).findFirst();
    selectedAspect!.isSelected = false;
    isar.writeTxnSync<int>(
        () => isar.aspects.putSync(selectedAspect)); // update that object
  }

//Delete //
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
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.goals.delete(goal.id);
    });
  }

  void deleteHabit(Habit habit) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.habits.delete(habit.id);
    });
  }
}
