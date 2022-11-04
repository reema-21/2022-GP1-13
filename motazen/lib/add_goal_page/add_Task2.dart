import 'package:flutter/material.dart';
import 'package:motazen/add_goal_page/get_chosen_aspect.dart';
import 'package:motazen/entities/task.dart';
import 'package:motazen/isar_service.dart';
import 'package:multiselect/multiselect.dart';

import '../pages/assesment_page/aler2.dart';


class AddTask extends StatefulWidget {
  final IsarService isr;
  final int goalId ;
  final int goalDurtion ;
  const AddTask({super.key, required this.isr, required this.goalId, required this.goalDurtion});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
 List<String> TasksName=[] ;
   List<String> selected = [];
    TextEditingController inputTaskName = TextEditingController();
    List<Task >goalTask = [];
late String TaskName ;
   void initState() {
    super.initState();
    inputTaskName.addListener(_updateText);

  } 

  void _updateText() {
    setState(() {
      
      TaskName = inputTaskName.text;
      

    });
  }

AddTheEnterdTask() async{
Task newTak = Task();
newTak.name=inputTaskName.text;
newTak.duration=5;
inputTaskName.text="";
widget.isr.saveTask(newTak);
setState(() {
  goalTask.add(newTak);
  print("iam at the fits setstate and here is the task sleceted form the mwnu");
  print(selected);
});








}


  
  
  
  
  
  
  
  
  
  
  
  
  Widget TaskDepencenies(){
      
      return DropDownMultiSelect(
        onChanged: (List<String> x) {
          setState(() {
            selected =x;
          });
        },
        options:TasksName ,
        selectedValues: selected,
        whenEmpty: 'Select Something',
      );
    }
  
  
  
  @override
  // String input="";
  final formKey = GlobalKey<FormState>();
  
 

  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(appBar:
        AppBar(
              backgroundColor: const Color(0xFF66BF77),
              title: const Text(
                "إضافة هدف جديد",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    // ignore: prefer_const_constructors
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () async {
                      final action = await AlertDialogs.yesCancelDialog(
                          context,
                          ' هل انت متاكد من الرجوع ',
                          'بالنقر على "تاكيد"لن يتم حفظ معلومات الهدف  ');
                      if (action == DialogsAction.yes) {
                         Navigator.push(context, MaterialPageRoute(builder: (context) {return getChosenAspect(iser: widget.isr,goalsTasks: goalTask,);}));
                      } else {
                                                 Navigator.push(context, MaterialPageRoute(builder: (context) {return getChosenAspect(iser: widget.isr,goalsTasks: goalTask,);}));

                      }
                    }),
              ],
            ),
          
        body: Column
        (children: [
          Expanded(
       
          child:Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              
                itemCount: goalTask.length,
                itemBuilder: (context, index) {
                  final goal = goalTask[index];
                  final name = goalTask[index].name;
                  final impo = goalTask[index].duration;
 if (name != null){
                TasksName.add(name);
                  }
                    
                  
                  
                  
                  return Card(
                    child: Text("$name"),
                  )
                  ;
                }),
          )
          ),
        
        
     


          //the list view where the tasks will be displayed 

// Container(
//   //add the taskdependcy as a dropdownMenue , add the duration 
//   padding: const EdgeInsets.symmetric(horizontal: 12.0 , vertical: 18.0),
//   decoration: const BoxDecoration(color: Color(0xFF66BF77),
                          
//   borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20) )),
//   child: Row(children:  [
//      Expanded(child: 
//     TextField(
//       controller: inputTaskName,
//       decoration: InputDecoration(hintText: "أضف مهمة جديدة "),
//     ),
//     ),
//     const SizedBox(
//       width: 15,
//     ),
    
//        TextButton(
//       onPressed: (){

//         AddTheEnterdTask();
//         setState(() {
//           isnotTheFirst = true ; 
//         });
//       },
//        child: const Icon(Icons.add),
      


       
       
       
//        ),

   
    
//   ]),
  
// ),
//     Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child:  
    
//        TaskDepencenies(isnotTheFirst),
//       ))   
      
        ],
        
       
        ),
floatingActionButton: FloatingActionButton(
  child: const Icon(Icons.add),

  onPressed: (){
    showDialog(context: context,
     builder: (BuildContext context) {
      return AlertDialog(
        title: Text("أضف مهمه جديدة",textDirection: TextDirection.rtl,),
        content: 
          Directionality(
            textDirection: TextDirection.rtl,
            child:
             Form(
                                key: formKey,

               child: SingleChildScrollView(
                child:Column(children: [
                  TextFormField(
                  validator: (value) {
                              if (value == null || value.isEmpty)
                                return "من فضلك ادخل اسم العادة";
                              // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                              //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                              // } 
                              else {
                                return null;
                              }
                            },
                  controller: inputTaskName,
                  // onChanged: (String value){
                  //   input=value  ;
                  //   setState(() {
                  //      if(input != "")
                  //    TasksName.add(input);
                  //   });
                   
                  
                           ),
               
               TaskDepencenies(),
               TextButton(
              onPressed: (){
                 if (formKey.currentState!.validate()){
                setState(() {
                  TasksName.add(inputTaskName.text);
                   AddTheEnterdTask();
                                    // TasksName.add(inputTaskName.text);
                                    // print("i am at the prssed button after adding");
                                    // print (TasksName);

                });
              }
              },
              child:Text("إضافة") ,
            ),
               ]
             ),
          ),
          
           
         
            
       
         
          
       
      ))
      ,);
      Navigator.of(context).pop();
    })
  ;
  }),
      ),
    );
    
  }
}