import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../entities/task.dart';

class TaskControleer extends GetxController{
  var TaskDuration =0.obs;
  var currentTaskDuration = 0.obs;
  var totalTasksDuration= 0.obs;
  var iscool = false.obs; 
  var tem = 0.obs;
  var isSelected = "أيام".obs;
 Rx<List<Task>> goalTask = Rx<List<Task>> ([]);
late Task task ; 
var itemCount =0.obs;
TextEditingController inputTaskName = TextEditingController();

addTask(String name , String duName , int val){
   Task newTak = Task();
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
}

removeTask(int index){
  goalTask.value.removeAt(index);
  itemCount.value = goalTask.value.length;
}

AssignTaks(List<Task> currentGoalTask){
  goalTask.value.clear();
  goalTask.value.addAll(currentGoalTask);
}

  void setInitionals (int taskduration , int currentTaskduraions , int  totalDurtion , String selectedType){
    TaskDuration.value = taskduration; 
    currentTaskDuration.value = currentTaskduraions;
    tem.value = totalDurtion; 
    totalTasksDuration.value = totalDurtion ; 
    isSelected.value = selectedType ;

  }
  
void storeStatusOpen(bool isOpen) {
 iscool(isOpen);
 print (iscool.value);
}
setvalue(String x ){
  isSelected.value = x;
}
  increment(num goalduration ){

//     print("here is the cuurent vlaue 1 ");
// print(currentTaskDuration.value);
// print ("here is the temp value1 ");
// print(tem);
// print ("here is the taskduraion value1");
// print (totalTasksDuration);
//       print (isSelected.value);
       switch (isSelected.value) {
                            case "أيام":
                           
                          currentTaskDuration.value = currentTaskDuration.value+ 1;
                          tem.value = tempIncrementTaskDuration();
                              break;
                            case "أسابيع":
                            print(TaskDuration);
                            currentTaskDuration.value = currentTaskDuration.value+ (1*7);
                          tem.value = tempIncrementTaskDuration();


                              break;
                            case "أشهر":
                           currentTaskDuration.value = currentTaskDuration.value + (1*30);
                          tem.value = tempIncrementTaskDuration();

                              break;
                              case "سنوات":
                            currentTaskDuration.value = currentTaskDuration.value+ (1*360);
                          tem.value = tempIncrementTaskDuration();

                              break;
                            
                          }
                           
//                            print("here is the cuurent vlaue 2 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 2 ");
// print(tem);
// print ("here is the taskduraion value 2");
// print (totalTasksDuration);
        if (tem>goalduration){
                Get.snackbar("", "لا يمكن زيادة الفترة ،قيمة فjjترة المهام ستصبح أعلى من فترة الهدف  ",icon:Icon(Icons.alarm),barBlur: 20);
       
       switch (isSelected.value) {
                            case "أيام":
                           
                          currentTaskDuration.value = currentTaskDuration.value- 1;
                          tem.value = tempIncrementTaskDuration();
                              break;
                            case "أسابيع":
                            print(TaskDuration);
                            currentTaskDuration.value = currentTaskDuration.value- (1*7);
                          tem.value = tempIncrementTaskDuration();


                              break;
                            case "أشهر":
                           currentTaskDuration.value = currentTaskDuration.value - (1*30);
                          tem.value = tempIncrementTaskDuration();

                              break;
                              case "سنوات":
                            currentTaskDuration.value = currentTaskDuration.value-(1*360);
                          tem.value = tempIncrementTaskDuration();

                              break;
                            
                          }
//                           print("here is the cuurent vlaue 3 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 3");
// print(tem);
// print ("here is the taskduraion value 3");
// print (totalTasksDuration);
       
        }
       else
                          
     if(currentTaskDuration.value> goalduration ){
      switch (isSelected.value) {
                            case "أيام":
                           
                          currentTaskDuration.value = currentTaskDuration.value- 1;
                          tem.value = tempIncrementTaskDuration();
                              break;
                            case "أسابيع":
                            print(TaskDuration);
                            currentTaskDuration.value = currentTaskDuration.value- (1*7);
                          tem.value = tempIncrementTaskDuration();


                              break;
                            case "أشهر":
                           currentTaskDuration.value = currentTaskDuration.value - (1*30);
                          tem.value = tempIncrementTaskDuration();

                              break;
                              case "سنوات":
                            currentTaskDuration.value = currentTaskDuration.value-(1*360);
                          tem.value = tempIncrementTaskDuration();

                              break;
                            
                          }
//                           print("here is the cuurent vlaue 4 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 4");
// print(tem);
// print ("here is the taskduraion value 4");
// print (totalTasksDuration);
      storeStatusOpen(false);
  
      Get.snackbar("", "لا يمssكن زيادة الفترة ،قيمة فترة المهام ستصبح أعلى من فترة الهدف  ",icon:Icon(Icons.alarm),barBlur: 20);
     }else{
//       print("here is the cuurent vlaue 5 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 5");
// print(tem);
// print ("here is the taskduraion value 5");
// print (totalTasksDuration);
    TaskDuration.value++;
     }
   
  }

setdefult(){
// print("here is the cuurent vlaue 6 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 6");
// print(tem);
// print ("here is the taskduraion value 6");
// print (totalTasksDuration);
  TaskDuration.value=0;
  tem.value = tem.value - currentTaskDuration.value ;
  currentTaskDuration.value = 0 ; 
  
  
  
}

  dcrement(){
//  print("here is the cuurent vlaue 7");
// print(currentTaskDuration.value);
// print ("here is the temp value 7");
// print(tem);
// print ("here is the taskduraion value 7");
// print (totalTasksDuration);
    if(TaskDuration.value<= 0 ){

      Get.snackbar("", "قيمة الفترة لا يمكن ان تكون اقل من واحد",icon:Icon(Icons.alarm),barBlur: 20);
    }else{
    TaskDuration.value--;

     switch (isSelected.value) {
                            case "أيام":
                           
                          tem.value = tem.value -TaskDuration.value;
                                                    currentTaskDuration.value = TaskDuration.value;

                              break;
                            case "أسابيع":
                            print(TaskDuration);
                            tem.value = tem.value - (1*7);
                            currentTaskDuration.value = currentTaskDuration.value- (1*7);


                              break;
                            case "أشهر":
                          // tem.value =(tem-currentTaskDuration.value).abs();
                                                      tem.value = tem.value - (1*30);

                           currentTaskDuration.value = currentTaskDuration.value - (1*30);

                              break;
                              case "سنوات":
                                                          tem.value = tem.value - (1*360);

                            currentTaskDuration.value = currentTaskDuration.value- (1*360);

                              break;
                            
                          }
//             print("here is the cuurent vlaue 8 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 8");
// print(tem);
// print ("here is the taskduraion value 8");
// print (totalTasksDuration);              


    }
  }
int tempIncrementTaskDuration(){
  int tem  = totalTasksDuration.value ;
  tem = tem+currentTaskDuration.value;
  return tem ; 
}

// int tempdcrementTaskDuration(){
//   int tem  = totalTasksDuration.value ;
//   tem = (tem-currentTaskDuration.value).abs();
//   return tem ; 
// }
incrementTaskDuration(){
// print("here is the cuurent vlaue 9 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 9");
// print(tem);
// print ("here is the taskduraion valu e 9");
// print (totalTasksDuration);
  totalTasksDuration.value = totalTasksDuration.value + currentTaskDuration.value ; 
// print("here is the cuurent vlaue 10 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 10");
// print(tem);
// print ("here is the taskduraion value 10");
// print (totalTasksDuration);

}
dcrementTaskDuration(int deletedTaskDuration){
//  print("here is the cuurent vlaue 11 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 11");
// print(tem);
// print ("here is the taskduraion value 11");
// print (totalTasksDuration);
  totalTasksDuration.value = totalTasksDuration.value - deletedTaskDuration  ; 
// print("here is the cuurent vlaue 12 ");
// print(currentTaskDuration.value);
// print ("here is the temp value 12 ");
// print(tem);
// print ("here is the taskduraion value 12");
// print (totalTasksDuration);
 

}
}