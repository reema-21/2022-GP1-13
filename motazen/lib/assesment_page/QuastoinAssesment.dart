
import '/isar_service.dart';
import '/entities/aspect.dart';
import '/entities/point.dart';
//for the directory
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'alert_dialog.dart'; //for the alert
import '/pages/homepage/homepage.dart';
import 'assesmentQuestionPageGlobals.dart';
class IconStepperDemo extends StatefulWidget {
final IsarService isr;
final List<dynamic>? q ;
static double  upperBound = 0;
 IconStepperDemo({super.key, required this.isr , required this.q});
  @override
  State <IconStepperDemo> createState() => _IconStepperDemo();
}
class _IconStepperDemo extends State<IconStepperDemo> {
 
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Initial step set to 0 to be Reversed start from the right .
   // upperBound MUST BE total number of icons minus 1. // total numberofquastion-1 = AssesmentQuestionPageGlobals.activeSteps so that it start from the right
//------------------------------------------------------------
  // always the value of the sliderRange = answare if no answare then zero
  //Start of the slider Range  = the answares of the quastion //
  Widget sliderRange() {
    return Slider.adaptive(
      //it should be good in ios or we use Cupertino
      value: AssesmentQuestionPageGlobals.currentSliderValue, //answare of that quastion
      min: 0,
      max: 10,
      divisions: 10, //to stick
      label: AssesmentQuestionPageGlobals.currentSliderValue.round().toString(), // to show the lable number
      onChanged: (double value) {
        setState(() {
          //save the value chosen by the user
          AssesmentQuestionPageGlobals.currentSliderValue = value;
          AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep] = "$value" +
              AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep].substring(AssesmentQuestionPageGlobals
                      .answares[AssesmentQuestionPageGlobals.activeStep].length -
                  1); //take the answare chosen by the user for that quastion
        });
      },
    );
  }

  /// End of the sliderRange  */
 @override

  Widget build(BuildContext context) {

// setState(() {
// widget.q?=AssesmentQuestionPageAssignments().returnThefinalValue();
//   print (widget.q?);
//   IconStepperDemo.upperBound = widget.q?.length -1;
//   AssesmentQuestionPageGlobals.currentSliderValue = double.parse(AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep]
//       .substring(0, AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep].length - 1));
// });

        
    
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
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      'هل انت متاكد من الرجوع ',
                      'بالنقر على "تاكيد"لن يتم حفظ الاجابات ');
                  if (action == DialogsAction.yes) {
                    //return to the previouse page different code for the ios .
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
                  } else {
                    print("bey");
                  }
                },
              ),
              title: const Text(
                'اسئلة تقييم جوانب الحياة ',
              ),
              elevation: 0,
              flexibleSpace: //for coloring
                  Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                // ignore: prefer_const_literals_to_create_immutables
                colors: [Color(0xff66bf77), Color(0xff3d82c4)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ))),
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
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(0)),
                      child: IconStepper(
                        stepReachedAnimationEffect:
                            Curves.linear, //stop the jumping
                        lineColor: Colors.black,
                        stepColor: Colors.white,
                        activeStepColor:
                            const Color.fromARGB(255, 165, 154, 154),
                        stepRadius: 20,
                        stepPadding: 0,
                        // move it to a function so that you take the aspect and the number of quastion = x and then you reapt the icon    x times
                        icons: createIcon(),

                        // AssesmentQuestionPageGlobals.activeStep property set to AssesmentQuestionPageGlobals.activeStep variable defined above.
                        activeStep: AssesmentQuestionPageGlobals.activeStep,

                        // This ensures step-tapping updates the AssesmentQuestionPageGlobals.activeStep.
                        onStepReached: (index) {
                          setState(() {
                            // possible so for the below problem
                            /* if the answare has value then the value is the currenslide 
                    if not the value is 1 */

                            AssesmentQuestionPageGlobals.activeStep = index;
                            AssesmentQuestionPageGlobals.currentSliderValue = double.parse(
                                AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep].substring(
                                    0,
                                    AssesmentQuestionPageGlobals.answares[AssesmentQuestionPageGlobals.activeStep].length -
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
                        
                        Text(headerText(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 30)),
                        Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(20),
                            child: Row(
                              textDirection: TextDirection.ltr,
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
    var upperBound = widget.q!.length-1;
    String start = (AssesmentQuestionPageGlobals.activeStep + 1).toString();
    String last = (upperBound + 1).toString();
    return Text.rich(
      TextSpan(
        text: "السؤال $start ",
        style: const TextStyle(
            color: Colors.black54, fontSize: 30, fontWeight: FontWeight.bold),
        children: [
          TextSpan(
              text: "/ $last",
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 30,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  // Returns the header text based on the AssesmentQuestionPageGlobals.activeStep.

  String headerText() {
    return widget.q?[AssesmentQuestionPageGlobals.activeStep];
  }

  List<Icon> createIcon() {
    // create the icons and the length of the IconsList based on the answare map
    List<Icon> iconStepper = [];
    for (int i = 0; i <= widget.q!.length-1; i++) {
      String aspect = AssesmentQuestionPageGlobals.answares[i].substring(AssesmentQuestionPageGlobals.answares[i].length - 1);
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
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget doneButton(IsarService isar) {
    //once all quastion answare and the user is n any quastion it will be enabeld
    bool isAllQuastionAnswerd = true;
    for (int i = 0; i < AssesmentQuestionPageGlobals.answares.length; i++) {
      var result = double.parse(
          AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
      if (result == 0) {
        isAllQuastionAnswerd = false;
      }
    } // to check whether all the quastions are answerd or not .
    return ElevatedButton(
      onPressed: isAllQuastionAnswerd
          ? () {
              Evaluate(widget.isr);

              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const Homepage();
              }));
            }
          : null,
      child: const Text("انتهيت "),
    );
  }

  Evaluate(IsarService isar) async {
    
    
    
    //calculate each aspect points ;
    /**
   * 1- i will seprate answers array into answareArrays for each aspect ; 
   * 2- if the arrays is null then this aspect is not choosed . 
   * 3- if the arrays is null then the aspect is not choosed . 
   * 4- if the arrays hass value then sum and devide and save into the points collection .
   */
    double moneyAspectPoints = 0;
    double familyAspectPoints = 0;
    double friendsAspectPoints = 0;
    double healthAndWellbeingAspectPoints = 0;
    double personalGrowthAspectPoints = 0;
    double physicalEnvironmentAspectPoints = 0;
    double significantOtherAspectPoints = 0;
    double CareerAspectPoints = 0;
    double funAndRecreationAspectPoints = 0;

    for (int i = 0; i < AssesmentQuestionPageGlobals.answares.length; i++) {
      // i will sunm the point of each aspect ;
      String aspectType = AssesmentQuestionPageGlobals.answares[i].substring(AssesmentQuestionPageGlobals.answares[i].length - 1);
      double x = 0;
      switch (aspectType) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            healthAndWellbeingAspectPoints = healthAndWellbeingAspectPoints + x;
          }
          break;

        case "C":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            CareerAspectPoints = CareerAspectPoints + x;
          }
          break;
        case "F":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            familyAspectPoints = familyAspectPoints + x;
          }
          break;
        case "D":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            friendsAspectPoints = friendsAspectPoints + x;
          }
          break;
        case "S":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            significantOtherAspectPoints = significantOtherAspectPoints + x;
          }
          break;
        case "E":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            physicalEnvironmentAspectPoints =
                physicalEnvironmentAspectPoints + x;
          }
          break;
        case "M":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            moneyAspectPoints = moneyAspectPoints + x;
          }
          break;
        case "G":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            personalGrowthAspectPoints = personalGrowthAspectPoints + x;
          }
          break;
        case "R":
          {
            x = double.parse(
                AssesmentQuestionPageGlobals.answares[i].substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            funAndRecreationAspectPoints = funAndRecreationAspectPoints + x;
          }
          break;
      }

      //devide and create points and save in local storage .

    }
    if (moneyAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "money and finances";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = moneyAspectPoints / 50;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (funAndRecreationAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Fun and Recreation";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = funAndRecreationAspectPoints / 40;
      point.finalValues=point.finalValues*100;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (healthAndWellbeingAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Health and Wellbeing";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = healthAndWellbeingAspectPoints / 50;
      point.finalValues=point.finalValues*100;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (significantOtherAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Significant Other";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = significantOtherAspectPoints / 40;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (physicalEnvironmentAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Physical Environment";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = physicalEnvironmentAspectPoints / 40;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (personalGrowthAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Personal Growth";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = personalGrowthAspectPoints / 40;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (familyAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Family";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = familyAspectPoints / 40;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (friendsAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "Friends";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = friendsAspectPoints / 50;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }
    if (CareerAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "career";
      isar.createAspect(aspect);
      final Point point = Point();
      point.finalValues = CareerAspectPoints / 40;
      point.aspect.value = aspect; //because it is linked .
      isar.createPoint(point);
    }

    
  }



}
