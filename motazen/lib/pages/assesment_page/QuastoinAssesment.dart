// ignore_for_file: file_names, non_constant_identifier_names, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'package:get/get.dart';
import 'package:motazen/isarService.dart';
import 'package:motazen/pages/select_aspectPage/handle_aspect_data.dart';

import '/theme.dart';
import 'package:provider/provider.dart';

import '../add_goal_page/get_chosen_aspect.dart';
import '../../data/data.dart';
import '/entities/aspect.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';
import 'assesment_question_page_assignments.dart';

class WheelOfLifeAssessmentPage extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? question;
  final List<dynamic>? fixedAspect;
  final List<dynamic>? unselectedAspects;
  final List<dynamic>? chosenAspect;

  static double upperBound = 0;
  const WheelOfLifeAssessmentPage(
      {super.key,
      required this.isr,
      required this.question,
      this.fixedAspect,
      this.chosenAspect,
      this.unselectedAspects});
  @override
  State<WheelOfLifeAssessmentPage> createState() =>
      _WheelOfLifeAssessmentPage();
}

class _WheelOfLifeAssessmentPage extends State<WheelOfLifeAssessmentPage> {
  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  // Initial step set to 0 to be Reversed start from the right .
  // upperBound MUST BE total number of icons minus 1. // total numberofquastion-1 = AssessmentQuestions.activeSteps so that it start from the right
//------------------------------------------------------------
  // always the value of the sliderRange = answare if no answare then zero
  //Start of the slider Range  = the answers of the quastion //
  Widget setQuestionAnswer() {
    return SliderTheme(
      data: const SliderThemeData(
        trackHeight: 5,
        thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 14.0,
          pressedElevation: 8.0,
        ),
        valueIndicatorShape: PaddleSliderValueIndicatorShape(),
        valueIndicatorColor: Colors.black,
        valueIndicatorTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        ),
      ),
      child: Slider(
        //it should be good in ios or we use Cupertino
        value:
            AssessmentQuestions.currentChosenAnswer, //answare of that quastion
        min: 1,
        max: 10,
        divisions: 10, //to stick
        activeColor: kPrimaryColor,

        label: AssessmentQuestions.currentChosenAnswer
            .round()
            .toString(), // to show the lable number
        onChanged: (double value) {
          setState(() {
            //save the value chosen by the user
            AssessmentQuestions.currentChosenAnswer = value;
            AssessmentQuestions.answers[
                AssessmentQuestions
                    .activeStep] = '$value' +
                AssessmentQuestions.answers[AssessmentQuestions.activeStep]
                    .substring(AssessmentQuestions
                            .answers[AssessmentQuestions.activeStep].length -
                        1); //take the answare chosen by the user for that quastion
          });
        },
      ),
    );
  }

  /// End of the sliderRange  */
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تقييم جوانب الحياة',
                textDirection: TextDirection.rtl,
                style: titleText,
              ),
              Text('ادخل اجابتك بإستخدام المؤشر',
                  textDirection: TextDirection.rtl, style: subTitle),
              Text('10 (ينطبق دائما) - 1 (نادراً ما ينطبق)',
                  textDirection: TextDirection.rtl, style: subTitle),
            ]),
        toolbarHeight: 120,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
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
                      // move it to a function so that you take the aspect and the number of quastion = x and then you reapt the icon x times
                      icons: createIcon(),

                      // AssessmentQuestions.activeStep property set to AssessmentQuestions.activeStep variable defined above.
                      activeStep: AssessmentQuestions.activeStep,

                      // This ensures step-tapping updates the AssessmentQuestions.activeStep.
                      onStepReached: (index) {
                        setState(() {
                          // possible so for the below problem
                          /* if the answare has value then the value is the currenslide 
                    if not the value is 1 */

                          AssessmentQuestions.activeStep = index;
                          AssessmentQuestions.currentChosenAnswer =
                              double.parse(AssessmentQuestions
                                  .answers[AssessmentQuestions.activeStep]
                                  .substring(
                                      0,
                                      AssessmentQuestions
                                              .answers[AssessmentQuestions
                                                  .activeStep]
                                              .length -
                                          1));
                        });
                      },
                    )),
                const SizedBox(
                  height: 16,
                ),
                header(), // progress
                const Divider(
                  color: Colors.white,
                  thickness: 0.5,
                ),
                const SizedBox(
                  height: 5,
                ),
                //question card
                Hero(
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
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                textDirection: TextDirection.ltr,
                                children: [
                                  buildSlideLable(10),
                                  Expanded(
                                    child: setQuestionAnswer(),

                                    /// it takes a widget as a child
                                  ),
                                  buildSlideLable(1),
                                ],
                              ),
                              //--------------------------------------here is what you tried -----------------//
                              Text(
                                "الإجابة: ${AssessmentQuestions.currentChosenAnswer.round()}",
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
                    child: doneButton(widget.isr, aspectList.allAspects),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Returns the next button.

  /// Returns the header wrapping the header text.
  Widget header() {
    var upperBound = widget.question!.length - 1;
    String start = (AssessmentQuestions.activeStep + 1).toString();
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

  // Returns the header text based on the AssessmentQuestions.activeStep.

  String headerText() {
    ///can be added to a different page (note: sometimes crashes)
    return widget.question?[AssessmentQuestions.activeStep];
  }

  List<Icon> createIcon() {
    // create the icons and the length of the IconsList based on the answare map
    List<Icon> iconStepper = [];

    for (int i = 0; i < widget.question!.length; i++) {
      String aspect = AssessmentQuestions.answers[i]
          .substring(AssessmentQuestions.answers[i].length - 1);

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
              color: kBlackColor, fontSize: 18, fontFamily: 'Frutiger'),
        ),
      );

  Widget doneButton(IsarService isar, List<Aspect> allAspects) {
    //once all quastion answare and the user is n any quastion it will be enabeld
    bool isAllQuastionAnswerd = true;
    for (int i = 0; i < AssessmentQuestions.answers.length; i++) {
      var result = double.parse(AssessmentQuestions.answers[i]
          .substring(0, AssessmentQuestions.answers[i].length - 1));
      if (result == 0) {
        isAllQuastionAnswerd = false;
      }
    } // to check whether all the quastions are answerd or not .
    return ElevatedButton(
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll<Color>(kPrimaryColor),
        padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(kDefaultPadding),
        textStyle: MaterialStatePropertyAll<TextStyle>(TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Frutiger',
        )),
      ),
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
    List<double> allpoints = [0, 0, 0, 0, 0, 0, 0, 0];

    for (int i = 0; i < AssessmentQuestions.answers.length; i++) {
      // i will sum the point of each aspect ;
      String aspectType = AssessmentQuestions.answers[i]
          .substring(AssessmentQuestions.answers[i].length - 1);
      double x = 0;
      switch (aspectType) {
        //Must include all the aspect characters and specify an icon for that
        case "H":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            healthAndWellbeingAspectPoints = healthAndWellbeingAspectPoints + x;
          }
          break;

        case "C":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            CareerAspectPoints = CareerAspectPoints + x;
          }
          break;
        case "F":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            familyAndFriendsAspectPoints = familyAndFriendsAspectPoints + x;
          }
          break;

        case "S":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            significantOtherAspectPoints = significantOtherAspectPoints + x;
          }
          break;
        case "E":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            physicalEnvironmentAspectPoints =
                physicalEnvironmentAspectPoints + x;
          }
          break;
        case "M":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            moneyAspectPoints = moneyAspectPoints + x;
          }
          break;
        case "G":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
            personalGrowthAspectPoints = personalGrowthAspectPoints + x;
          }
          break;
        case "R":
          {
            x = double.parse(AssessmentQuestions.answers[i]
                .substring(0, AssessmentQuestions.answers[i].length - 1));
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
      await handle_aspect().setAspectpoints("money and finances", point);
      allpoints[7] = point;
    }
    if (funAndRecreationAspectPoints != 0) {
      double point = (funAndRecreationAspectPoints / 40) * 100;
      await handle_aspect().setAspectpoints("Fun and Recreation", point);
      allpoints[6] = point;
    }
    if (healthAndWellbeingAspectPoints != 0) {
      double point = (healthAndWellbeingAspectPoints / 50) * 100;
      await handle_aspect().setAspectpoints("Health and Wellbeing", point);
      allpoints[1] = point;
    }
    if (significantOtherAspectPoints != 0) {
      double point = (significantOtherAspectPoints / 40) * 100;
      await handle_aspect().setAspectpoints("Significant Other", point);
      allpoints[4] = point;
    }
    if (physicalEnvironmentAspectPoints != 0) {
      double point = (physicalEnvironmentAspectPoints / 50) * 100;
      await handle_aspect().setAspectpoints("Physical Environment", point);
      allpoints[3] = point;
    }
    if (personalGrowthAspectPoints != 0) {
      double point = (personalGrowthAspectPoints / 40) * 100;
      await handle_aspect().setAspectpoints("Personal Growth", point);
      allpoints[2] = point;
    }
    if (familyAndFriendsAspectPoints != 0) {
      double point = (familyAndFriendsAspectPoints / 90) * 100;
      await handle_aspect().setAspectpoints("Family and Friends", point);
      allpoints[0] = point;
    }
    if (CareerAspectPoints != 0) {
      double point = (CareerAspectPoints / 40) * 100;
      await handle_aspect().setAspectpoints("career", point);
      allpoints[5] = point;
    }
//store the fetched chosen aspect from the user
    //delete the aspects you have create a new one with the values you have
    Get.to(() => getChosenAspect(
          pointsList: allpoints,
          iser: isar,
          page: 'Home',
          origin: 'Assessment',
        ));
  }
}
