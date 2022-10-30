// ignore_for_file: file_names, non_constant_identifier_names

import 'package:motazen/theme.dart';

import '../get_points.dart';
import '/isar_service.dart';
import '/entities/aspect.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'alert_dialog.dart';
import 'assesmentQuestionPageGlobals.dart';
import "package:motazen/select_aspectPage/select_aspect.dart";
import"show.dart";
class WheelOfLifeAssessmentPage extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? question;
  final List<dynamic>? fixedAspect;
  final List<dynamic>? chosenAspect;

  static double upperBound = 0;
  const WheelOfLifeAssessmentPage(
      {super.key,
      required this.isr,
      required this.question,
      this.fixedAspect,
      this.chosenAspect});
  @override
  State<WheelOfLifeAssessmentPage> createState() => _WheelOfLifeAssessmentPage();
}

class _WheelOfLifeAssessmentPage extends State<WheelOfLifeAssessmentPage> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Initial step set to 0 to be Reversed start from the right .
  // upperBound MUST BE total number of icons minus 1. // total numberofquastion-1 = AssesmentQuestionPageGlobals.activeSteps so that it start from the right
//------------------------------------------------------------
  // always the value of the sliderRange = answare if no answare then zero
  //Start of the slider Range  = the answares of the quastion //
  Widget sliderRange() {
    return Slider.adaptive(
      //it should be good in ios or we use Cupertino
      value: AssesmentQuestionPageGlobals
          .currentSliderValue, //answare of that quastion
      min: 0,
      max: 10,
      divisions: 10, //to stick
      activeColor: kPrimaryColor,

      label: AssesmentQuestionPageGlobals.currentSliderValue
          .round()
          .toString(), // to show the lable number
      onChanged: (double value) {
        setState(() {
          //save the value chosen by the user
          AssesmentQuestionPageGlobals.currentSliderValue = value;
          AssesmentQuestionPageGlobals.answares[
              AssesmentQuestionPageGlobals
                  .activeStep] = '$value' +
              AssesmentQuestionPageGlobals
                  .answares[AssesmentQuestionPageGlobals.activeStep]
                  .substring(AssesmentQuestionPageGlobals
                          .answares[AssesmentQuestionPageGlobals.activeStep]
                          .length -
                      1); //take the answare chosen by the user for that quastion
        });
      },
    );
  }

  /// End of the sliderRange  */
  @override
  Widget build(BuildContext context) {
    return Directionality(
        // <-- Add this Directionality
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.arrow_forward_ios, color: kBlackColor),
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      'هل انت متاكد من الرجوع ',
                      'بالنقر على "تاكيد"لن يتم حفظ الاجابات ');
                  if (action == DialogsAction.yes) {
                    //return to the previouse page different code for the ios .
                    List<dynamic> tempAspect =
                        await widget.isr.getAspectFirstTime();
                    widget.isr.deleteAllAspects(tempAspect);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AspectSelection(
                        isr: widget.isr,
                        aspects: widget.fixedAspect,
                      );
                    }));
                  }
                },
              ),
            ],
            title: const Text(
              'اسئلة تقييم جوانب الحياة ',
              style: TextStyle(
                color: kBlackColor,
              ),
            ),
            elevation: 0,
            backgroundColor: kWhiteColor,
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(0)),
                    child: IconStepper(
                      stepReachedAnimationEffect:
                          Curves.linear, //stop the jumping
                      lineColor: Colors.black,
                      stepReachedAnimationDuration:
                          const Duration(milliseconds: 200),
                      activeStepColor: kWhiteColor,
                      stepColor: kDisabled,
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
                          AssesmentQuestionPageGlobals.currentSliderValue =
                              double.parse(AssesmentQuestionPageGlobals
                                  .answares[
                                      AssesmentQuestionPageGlobals.activeStep]
                                  .substring(
                                      0,
                                      AssesmentQuestionPageGlobals
                                              .answares[
                                                  AssesmentQuestionPageGlobals
                                                      .activeStep]
                                              .length -
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
                Hero(
                  ///can be added in a different page
                  tag: 'question-card',
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      elevation: 10.0,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            textDirection: TextDirection.rtl,
                            children: [
                              Text(headerText(),
                                  style: const TextStyle(
                                      color: kBlackColor, fontSize: 30)),
                              Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  buildSlideLable(10),
                                  Expanded(
                                    child: sliderRange(),

                                    /// it takes a widget as a child
                                  ),
                                  buildSlideLable(0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: doneButton(widget.isr),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  /// Returns the next button.

  /// Returns the header wrapping the header text.
  Widget header() {
    var upperBound = widget.question!.length - 1;
    String start = (AssesmentQuestionPageGlobals.activeStep + 1).toString();
    String last = (upperBound + 1).toString();
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Text.rich(
        TextSpan(
          text: "السؤال $start ",
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 30,
          ),
          children: [
            TextSpan(
                text: "/ $last",
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 30,
                ))
          ],
        ),
      ),
    );
  }

  // Returns the header text based on the AssesmentQuestionPageGlobals.activeStep.

  String headerText() {
    ///can be added to a different page
    return widget.question?[AssesmentQuestionPageGlobals.activeStep];
  }

  List<Icon> createIcon() {
    // create the icons and the length of the IconsList based on the answare map
    List<Icon> iconStepper = [];

    for (int i = 0; i < widget.question!.length; i++) {
      String aspect = AssesmentQuestionPageGlobals.answares[i]
          .substring(AssesmentQuestionPageGlobals.answares[i].length - 1);

      switch (aspect) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            // statements;
            iconStepper.add(const Icon(Icons.spa, color: Color(0xFFffd400)));
          }
          break;

        case "C":
          {
            //statements;
            iconStepper.add(const Icon(Icons.work, color: Color(0xff0065A3)));
          }
          break;
        case "F":
          {
            //statements;
            iconStepper.add(const Icon(Icons.person, color: Color(0xFFff9100)));
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
              Icons.favorite,
              color: Color(0xffff4949),
            ));
          }
          break;
        case "E":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.home,
              color: Color(0xFF9E19F0),
            ));
          }
          break;
        case "M":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.attach_money,
              color: Color(0xff54e360),
            ));
          }
          break;
        case "G":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.psychology,
              color: Color(0xFF2CDDCB),
            ));
          }
          break;
        case "R":
          {
            //statements;
            iconStepper.add(const Icon(
              Icons.games,
              color: Color(0xff008adf),
            ));
          }
          break;
      }
    }

    return iconStepper;
  }

  Widget buildSlideLable(double value) => SizedBox(
        width: 25,
        child: Text(
          value.round().toString(),
          style: const TextStyle(
              color: kBlackColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );

  Widget doneButton(IsarService isar) {
    //once all quastion answare and the user is n any quastion it will be enabeld
    bool isAllQuastionAnswerd = true;
    for (int i = 0; i < AssesmentQuestionPageGlobals.answares.length; i++) {
      var result = double.parse(AssesmentQuestionPageGlobals.answares[i]
          .substring(0, AssesmentQuestionPageGlobals.answares[i].length - 1));
      if (result == 0) {
        isAllQuastionAnswerd = false;
      }
    } // to check whether all the quastions are answerd or not .
    return ElevatedButton(
      onPressed: isAllQuastionAnswerd
          ? () {
              Evaluate(widget.isr);
//the nevigator is downs
            }
          : null,
      child: const Text("انتهيت "),
    );
  }

  Evaluate(IsarService isar) async {
    ///can be added to a different page
    //calculate each aspect points ;
    /**
   * 1- i will seprate answers array into answareArrays for each aspect ; 
   * 2- if the arrays is null then this aspect is not choosed . 
   * 3- if the arrays is null then the aspect is not choosed . 
   * 4- if the arrays hass value then sum and devide and save into the points collection .
   */
    double moneyAspectPoints = 0;
    double familyAndFriendsAspectPoints = 0;
    double healthAndWellbeingAspectPoints = 0;
    double personalGrowthAspectPoints = 0;
    double physicalEnvironmentAspectPoints = 0;
    double significantOtherAspectPoints = 0;
    double CareerAspectPoints = 0;
    double funAndRecreationAspectPoints = 0;

    for (int i = 0; i < AssesmentQuestionPageGlobals.answares.length; i++) {
      // i will sunm the point of each aspect ;
      String aspectType = AssesmentQuestionPageGlobals.answares[i]
          .substring(AssesmentQuestionPageGlobals.answares[i].length - 1);
      double x = 0;
      switch (aspectType) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            healthAndWellbeingAspectPoints = healthAndWellbeingAspectPoints + x;
          }
          break;

        case "C":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            CareerAspectPoints = CareerAspectPoints + x;
          }
          break;
        case "F":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            familyAndFriendsAspectPoints = familyAndFriendsAspectPoints + x;
          }
          break;

        case "S":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            significantOtherAspectPoints = significantOtherAspectPoints + x;
          }
          break;
        case "E":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            physicalEnvironmentAspectPoints =
                physicalEnvironmentAspectPoints + x;
          }
          break;
        case "M":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            moneyAspectPoints = moneyAspectPoints + x;
          }
          break;
        case "G":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            personalGrowthAspectPoints = personalGrowthAspectPoints + x;
          }
          break;
        case "R":
          {
            x = double.parse(AssesmentQuestionPageGlobals.answares[i].substring(
                0, AssesmentQuestionPageGlobals.answares[i].length - 1));
            funAndRecreationAspectPoints = funAndRecreationAspectPoints + x;
          }
          break;
      }

////////////////////find the percentage for the points and save it in the local storage///////////////
    }
    if (moneyAspectPoints != 0) {
      final Aspect aspect =
          Aspect(); // this should be the same as the one created above ;
      aspect.name = "money and finances";
      double point = (moneyAspectPoints / 50) * 100;
      isar.assignPointAspect("money and finances", point);
    }
    if (funAndRecreationAspectPoints != 0) {
      double point = (funAndRecreationAspectPoints / 40) * 100;
      isar.assignPointAspect("Fun and Recreation", point);
    }
    if (healthAndWellbeingAspectPoints != 0) {
      double point = (healthAndWellbeingAspectPoints / 50) * 100;
      isar.assignPointAspect("Health and Wellbeing", point);
    }
    if (significantOtherAspectPoints != 0) {
      double point = (significantOtherAspectPoints / 40) * 100;
      isar.assignPointAspect("Significant Other", point);
    }
    if (physicalEnvironmentAspectPoints != 0) {
      double point = (physicalEnvironmentAspectPoints / 50) * 100;
      isar.assignPointAspect("Physical Environment", point);
    }
    if (personalGrowthAspectPoints != 0) {
      double point = (personalGrowthAspectPoints / 40) * 100;
      isar.assignPointAspect("Personal Growth", point);
    }
    if (familyAndFriendsAspectPoints != 0) {
      double point = (familyAndFriendsAspectPoints / 90) * 100;
      isar.assignPointAspect("Family and Friends", point);
    }
    if (CareerAspectPoints != 0) {
      double point = (CareerAspectPoints / 40) * 100;
      isar.assignPointAspect("career", point);
    }
    List<Aspect> tempAspect =
        []; //store the fetched chosen aspect from the user
    tempAspect = await isar.getAspectFirstTime();
    //delete the aspects you have create a new one with the values you have

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AspectPoints(isr: widget.isr, aspects: tempAspect);
    }));
  }
}
