import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/community_id.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/controllers/task_controller.dart';
import 'package:motazen/pages/communities_page/community/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/green_container.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final _createCommunityFormKey = GlobalKey<FormState>(
      debugLabel: 'CreateCommunityFormKey-${UniqueKey().toString()}');
  TextEditingController communityNameController = TextEditingController();
  List<String> list = [];
  TextEditingController goalNameController = TextEditingController();
  TextEditingController searchContentSetor = TextEditingController();
  CommunityController communityController = Get.find<CommunityController>();
  TaskControleer taskControleer = Get.find<TaskControleer>();
  String? goalName;
  bool enabled = false;
  bool private = true;
  String? isSelected;
  String? isGoalSelected;
  bool public = false;
  DateTime duration = DateTime.now();
  int difference = 0;
  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inDays).round();
  }

  @override
  void initState() {
    super.initState();
  }

  // Initial Selected Value
  String aspect = 'أموالي';

  @override
  void dispose() {
    communityNameController.dispose();
    goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return GestureDetector(
        onTap: () {
          FocusScopeNode currentFoucs = FocusScope.of(context);
          if (!currentFoucs.hasPrimaryFocus) {
            currentFoucs.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kWhiteColor,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0.0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                    ));
              },
            ),
          ),
          backgroundColor: kWhiteColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // reverse: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: //Wrap it with form
                  Form(
                key: _createCommunityFormKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'انشاء مجتمع',
                        style: titleText,
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.03,
                      ),
                      textformField(
                          hint: "اسم المجتمع",
                          controller: communityNameController),
                      const Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            'نوع المجتمع',
                            style: TextStyle(fontSize: 16),
                          )),
                      isPrivateWidget(context),

                      SizedBox(
                        height: screenHeight(context) * 0.01,
                      ),
                      // take the new ones
                      const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          'جانب الحياة',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      aspectWidget(context),
                      SizedBox(
                        height: screenHeight(context) * 0.01,
                      ),
                      SingleChildScrollView(
                          child: Padding(
                        padding: mediaQuery.viewInsets,
                        child: Column(children: [
                          //  Padding(
                          //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.start,
                          //     children: const [
                          //       Text('الهدف', style: TextStyle(fontSize: 16)),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: GestureDetector(
                                onTap: () {
                                  if (enabled) {
                                    setState(() {});
                                  }
                                },
                                child: (enabled & list.isNotEmpty)
                                    ?
                                    // new widget
                                    //TODO :in case the user choose aspect the onther aspect BOTH HAVE GOALS

                                    DropdownButtonFormField(
                                        key: UniqueKey(),
                                        value: isGoalSelected,
                                        items: list
                                            .map(
                                              (e) => DropdownMenuItem(
                                                value: e,
                                                child: Text(e),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (val) {
                                          setState(
                                            () {
                                              //this is the selected goal
                                              isGoalSelected = val as String;
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: Color(0xFF66BF77),
                                        ),
                                        validator: (value) => value == null
                                            ? 'اختر الهدف المراد مشاركته '
                                            : null,
                                        decoration: const InputDecoration(
                                          labelText: "الهدف",
                                          prefixIcon: Icon(
                                            Icons.pie_chart,
                                            color: Color(0xFF66BF77),
                                          ),
                                          border: UnderlineInputBorder(),
                                        ),
                                      )
                                    : Container()
                                // SearchField(
                                //   controller: goalNameController,

                                //   onSuggestionTap: (p0) {
                                //     setState(() {
                                //       goalName = p0.searchKey;
                                //     });
                                //   },
                                //   validator: (value) {
                                //     bool isNotThere = false;
                                //     for (int i = 0; i < list.length; i++) {
                                //       if (value != null && value == list[i]) {
                                //         isNotThere = true;
                                //         break;
                                //       }
                                //     }

                                //     if (value == null || value.isEmpty) {
                                //       return "من فضلك اختر الهدف";
                                //     } else if (!isNotThere) {
                                //       return "هذا الهدف غير موجود ";
                                //     } else {
                                //       return null;
                                //     }
                                //   },
                                //   enabled: enabled,
                                //   itemHeight: 50,
                                //   maxSuggestionsInViewPort: 4,
                                //   hint: "اسم الهدف",
                                //   searchInputDecoration: InputDecoration(
                                //     enabledBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //         borderSide: BorderSide(
                                //             color: Colors.blueGrey.shade200,
                                //             width: 1)),
                                //     focusedBorder: OutlineInputBorder(
                                //         borderRadius: BorderRadius.circular(10),
                                //         borderSide: BorderSide(
                                //             color: kPrimaryColor.withOpacity(0.8),
                                //             width: 2)),
                                //   ),
                                //   suggestions: ((list)
                                //       .map(
                                //         (e) => SearchFieldListItem(
                                //           e,
                                //           child: Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: Row(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.end,
                                //               children: [
                                //                 txt(txt: e, fontSize: 16),
                                //               ],
                                //             ),
                                //           ),
                                //         ),
                                //       )
                                //       .toList()),
                                // hasOverlay:
                                //   //     false, //this one to a be able to scroll ap
                                // ),
                                ),
                          )
                        ]),
                      )),

                      SizedBox(
                        height: screenHeight(context) * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              String commID =
                                  '${DateTime.now().toUtc().millisecondsSinceEpoch}_${firebaseAuth.currentUser!.uid}';
                              if (_createCommunityFormKey.currentState!
                                      .validate() &
                                  enabled &
                                  list.isNotEmpty) {
                                Goal? choseGoal =
                                    Goal(userID: IsarService.getUserID);
                                IsarService iser =
                                    IsarService(); // initialize local storage
                                choseGoal = await iser.getgoal(
                                  isGoalSelected!,
                                ); // here iam fetching the goal information from isar to assign it to the communties

                                final createdComm = Community(
                                    progressList: [
                                      //!here you changes it form being a zero when start to the value of the goalProgress
                                      {
                                        firebaseAuth.currentUser!.uid:
                                            choseGoal!.goalProgressPercentage
                                      }
                                    ],
                                    communityName: communityNameController.text,
                                    aspect: isSelected,
                                    isPrivate: private,
                                    isDeleted:
                                        false, //!isDeleted in here false you just create it

                                    founderUserID:
                                        firebaseAuth.currentUser!.uid,
                                    creationDate: DateTime.now(),
                                    goalName: isGoalSelected,
                                    id: commID);
                                // communityController.listOfCreatedCommunities
                                //     .add(createdComm);
                                // communityController.update();
                                communityController.createCommunity(
                                  community: createdComm,
                                );
                                CommunityID newCom =
                                    CommunityID(userID: IsarService.getUserID);
                                newCom.communityId = commID;
                                newCom.goal.value = choseGoal;
                                iser.saveCom(newCom);
                                choseGoal.communities.add(newCom);
                                iser.createGoal(choseGoal);

                                Get.back();
                                Get.to(() => CommunityHomePage(
                                    fromInvite: false, comm: createdComm));
                              } else {
                                log(enabled.toString());
                                if (!enabled) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          backgroundColor:
                                              Colors.yellow.shade300,
                                          content: const Row(
                                            children: [
                                              Icon(
                                                Icons.error,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              SizedBox(width: 20),
                                              Expanded(
                                                child: Text(
                                                    "لايمكن انشاء المجتمع , ليس لديك أهداف متعلقة بهذا الجانب ",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              )
                                            ],
                                          )));
                                }
                              }
                            },
                            child: Container(
                              height: screenHeight(context) * 0.05,
                              width: screenWidth(context) * 0.4,
                              decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                  child: txt(
                                      txt: 'انشاء',
                                      fontSize: 16,
                                      fontColor: Colors.white)),
                            ),
                          )
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ));
  }

  Container durationWidget(BuildContext context) {
    return Container(
        height: screenHeight(context) * 0.07,
        width: screenWidth(context),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
            )),
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                  onTap: () async {
                    DateTime? newDate = await showDatePicker(
                      initialDate: DateTime.now(),
                      context: context,
                      firstDate:
                          DateTime.now().subtract(const Duration(days: 0)),
                      lastDate: DateTime(2100),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: kPrimaryColor,
                              onPrimary: Colors.white,
                              onSurface: kPrimaryColor,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    setState(() {
                      difference = daysBetween(
                        DateTime.now(),
                        newDate!,
                      );
                      duration = newDate;
                    });
                  },
                  child: const Icon(
                    Icons.calendar_month,
                    color: kPrimaryColor,
                  )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  txt(txt: '${difference.toString()} ايام', fontSize: 16),
                ],
              )),
            ],
          ),
        ));
  }

  Container isPrivateWidget(BuildContext context) {
    return Container(
      height: screenHeight(context) * 0.07,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.grey,
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                private = true;
                public = false;
              });
            },
            child: greenTextContainer(context,
                width: screenWidth(context) * 0.2,
                text: 'خاص',
                isSelected: private),
          ),
          InkWell(
            onTap: () {
              setState(() {
                private = false;
                public = true;
              });
            },
            child: greenTextContainer(context,
                width: screenWidth(context) * 0.2,
                text: 'عام',
                isSelected: public),
          ),
        ],
      ),
    );
  }

// create normal dropdownMenue

//
  DropdownButtonFormField aspectWidget(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return DropdownButtonFormField(
      value: isSelected,
      items: aspectList
          .getSelectedNames()
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: (val) {
        isGoalSelected = null;
        list.clear();
        bool erase = true;
        setState(() {
          isSelected = val as String;
          String pre = aspect;
          // enabled = true; //!THIS MIGHT CAUSE AN ERROR
          //Note: suggestion, using a dictionary list w/ aspect anmes as keys and erase as
          //index might improve performance. check the select aspect page for reference
          switch (isSelected) {
            case 'أموالي':
              if (pre == 'أموالي') {
                //if user changes the chose aspect clear the  goal name feild erase = true ;
                erase = false;
              }

              break;
            case 'متعتي':
              if (pre == 'متعتي') {
                erase = false;
              }
              break;
            case 'مهنتي':
              if (pre == 'مهنتي') {
                erase = false;
              }
              break;
            case 'علاقاتي':
              if (pre == 'علاقاتي') {
                erase = false;
              }
              break;
            case 'بيئتي':
              if (pre == 'بيئتي') {
                erase = false;
              }
              break;
            case 'ذاتي':
              if (pre == 'ذاتي') {
                erase = false;
              }
              break;

            case 'صحتي':
              if (pre == 'صحتي') {
                erase = false;
              }
              break;
            case 'عائلتي واصدقائي':
              if (pre == 'عائلتي واصدقائي') {
                erase = false;
              }
              break;
          }
          if (erase) {
            //!make the selected dropdown menut unselected
            goalNameController.text = "";
            isGoalSelected = null;
          }
          late List<Goal> goalList;
          getgoals().then((value) {
            if (value.isNotEmpty) {
              setState(() {
                enabled = true;
              });
            } else {
              setState(() {
                enabled = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(milliseconds: 900),
                  backgroundColor: Colors.yellow.shade300,
                  content: const Row(
                    children: [
                      Icon(
                        Icons.error,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text("ليس لديك أهداف متعلقة بهذا الجانب ",
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  )));
            }
            goalList = value;

            for (int i = 0; i < goalList.length; i++) {
              list.add(goalList[i].titel);
            }
          });
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Color(0xFF66BF77),
      ),
      validator: (value) =>
          value == null ? 'من فضلك اختر جانب الحياة المناسب للمجتمع' : null,
      decoration: const InputDecoration(
        labelText: "جوانب الحياة ",
        prefixIcon: Icon(
          Icons.pie_chart,
          color: Color(0xFF66BF77),
        ),
        border: UnderlineInputBorder(),
      ),
    );
  }

  Padding textformField(
      {required String hint,
      required TextEditingController controller,
      Widget? suffixIcon,
      bool? isEnabled}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        enabled: isEnabled,
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "من فضلك ادخل اسم المجتمع";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: hint,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  SearchField goalWidget(BuildContext context) {
    return SearchField(
      searchInputDecoration: const InputDecoration(border: InputBorder.none),
      controller: goalNameController,
      onSuggestionTap: (p0) {
        setState(() {
          goalName = p0.searchKey;
        });
      },
      suggestions: ((list)
          .map(
            (e) => SearchFieldListItem(
              e,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    txt(txt: e, fontSize: 16),
                  ],
                ),
              ),
            ),
          )
          .toList()),
      suggestionState: Suggestion.expand,
      textInputAction: TextInputAction.next,
      hint: 'أختر الهدف',
      // hasOverlay: false,
      searchStyle: TextStyle(
        fontSize: 18,
        color: Colors.black.withOpacity(0.8),
      ),
      itemHeight: screenHeight(context) * 0.07,
    );
  }

  Future<List<Goal>> getgoals() async {
    IsarService iser = IsarService(); // initialize local storage
    Aspect? chosenAspect = Aspect(userID: IsarService.getUserID);
    chosenAspect = await iser.getSepecificAspect(isSelected!);
    return chosenAspect!.goals.toList();
  }

  SizedBox chosenGoal(BuildContext context) {
    if (goalName == null) {
      return SizedBox(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(13.0, 13.0, 0, 13.0),
        child: Text("اختر الهدف",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black.withOpacity(0.5),
            )),
      ));
    } else {
      return SizedBox(
          height: screenHeight(context) * 0.07,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  txt(
                      txt: goalName!,
                      fontSize: 16,
                      textAlign: TextAlign.center),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            goalName = null;
                            goalNameController.text = "";
                          });
                        },
                        child: const Icon(
                          Icons.close,
                          color: kPrimaryColor,
                        )),
                  )
                ],
              ),
            ),
          ));
    }
  }
}
