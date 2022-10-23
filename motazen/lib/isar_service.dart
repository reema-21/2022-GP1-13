import 'package:datatry/entities/aspect.dart';
import 'package:datatry/entities/goal.dart';
import 'package:datatry/entities/task.dart';
import 'package:isar/isar.dart';

class IsarService{
  late Future<Isar> db ;
   IsarService (){
    db=openIsar();
   }

   Future <Isar> openIsar() async{
    if (Isar.instanceNames.isEmpty){ //if didn't opend before open one if iopen used an exsit one 
     return await Isar.open([AspectSchema,GoalSchema,TaskSchema] //still the habit schema
     , inspector: true);
   
    }
    return Future.value(Isar.getInstance());
   }


    /// ADD GOALS , ADD TASKS , ADD ASPECT  */
   Future<void> createGoal (Goal newgoal) async { //Add goals 
    final isar = await db ;
    isar.writeTxnSync<int>(() => isar.goals.putSync(newgoal));}  //<int> because we want to get the id of the  ceated thing

    Future<void> createTask(Task newTask) async { //Add task
    final isar = await db ;
    isar.writeTxnSync<int>(() => isar.tasks.putSync(newTask));}   

    Future<void> createAspect(Aspect newAspect) async { //Add aspect
    final isar = await db ;
    isar.writeTxnSync<int>(() => isar.
    aspects.putSync(newAspect));} 

    /********************** */

    Stream <List<Goal>> getAllGoals ()async*{
     final isar = await db ;
     yield* isar.goals.where().watch(fireImmediately: true);

    }

    Stream <List<Aspect>> getAllAspects ()async*{
     final isar = await db ;
     yield* isar.aspects.where().watch(fireImmediately: true);

    }

    Stream <List<Task>> getAllTasks ()async*{
     final isar = await db ;
     yield* isar.tasks.where().watch(fireImmediately: true);

    }
}