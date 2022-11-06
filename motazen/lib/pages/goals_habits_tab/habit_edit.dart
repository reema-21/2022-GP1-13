// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '/entities/habit.dart';
import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';

import 'getChosenAspectEh.dart';

//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency
class EditHbit extends StatefulWidget {
  final IsarService isr;
  final int HabitId;
  const EditHbit({super.key, required this.isr, required this.HabitId});

  @override
  State<EditHbit> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditHbit> {
  TextEditingController displayHabitNameControlller = TextEditingController();
  TextEditingController displayHabitfrequencyControlller =
      TextEditingController();

  String habitAspect = ""; //for the dropMenu A must
  String frequency = ""; //for the importance if any
int durationInNumber = 0 ;
int durationIndex =0 ; 
  Habit? habit;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getHabitInformation();
    // might be deleted .
  }

  getHabitInformation() async {
    habit = await widget.isr.getSepecificHabit(widget.HabitId);

    setState(() {
      displayHabitNameControlller.text = habit!.titel;
      displayHabitfrequencyControlller.text = habit!.frequency;
durationIndex=habit!.durationIndString;
durationInNumber=habit!.durationInNumber;
      print(displayHabitNameControlller.text);
      habitAspect = habit!.aspect.value!.name;
      switch (habitAspect) {
        case "money and finances":
          habitAspect = "أموالي";
          break;
        case "Fun and Recreation":
          habitAspect = "متعتي";
          break;
        case "career":
          habitAspect = "مهنتي";
          break;
        case "Significant Other":
          habitAspect = "علاقاتي";
          break;
        case "Physical Environment":
          habitAspect = "بيئتي";
          break;
        case "Personal Growth":
          habitAspect = "ذاتي";
          break;

        case "Health and Wellbeing":
          habitAspect = "صحتي";
          break;
        case "Family and Friends":
          habitAspect = "عائلتي وأصدقائي";
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
              floatingActionButton: FloatingActionButton(
                onPressed:(){  Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return getChosenAspectEh(
                          isr: widget.isr,
                          habitAspect: habitAspect,
                          habitFrequency: displayHabitfrequencyControlller.text,
                          HabitName: displayHabitNameControlller.text,
                          id: widget.HabitId,
                          durationInNumber: durationInNumber,
                          durationIndString: durationIndex,
                        ); // must be the
                      }));
},
                backgroundColor:  Color.fromARGB(255, 252, 252, 252),
                child:Icon(Icons.edit, color:  Color(0xFF66BF77), ),
                ),
              backgroundColor:  Color.fromARGB(255, 255, 255, 255),
                        
 body:Container(
  padding: const EdgeInsets.only(
    top: 60,
    left:20,
    right: 20,
    bottom: 40,
  ),
  child: Column(
    children: [
    
    Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
                                Text("معلومات العادة" ,style: TextStyle(color: Color.fromARGB(255, 0, 0, 0) ,fontSize: 30))
 ,SizedBox(
                          width: 170,
                        ),
      IconButton(
                        // ignore: prefer_const_constructors
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Goals_habit(iser: widget.isr);
                          }));
                        }),
                       
                  ],
    ),
    SizedBox(
       height: 20,
    ),
    Expanded(
      child: Container(
        decoration: BoxDecoration(
          color:  Color.fromARGB(66, 102, 191, 118),
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
         child:Stack(children: [
          ClipPath(
clipper: WaveClipperTwo(),
            child: Container(
              height: 100,
              color: Color.fromARGB(255, 255, 253, 254),
            )
          ),
             Container(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            const Text(
                              "اسم العادى:",
                              style: TextStyle(fontSize: 23),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                                                            displayHabitNameControlller.text,

                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black54),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "جانب الحياة:",
                              style: TextStyle(fontSize: 23),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              habitAspect,
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black54),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "عدد مرات تكرار العادة",
                              style: TextStyle(fontSize: 23),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              displayHabitfrequencyControlller.text,
                              style: const TextStyle(
                                  fontSize: 22, color: Colors.black54),
                            )
                          ],
                        )
                    ]
             )
         )]))
      )
    ])
    )
    
  )
        )
    );
    
    

  

      



         



        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  }

//   Widget buildTextField(String labelText ,String placeholder){
//     return Padding(padding: EdgeInsets.only(bottom: 30),

//     child: TextField(
//       decoration: InputDecoration(
//         contentPadding: EdgeInsets.only(bottom: 5 ),
//         labelText:labelText,
//         floatingLabelBehavior:FloatingLabelBehavior.always,
// hintText: placeholder,
// hintStyle: TextStyle

//       ),
//     ),

//     );
//   }
}
