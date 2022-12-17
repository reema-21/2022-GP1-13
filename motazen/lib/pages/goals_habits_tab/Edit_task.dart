// ignore_for_file: file_names, must_be_immutable, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import 'package:get/get.dart';
import 'package:motazen/pages/goals_habits_tab/taskClass.dart';
import 'package:multiselect/multiselect.dart';
import '../../entities/goal.dart';
import '../assesment_page/alert_dialog.dart';

class EditTask extends StatefulWidget {
  final IsarService isr;
  final int goalDurtion;
  List<Task> goalTask;
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
  final TaskControleer freq = Get.put(TaskControleer());
  List<String> durationName = ['أيام', 'أسابيع', 'أشهر', 'سنوات'];

  TextEditingController inputTaskName = TextEditingController();
  String? isSelected = "";
  late String TaskName;
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
      freq.AssignTaks(value);
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
    void getDepenendyTasks() async{
for(var i in freq.goalTask.value){
  // create the array for the alldependncy 
  //create the object 
  //fetch the tasks so that you can get its dependency 
  //assign value and add to the list 
      Task ? tem = Task();
      TaskData task = TaskData() ; 
      tem = await widget.isr.getSepecificTask(i.id) ; 
    if (tem != null) {
  task.name = tem.name ; 

  for(var j in tem.TaskDependency.toList()){
    task.TaskDependency.add(j.name) ; 
  }
freq.allTaskForDepency.value.add(task);
   
}
    

    }

    }

  Future<List<Task>> getTasks() async {
    Goal? goal = Goal();
    goal = await widget.isr.getSepecificGoall(widget.id);
    return goal!.task.toList();
  }

  void _updateText() {
    setState(() {
      TaskName = inputTaskName.text;
    });
  }

  Task? task = Task();
   UpdateTask(Task UpdateTask, List<String> tasks , int index) async {

    task = await widget.isr.getSepecificTask(UpdateTask.id);
        print(UpdateTask.id);

     print("here i am before adding the tasks in the adding");
    print(freq.selectedTasks.value);

     //TaskDependency is my IsarLinks 
    task!.name = UpdateTask.name;
    task!.duration = UpdateTask.duration;
    task!.durationDescribtion = UpdateTask.durationDescribtion;
    // to clear the previos dependcey of a task 
    // i will check if the task have any dependy that is not in the current selected one i will delete and then add it again .
    //you migh need to link it to the goal .


print("-----------------------------------------------------");
List <Task> currentDependy = task!.TaskDependency.toList();
print("here is the length of it ");
print(currentDependy.length);
// task!.TaskDependency.clear();
 currentDependy = task!.TaskDependency.toList();
print("here is the length of it ");
print(currentDependy.length); 
print("---------------------------------------");
print("here is the selected tasks"); 
print(freq.selectedTasks.value.length); 
print("***************************************");
if (freq.selectedTasks.value.length ==0 ){

  for (var i in currentDependy ){
    widget.isr.deleteTask(i.id);
         
    widget.isr.saveTask(i);

  }
  

  print(" iam entering here ") ; 

} else{bool isDeleted = true ;
    // this part down is for add more to the isarLink and it works 
    for(int i  = 0 ; i<currentDependy.length ; i++){
        isDeleted = true ;

      for(int j = 0 ; j <tasks.length ; j++){
        if(currentDependy[i].name == tasks[j]){
          print("here is the tasks the is not deleted") ; 
          print(currentDependy[i].name);
          isDeleted = false ; 
          break ; 
        }

        if (isDeleted){
            widget.isr.deleteTask(currentDependy[i].id);
          print("here is i am checking that is not totaly deleted");
          print(currentDependy[i].id);
          widget.isr.saveTask(currentDependy[i]);
          return true ; 

        }
      }
    }
    await Future.forEach(tasks, (item) async {

      Task? y = Task();
      String name = item;

      y = await widget.isr.findSepecificTask(name);
      task!.TaskDependency.add(y!); // to link task and it depends tasks ;
      // widget.isr.saveTask(y);// to link
    });}
//  for (var i  in freq.selectedTasks.value){
//   Task ? y = await widget.isr.findSepecificTask(i);
//       task!.TaskDependency.add(y!);
//             task!.TaskDependency.saveSync();




//  }


// i will try a new short one  . 



    widget.isr.saveTask(task!);
          print("here im checking where it is adjusted or nor ------------------------------------");
    print(freq.allTaskForDepency.value[index].TaskDependency);;
    print("=+++++++++++++++++++++++++++++++++++++++++++++++");
    
  }

  AddTheEnterdTask(Task newTask , List <String> tasks ) async {
    //you should 1- store the task 2- link the task to the goal ans the goal to the task
    print("here i am before adding the tasks in the adding");
    print(freq.selectedTasks.value);
   

     List <String> Taskss=[];
     for(int i = 0 ; i<freq.selectedTasks.value.length; i++){
      Taskss.add(freq.selectedTasks.value[i]);

     }
    await Future.forEach(Taskss, (item) async {

      Task? y = Task();
      String name = item;


      y = await widget.isr.findSepecificTask(name);
      newTask.TaskDependency.add(y!);// to link task and it depends tasks ;
      // widget.isr.saveTask(y);// to link
  });
    
     List<Task> t  = newTask.TaskDependency.toList();
       print("hi");

    print(t);
 await Future.forEach(t, (item) async {
  print("hi");
  task!.TaskDependency.remove(item);

 });
    widget.isr.saveTask(newTask);
    Goal? goal = Goal();
    goal = await widget.isr.getSepecificGoall(widget.id);
    goal!.task.add(newTask);
    widget.isr.createGoal(goal);
    newTask.goal.value = goal;
    widget.isr.saveTask(newTask);


    getTasks().then((value) {
      //regive the freq.goal ta
      freq.AssignTaks(value);
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
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
                  // for (int i = 0;
                  //     i < freq.newTasksAddedInEditing.value.length;
                  //     i++)
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
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        //------------------------------------i might need to assign the value in here -------------------//
                                        freq.storeStatusOpen(true);
                                        
                                        selectedtype = freq.goalTask
                                            .value[index].durationDescribtion;
                                        currentTaskduraions =
                                            freq.goalTask.value[index].duration;
                                            List<Task> dependency = freq.goalTask
                                              .value[index].TaskDependency
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
                                            //  print("here is the info");
                                            //  print(currentTaskduraions);
                                            //  print(selectedtype);
                                            //  print(totalDurtion);
                                            //  print(taskduration);
                                            //  print ("end of the info ");

                                            break;
                                          case "أسابيع":
                                            taskduration = freq.goalTask
                                                    .value[index].duration ~/
                                                7;
                                            //  print("here is the info");
                                            //                                        print(currentTaskduraions);
                                            //                                        print(selectedtype);
                                            //                                        print(totalDurtion);
                                            //                                        print(taskduration);
                                            //                                        print ("end of the info ");

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
                                          freq.TasksMenue.value.clear();
                                          for (int i = 0;
                                              i < freq.goalTask.value.length;
                                              i++) {
                                            if (i == index) {
                                              continue;
                                            }
                                            freq.TasksMenue.value.add(
                                                freq.goalTask.value[i].name);
                                          }
                                          freq.selectedTasks.value.clear();
                                          List<Task> dependency = freq.goalTask
                                              .value[index].TaskDependency
                                              .toList();
                                          for (int i = 0;
                                              i < dependency.length;
                                              i++) {
                                            freq.selectedTasks.value
                                                .add(dependency[i].name);

                                              // for(var i in freq.allTaskForDepency.value){
                                              //   if(i.name == freq.inputTaskName.value.text){
                                              //     i.TaskDependency.clear() ; 
                                              //     for(var j in freq.selectedTasks.value){
                                              //       i.TaskDependency.add(j);
                                              //     }
                                              //     print("here i am printing the value of the task depency after editing");
                                              //     print(i.TaskDependency);
                                              //     break ; 
                                              //   }
                                              // }
                                          }
                                          //   freq.goalTask.value
                                          // freq.TasksMenue.value = freq.goalTask.value.removeAt(index) ;
                                        });
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              print(freq.selectedTasks.value);
                                              return AlertDialog(
                                                  title: const Text(
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
                                                            TextFormField(
                                                             validator: (value) {
                                     bool Repeated  = false ; 
                                     for( int i  = index+1 ; i<freq.goalTask.value.length ; i++){
                                      if(freq.goalTask.value[i].name == value){
                                        setState(() {
                                          Repeated = true;
                                        });
                                      }
                                     }
                                      for( int i  = 0 ; i<index ; i++){
                                      if(freq.goalTask.value[i].name == value){
                                        setState(() {
                                          Repeated = true;
                                        });
                                      }
                                     }
                                  
                                    if (value == null || value.isEmpty) {
                                      return "من فضلك ادخل اسم المهمة";
                                      // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                                      //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                                      // }
                                    } else if ( Repeated){
                                      return "يوجد مهمة بنفس الاسم";

                                    }
                                    
                                    else {
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
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              children: [
                                                                const Text(
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
                                                                    color: const Color(
                                                                        0xFF66BF77),
                                                                  ),
                                                                  child: Center(
                                                                    child:
                                                                        IconButton(
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Colors
                                                                            .white,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        freq.increment(
                                                                            widget.goalDurtion);
                                                                        if (freq.TaskDuration !=
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
                                                                      freq.TaskDuration
                                                                          .toString(),
                                                                      style: const TextStyle(
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
                                                                        BorderRadius.circular(
                                                                            25),
                                                                    color: const Color(
                                                                        0xFF66BF77),
                                                                  ),
                                                                  child:
                                                                      IconButton(
                                                                    icon: const Icon(
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
                                                                const SizedBox(
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
                                                                        for (int i =
                                                                                0;
                                                                            i < durationName.length;
                                                                            i++) {
                                                                          if (value!
                                                                              .contains(durationName[0])) {
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
                                                            Directionality(
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              child:
                                                                  DropDownMultiSelect(
                                                                // icon: const Icon(
                                                                //   Icons.arrow_drop_down_circle,
                                                                //   color: Color(0xFF66BF77),
                                                                // ),
                                                                options: freq
                                                                    .TasksMenue
                                                                    .value,
                                                                //need to be righted
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      "تعتمد على ",
                                                                  prefixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .splitscreen,
                                                                    color: Color(
                                                                        0xFF66BF77),
                                                                  ),
                                                                ),
                                                                onChanged:
                                                                    (value) {
                                                                  freq.selectedTasks
                                                                          .value =
                                                                      value;
                                                                      print("here is the value of the array");
                                                                      print( freq.selectedTasks
                                                                          .value);
                                                                  //here you can save the tasks and link it
                                                                },
                                                                selectedValues: freq
                                                                    .selectedTasks
                                                                    .value,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 30,
                                                            ),
                                                            Obx(() =>
                                                                ElevatedButton(
                                                                // there was this line to make sure that a change in the duration happend
                                                                  onPressed: freq
                                                                          .iscool
                                                                          .value
                                                                      ? () {
                                                                          if (formKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            setState(() {
                                                                              freq.goalTask.value[index].TaskDependency.clear(); // add the dependednt task
                                                                             
                                                                              for (int i = 0; i < freq.selectedTasks.value.length; i++) {
                                                                                for (int j = 0; j < freq.goalTask.value.length; j++) {
                                                                                  if (freq.goalTask.value[j].name == freq.selectedTasks.value[i]) {
                                                                                    freq.goalTask.value[index].TaskDependency.add(freq.goalTask.value[j]);
                                                                                  }
                                                                                }
                                                                              }

                                                                              freq.goalTask.value[index].name = freq.inputTaskName.value.text;
                                                                              
                                                                              freq.allTaskForDepency.value[index].name = freq.inputTaskName.value.text; // this for editing the all if it is changed
                                                                              //----------------- you should adjust the dependny also ---------------//

                                                                             freq.allTaskForDepency.value[index].TaskDependency = [];
                                                                             print("here i am printing the value of its dependcy");
                                                                             print(freq.allTaskForDepency.value[index].TaskDependency);
                                                                              for(var i in freq.selectedTasks.value){
                                                                                print("here i am printing to check that i am adjusting the value");
                                                                                  freq.allTaskForDepency.value[index].TaskDependency.add(i);                                                                                
                                                                                }


                                                                              //-----the above part  is ajesting the depencies for the dleteion part -----//
                                                                              
                                                                              String durationDescribtion = "";
                                                                              switch (freq.isSelected.value) {
                                                                                case "أيام":
                                                                                  freq.goalTask.value[index].duration = freq.TaskDuration.value;
                                                                                  durationDescribtion = "أيام";
                                                                                  freq.goalTask.value[index].durationDescribtion = durationDescribtion;
                                                                                  break;
                                                                                case "أسابيع":
                                                                                  freq.goalTask.value[index].duration = (freq.TaskDuration.value * 7);
                                                                                  durationDescribtion = "أسابيع";
                                                                                  freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                                  break;
                                                                                case "أشهر":
                                                                                  freq.goalTask.value[index].duration = (freq.TaskDuration.value * 30);
                                                                                  durationDescribtion = "أشهر";
                                                                                  freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                                  break;
                                                                                case "سنوات":
                                                                                  freq.goalTask.value[index].duration = (freq.TaskDuration.value * 360);
                                                                                  durationDescribtion = "سنوات ";
                                                                                  freq.goalTask.value[index].durationDescribtion = durationDescribtion;

                                                                                  break;
                                                                              }
                                                                              print("helllooooooooooo");
print(freq.selectedTasks.value);
List <String> Taskss=[];
     for(int i = 0 ; i<freq.selectedTasks.value.length; i++){
      Taskss.add(freq.selectedTasks.value[i]);

     }
                                                                            setState(() {
                                                                              x = true; 
                                                                            });
                                                                            
                                                                            
                                                                            UpdateTask(freq.goalTask.value[index], Taskss , index );
                                                                              print("helllooooooooooo");
print(freq.selectedTasks.value);
                                                                              freq.EditedTasksInEditing.value.add(freq.goalTask.value[index]);
                                                                              // print("here i will try to see why it not working");
                                                                              // print(freq.goalTask.value[index].name);
                                                                              // print(freq.goalTask.value[index].duration);
                                                                              // print(freq.goalTask.value[index].TaskDependency);

                                                                              freq.TaskDuration.value = 0;

                                                                              freq.storeStatusOpen(false);
                                                                              freq.storeStatusEditi(true); //to know what to do with the total of the duration after editing the task
                                                                              freq.incrementTaskDuration();
                                                                              freq.storeStatusEditi(false); //to know what to do with the total of the duration after editing the task

                                                                              freq.currentTaskDuration.value = 0;
                                                                              // freq.selectedTasks.value.clear();

                                                                              freq.setvalue(durationName[0]);
                                                                             
                                                                            });
                                                                          }
                                                                          if (x){
                                                                            x=false ;
                                                                       
                                                Navigator.pop(context); 

                                                                          }
                                                                        }
                                                                      : null,
                                                                  child: const Text(
                                                                      "حفظ التعديلات"),
                                                                ))
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
                                         bool isDependent = false ;  // prevent the user from deleting any task the depends by other tasks
                                      for(int i =0 ; i<freq.goalTask.value.length ; i++){
                                        
                                        List <TaskData>  x = freq.allTaskForDepency.value ; 
                                      
                                        for(int j = 0 ;j<x.length ; j++){
                                          List<String> dependencies  = x[i].TaskDependency ; 
                                          print("here is the dependincies i am checkin when deleteing");
                                          print(dependencies);
                                          for(int k = 0 ; k<dependencies.length ; k++) {
                                            
                                             if(dependencies[k] == freq.goalTask.value[index].name){
                                              print("here we are "); 
                                            print(dependencies[k] );
                                            isDependent = true ; 
                                            break ; 
                                          }

                                          }
                                         
                                        }

                                      }

                                       if(isDependent){
                                        print ("i am here there there there there there ") ; 
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
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

                                      }
                                       
                                       else { int x =
                                            freq.goalTask.value[index].duration;
                                        freq.dcrementTaskDuration(x);
                                        print(
                                            "here is the value that should be decreased");
                                        print(
                                            "here is the totaldurationafter the decreasign");
                                        print(freq.totalTasksDuration);
                                        print("here i am deleteing and here is my id befire"); 
    print(freq.goalTask.value[index].id);

    bool oldTask = false; 
    for(int i = 0 ; i< widget.goalTask.length ; i++){
      print("here is the task old ");
      print(widget.goalTask[i]);
if(widget.goalTask[i].name== freq.goalTask.value[index].name ){
  print("i get in there") ; 
  oldTask = true ; 
  break; 
}
    }
    print("here i am printing the valeu to check ");
    print(oldTask);
    if(oldTask){
widget.isr.deleteTask2(
                                            freq.goalTask.value[index]);
    }else{
widget.isr.deleteTask3(
                                            freq.goalTask.value[index]);
    }
                                        
                                        //here i am try to collect all the deleted tasks so that i can take it back if the users did cancle the chenges
                                        freq.DeletedTasks.value
                                            .add(freq.goalTask.value[index]);
                                        //if error or sth you might need to update the count of the array

                                        setState(() {
                                          freq.removeTask(index);
                                          totalDurtion = totalDurtion -
                                              x; //adddedddddddddddddddddddddddddd
                                        });}
                                      
                                    }else{}
                                    }
                                  ),

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
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              setState(() {
                  print("here is the dependncies ------------------------------------------------------------------ ");
                  print(freq.allTaskForDepency.value.length);
              for(var i in freq.allTaskForDepency.value){
                print("the task name "); 
                print(i.name); 
                print(i.TaskDependency.toString());
              } print("---------------------------------------------");
              print("here is the real ---------------------------------------------");
              for(var i in freq.goalTask.value){
                print("the task name "); 
                print(i.name); 
              }
              print("================================================================");
                freq.inputTaskName.text = "";

                freq.selectedTasks.value.clear();
                freq.TasksMenue.value.clear();
                for (int i = 0; i < freq.goalTask.value.length; i++) {
                  freq.TasksMenue.value.add(freq.goalTask.value[i].name);
                }
              });
              freq.setInitionals(0, 0, totalDurtion, durationName[0]);
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text(
                          " مهمة جديدة",
                          textDirection: TextDirection.rtl,
                        ),
                        content: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Form(
                            key: formKey,
                            child: SingleChildScrollView(
                                child: Column(children: [
                              TextFormField(
                                validator: (value) {
                                     bool Repeated  = false ; 
                                    for(var i in freq.goalTask.value){
                                      if(i.name == value){
                                        setState(() {
                                          Repeated = true;
                                        });
                                      }
                                    }
                                    if (value == null || value.isEmpty) {
                                      return "من فضلك ادخل اسم المهمة";
                                      // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                                      //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                                      // }
                                    } else if ( Repeated){
                                      return "يوجد مهمة بنفس الاسم";

                                    }
                                    
                                    else {
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
                                            if (value!
                                                .contains(durationName[0])) {
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
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: DropDownMultiSelect(
                                  // icon: const Icon(
                                  //   Icons.arrow_drop_down_circle,
                                  //   color: Color(0xFF66BF77),
                                  // ),
                                  options: freq.TasksMenue.value,
                                  //need to be righted
                                  decoration: const InputDecoration(
                                    labelText: "المهمام الاعتمادية",
                                    prefixIcon: Icon(
                                      Icons.splitscreen,
                                      color: Color(0xFF66BF77),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    print(
                                        "here i am printing thae value of the selected ");
                                    print(freq.TasksMenue.value);
                                    freq.selectedTasks.value = value;
                                    //here you can save the tasks and link it
                                  },
                                  selectedValues: freq.selectedTasks.value,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Obx(() => ElevatedButton(
                                    onPressed: freq.iscool.value
                                        ? () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              setState(() {
                                                Task newTak = Task();
                                                newTak.name = freq
                                                    .inputTaskName.value.text;
                                                String durationDescribtion = "";
                                                switch (freq.isSelected.value) {
                                                  case "أيام":
                                                    newTak.duration =
                                                        freq.TaskDuration.value;
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
                                                print(
                                                    "here i am printing ehat i have in the choesen list ");
                                                print(
                                                    freq.selectedOption.value);
                                                AddTheEnterdTask(newTak , freq.selectedTasks.value);
                                                // freq.TasksMenue.value.add(freq
                                                //     .inputTaskName
                                                //     .value
                                                //     .text); //ad the enterd to the tasks to the dependncy tasks .
                                                setState(() {
                                                        x =    freq.addTask(
                                                      freq.inputTaskName.value
                                                          .text,
                                                      freq.isSelected.value,
                                                      freq.TaskDuration.value);
                                                        
                                                      }); //ad the enterd to the tasks to the dependncy tasks .
                                                

                                                freq.TaskDuration.value = 0;

                                                freq.storeStatusOpen(false);
                                                freq.incrementTaskDuration();
                                                freq.currentTaskDuration.value =
                                                    0;
                                                freq.TasksMenue.value.clear();
                                                freq.selectedTasks.value
                                                    .clear();
                                                freq.setvalue(durationName[0]);
                                                freq.selectedTasks.value
                                                    .clear();
                                              });
                                            }
                                            if (x){
                                              x=false ; 
                                                Navigator.pop(context); 

                                            }
                                          }
                                        : null,
                                    child: const Text("اضافة"),
                                  ))
                            ])),
                          ),
                        ));
                  });
            }),
      ),
    );
  }

  bool boolvalid = true;
}
