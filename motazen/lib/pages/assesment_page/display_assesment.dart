import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/pages/add_goal_page/get_chosen_aspect.dart';
import 'package:motazen/pages/assesment_page/calculate_assessment.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  int currentStep = 0;
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تقييم جوانب الحياة',
                style: titleText,
              ),
              Text('ادخل اجابتك بإستخدام المؤشر', style: subTitle),
            ]),
        toolbarHeight: 120,
      ),
      backgroundColor: Colors.white,
      body: Stepper(
        type: StepperType.vertical,
        steps: List<Step>.generate(
            aspectList.questionData.length,
            (index) => Step(
                  state: aspectList.questionData[index]['points'] > 0
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: currentStep >= index,
                  title: const Text(''),
                  content: Card(
                    elevation: 0,
                    color: Colors.green[50]!.withOpacity(0.5),
                    child: Padding(
                      padding: kDefaultPadding,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ListTile(
                              title: Text(
                                aspectList.questionData[index]['aspect'],
                                style: titleText,
                              ),
                              leading: aspectList.getSelectedIcon(
                                  aspectList.questionData[index]['aspect'],
                                  size: 44)),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            aspectList.questionData[index]['question'],
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SliderTheme(
                            data: const SliderThemeData(
                              trackHeight: 5,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 14.0,
                                pressedElevation: 8.0,
                              ),
                              valueIndicatorShape:
                                  PaddleSliderValueIndicatorShape(),
                              valueIndicatorColor: Colors.black,
                              valueIndicatorTextStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            child: Slider(
                              value: aspectList.questionData[index]['points']
                                  .toDouble(), //answer for that quastion
                              min: 0,
                              max: 10,
                              divisions: 10, //to stick
                              activeColor: kPrimaryColor,
                              label: aspectList.questionData[index]['points']
                                  .round()
                                  .toString(), // to show the lable number
                              onChanged: (value) {
                                setState(() {
                                  aspectList.questionData[index]['points'] =
                                      value.round();
                                });
                              },
                              onChangeEnd: (value) {
                                if (currentStep <
                                    aspectList.questionData.length - 1) {
                                  currentStep += 1;
                                }
                                Timer(const Duration(milliseconds: 400),
                                    () => setState(() {}));
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "الإجابة: ${aspectList.questionData[index]['points'].round().toString()}",
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            growable: true),
        currentStep: currentStep,
        onStepTapped: (step) => setState(() {
          currentStep = step;
        }),
        onStepContinue: () {
          final isLastStep = currentStep == aspectList.questionData.length - 1;
          bool allQuestionsAnswered = true;
          setState(() {
            if (isLastStep) {
              //check if any question was left unanswered
              for (var element in aspectList.questionData) {
                if (element['points'] == 0) {
                  allQuestionsAnswered = false;
                }
              }

              if (allQuestionsAnswered) {
                //calculate the points and save result
                CalculateAspectPoints()
                    .calculateAllpoints(aspectList.questionData);
                //get to the new page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const getChosenAspect();
                    },
                  ),
                );
              } else {
                //TODO: add an alert to notify the user
              }
            } else {
              currentStep += 1;
            }
          });
        },
        onStepCancel: currentStep == 0
            ? null
            : () {
                setState(() {
                  currentStep > 0 ? currentStep -= 1 : null;
                });
              },
        elevation: 0,
        //Note: use for automatic continue
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            children: <Widget>[
              TextButton(
                onPressed: details.onStepContinue,
                child: currentStep == aspectList.questionData.length - 1
                    ? const Text('انتهيت')
                    : const Text('التالي'),
              ),
              TextButton(
                onPressed: details.onStepCancel,
                child: const Text('السابق'),
              ),
            ],
          );
        },
      ),
    );
  }
}
