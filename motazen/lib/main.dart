import 'package:datatry/isar_service.dart';
import 'package:datatry/entities/aspect.dart';
import 'package:datatry/entities/point.dart';

import 'package:isar/isar.dart';//for local Storage
import 'dart:io';//for the directory
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart' ;
import 'package:flutter/material.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart';
import 'package:im_stepper/stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'var.dart'; // for the global varible
import 'alert_dialog.dart'; //for the alert
Future main() async {
 
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(); // to inizlize the db
  Directory doc = await getApplicationDocumentsDirectory();
  IsarService iser = IsarService();
  iser.openIsar(); 

  /********************************************* 
   Here i will fetch the quastion based on the chosen asspect 
   The output form here should be : 
   1- the quastion array containing all the quastion quastionsList
   2- steps number which is based on the quastion number activeASteps notice 
   3- Map to collect the answare where the key is the activestep and the value is the answars for start all are zeros.

   so here ifetch the quastion of each asspect usiing element 0 and put them in an array and then add this to the global array 
  ******************************************* */
  // at the end the answare mab will have as the value answarenumber+short of the aspect in char .
  /*Start if fetching quastion */
  Var.activeStep = 0; //always zero to start the stepper from thw first step .
  //take it as an array from Manar and reem code .
  List<Aspect> temaspect = [];

  temaspect = await iser.getAspectFirstTime();
  
  
  
  
  List<dynamic> templist = []; //temporary store each aspect quastion 
  int countr = 0 ; //to fill in the answer list 
  int endpoint = 0 ; // to know where to stop in  creating the answers list ; 
  for (int i = 0 ; i<temaspect.length;i++){ //the output of this loop is the quastion list and the answer list 
    Aspect aspect = temaspect[i];
    switch(aspect.name){ // include all the aspect make sure the index is write 
      case "money and finances":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(0));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0M";
   }
   endpoint= countr;
      break;
      case "Fun and Recreation":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(7));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0R";
   }
   endpoint= countr;
      break;
      case "career":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(6));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0C";
   }
   endpoint= countr;
      break;
      case "Significant Other":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(5));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0S";
   }
   endpoint= countr;
      break;
      case "Physical Environment":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(4));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0E";
   }
   endpoint= countr;
      break;
      case "Personal Growth":
      
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(3));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0G";
   }
   endpoint= countr;
      break;

      case "Health and Wellbeing":
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(2));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0H";
   }
   endpoint= countr;
      break; 
      case "Friends":
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(1));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0D";
   }
   endpoint= countr;
      break;
       case "Family":
     var aspectQuastions = await FirebaseFirestore.instance.collection("aspect_Quastion").get().then((value) => value.docs.elementAt(0));
     templist=Map<String, dynamic>.from(aspectQuastions.data()).values.toList(); 
     Var.quastionsList.addAll(templist);
   for (countr;countr<=templist.length-1+endpoint;countr++){
    Var.answares[countr]="0F";
   }
   endpoint= countr;
      break;
    }
  }

/**End of fetching quastions  */
  runApp( MaterialApp (home :IconStepperDemo(isr : iser ))); // my widget
}

class IconStepperDemo extends StatefulWidget {
  final IsarService isr ; 
  const IconStepperDemo({super.key, required this.isr});
  @override
  _IconStepperDemo createState() => _IconStepperDemo();
}

class _IconStepperDemo extends State<IconStepperDemo> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Initial step set to 0 to be Reversed start from the right .
  var upperBound = Var.quastionsList.length -
      1; // upperBound MUST BE total number of icons minus 1. // total numberofquastion-1 = activeSteps so that it start from the right
//------------------------------------------------------------
  double currentSliderValue = double.parse(Var.answares[Var.activeStep]
      .substring(0, Var.answares[Var.activeStep].length - 1));

  // always the value of the sliderRange = answare if no answare then zero
  //Start of the slider Range  = the answares of the quastion //
  Widget sliderRange() {
    return Slider.adaptive(
      //it should be good in ios or we use Cupertino
      value: currentSliderValue, //answare of that quastion
      min: 0,
      max: 10,
      divisions: 10, //to stick
      label: currentSliderValue.round().toString(), // to show the lable number
      onChanged: (double value) {
        setState(() {
          //save the value chosen by the user
          currentSliderValue = value;
          Var.answares[Var.activeStep] = "$value" +
              Var.answares[Var.activeStep].substring(Var
                      .answares[Var.activeStep].length -
                  1); //take the answare chosen by the user for that quastion
        });
      },
    );
  }

  /// End of the sliderRange  */

  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      home: Directionality(
          // <-- Add this Directionality
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color.fromRGBO(238, 238, 238, 1),
            appBar: AppBar(
              leading: IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(Icons.arrow_back,
                      color: const Color.fromARGB(255, 245, 241, 241)),
                  onPressed:() async {
            final action = await AlertDialogs.yesCancelDialog( context, 'هل انت متاكد من الرجوع ', 'بالنقر على "تاكيد"لن يتم حفظ الاجابات ');
            if(action == DialogsAction.yes) {
              //return to the previouse page different code for the ios .
             // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
            } else {
             print ("bey");
            }
          },

                  ),
              title: const Text(
                'اسئلة تقييم جوانب الحياة ',
              ),
              elevation: 0,
              
              flexibleSpace://for coloring
               Container(
                decoration:const BoxDecoration(
                  gradient:LinearGradient(
          // ignore: prefer_const_literals_to_create_immutables
          colors: [Color(0xff66bf77), Color(0xff3d82c4)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )
      
                )
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color:
                              Colors.grey[200],
                          borderRadius: BorderRadius.circular(0)),
                      child: IconStepper(
                        stepReachedAnimationEffect:Curves.linear,//stop the jumping 
                        lineColor: Colors.black,
                        stepColor: Colors.white,
                        activeStepColor: const Color.fromARGB(255, 165, 154, 154),
                        stepRadius: 20,
                        stepPadding: 0,
                        // move it to a function so that you take the aspect and the number of quastion = x and then you reapt the icon    x times
                        icons: createIcon(),

                        // activeStep property set to activeStep variable defined above.
                        activeStep: Var.activeStep,

                        // This ensures step-tapping updates the activeStep.
                        onStepReached: (index) {
                          setState(() {
                            // possible so for the below problem
                            /* if the answare has value then the value is the currenslide 
                    if not the value is 1 */

                            Var.activeStep = index;
                            currentSliderValue = double.parse(
                                Var.answares[Var.activeStep].substring(
                                    0,
                                    Var.answares[Var.activeStep].length -
                                        1)); // this is for reseting the slider for each quasion but the problem we want to save the value
                          });
                        },
                      )),
                  const SizedBox(
                    height: 40,
                  ),
                  header(), // apply quasion
                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(25)),
                    child: Column(
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          headerText(),
                           style: const TextStyle(color: Colors.white, fontSize:30)
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              textDirection:TextDirection.ltr,
                              children: [
                                buildSlideLable(10),
                                Expanded(
                                  child: sliderRange(),
                                ),
                                buildSlideLable(0),
                              ],
                            )),
                      ],
                    ),
                  ),

                  
                ],
              ),
              
            ),
            bottomSheet: doneButton(widget.isr),
          )),
    );
  }

  /// Returns the next button.

  /// Returns the header wrapping the header text.
  Widget header() {
    String start = (Var.activeStep + 1).toString();
    String last = (upperBound + 1).toString();
    return Text.rich(
      TextSpan(
        text: "السؤال $start ",
        style:const TextStyle(color: Colors.black54 , fontSize: 30,fontWeight: FontWeight.bold),
        children: [
          TextSpan(
            text: "/ $last",
            style:const TextStyle(color: Colors.black54 , fontSize: 30,fontWeight: FontWeight.bold)
          )
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.

  String headerText() {
    return Var.quastionsList[Var.activeStep];
  }

  List<Icon> createIcon() {
    // create the icons and the length of the IconsList based on the answare map
    List<Icon> iconStepper = [];
    for (int i = 0; i <= Var.quastionsList.length - 1; i++) {
      String aspect = Var.answares[i].substring(Var.answares[i].length - 1);
      switch (aspect) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            // statements;
            iconStepper.add(const Icon(
              Icons.spa,
              color: Colors.blue,
            ));
          }
          break;

        case "C":
          {
            //statements;
            iconStepper.add(const Icon(Icons.work, color: Colors.pink));
          }
          break;
        case "F":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.family_restroom,
              color: Colors.purple,
            ));
          }
          break;
           case "D":
          {
            //statements;
            iconStepper.add(const Icon(
                Icons.people,
              color: Colors.purple,
            ));
          }
          break;
           case "S":
          {
            
            //statements;
            iconStepper.add(const Icon(
              Icons.heart_broken,
              color: Colors.purple,
            ));
          }
          break;
           case "E":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.heart_broken,
              color: Colors.purple,
            ));
          }
          break;
          case "M":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.money,
              color: Colors.purple,
            ));
          }
          break;
          case "G":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.psychology,
              color: Colors.purple,
            ));
          }
          break;
          case "R":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.celebration,
              color: Colors.purple,
            ));
          }
          break;
      }
    }

    return iconStepper;
  }

  Widget buildSlideLable(double value) => Container(
        width: 25,
        child: Text(
          value.round().toString(),
          style: const TextStyle(color:Colors.white,fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

      Widget doneButton(IsarService isar){ //once all quastion answare and the user is n any quastion it will be enabeld  
      bool isAllQuastionAnswerd = true ; 
      for (int i =0; i<Var.answares.length ;i++ ){
        var result =double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
        if (result == 0 ){
            isAllQuastionAnswerd = false ;
        }
      }// to check whether all the quastions are answerd or not .
        return ElevatedButton(onPressed: isAllQuastionAnswerd? () { 

          Evaluate(widget.isr); 

            
            } :null,child: const Text("انتهيت "),);   
}

Evaluate (IsarService isar){
  //calculate each aspect points ; 
  /**
   * 1- i will seprate answers array into answareArrays for each aspect ; 
   * 2- if the arrays is null then this aspect is not choosed . 
   * 3- if the arrays is null then the aspect is not choosed . 
   * 4- if the arrays hass value then sum and devide and save into the points collection .
   */
 double moneyAspectPoints = 0 ; 
 double familyAspectPoints  = 0 ; 
 double friendsAspectPoints  = 0 ; 
 double healthAndWellbeingAspectPoints  = 0;
 double personalGrowthAspectPoints  = 0; 
 double physicalEnvironmentAspectPoints  = 0 ; 
 double significantOtherAspectPoints  = 0 ;
 double CareerAspectPoints = 0 ; 
 double funAndRecreationAspectPoints = 0 ; 

for (int i= 0 ; i<Var.answares.length ;i++){ // i will sunm the point of each aspect ; 
 String aspectType = Var.answares[i].substring(Var.answares[i].length - 1);
 double x = 0 ; 
 switch (aspectType) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
            healthAndWellbeingAspectPoints =healthAndWellbeingAspectPoints+x;
           
          }
          break;

        case "C":
          {
           x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
           CareerAspectPoints=CareerAspectPoints+x;

            
          }
          break;
        case "F":
          {
           x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
           familyAspectPoints=familyAspectPoints+x;

          
          }
          break;
           case "D":
          {
          x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
          friendsAspectPoints=friendsAspectPoints+x;
          
          }
          break;
           case "S":
          {
           x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
           significantOtherAspectPoints=significantOtherAspectPoints+x;
           
          }
          break;
           case "E":
          {
           x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
           physicalEnvironmentAspectPoints=physicalEnvironmentAspectPoints+x;


          
          }
          break;
          case "M":
          {          
            x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
            funAndRecreationAspectPoints=funAndRecreationAspectPoints+x;


          }
          break;
          case "G":
          {
          x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
          personalGrowthAspectPoints=personalGrowthAspectPoints+x;

            
          }
          break;
          case "R":

          {
              x = double.parse(Var.answares[i].substring(0,Var.answares[i].length -1));
             funAndRecreationAspectPoints=funAndRecreationAspectPoints+x;
           
          
          }
          break;
      }

}



   
  final Aspect aspect = Aspect();
  aspect.name= "Friends";
  isar.createAspect(aspect);



}

}