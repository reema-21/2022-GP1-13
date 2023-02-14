// ignore_for_file: file_names, camel_case_types, unused_import
//new
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/entities/CommunityID.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/greenContainer.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../Sidebar_and_navigation/sidebar.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  final formKey = GlobalKey<FormState>();
  TextEditingController communityNameController = TextEditingController();
  List<String> list = [];
  TextEditingController goalNameController =
      TextEditingController(); //! no need
  TextEditingController searchContentSetor =
      TextEditingController(); //! no need
  CommunityController communityController = Get.find();

  TaskControleer taskControleer = Get.find();
  String? goalName;
  bool enabled = false;
  bool private = true;
  String? isSelected;
  String aspectnameInEnglish = "";
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
  String aspect = 'Finance';

  @override
  void dispose() {
    communityNameController.dispose();
    goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: const SideBar(),
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const RotatedBox(
                  quarterTurns: 2,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
                tooltip: 'View Requests'),
          ],
        ),
        backgroundColor: kWhiteColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: //Wrap it with form
                Form(
              key: formKey,
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(
                  'انشاء مجتمع',
                  style: titleText,
                ),
                SizedBox(
                  height: screenHeight(context) * 0.03,
                ),
                textformField(
                    hint: "اسم المجتمع", controller: communityNameController),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [
                          Text('الهدف', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (!enabled) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(milliseconds: 500),
                                backgroundColor: Colors.yellow.shade300,
                                content: Row(
                                  children: const [
                                    Icon(
                                      Icons.error,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Text("اختر جانب الحياة أولا",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    )
                                  ],
                                )));
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    // shouldEnabled = true;
                                  });
                                },
                                child: const Icon(
                                  Icons.task,
                                  color: kPrimaryColor,
                                ),
                              ),
                            ),
                            Expanded(
                              child: ((goalName == null ||
                                          goalNameController.text == "") &&
                                      enabled)
                                  ? goalWidget(context)
                                  : chosenGoal(context),
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      ),
                    ),
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
                        if (formKey.currentState!.validate()) {
                          Goal? choseGoal = Goal(userID: IsarService.getUserID);
                          IsarService iser =
                              IsarService(); // initialize local storage
                          choseGoal = await iser.getgoal(
                            goalName!,
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
                              founderUsername:
                                  firebaseAuth.currentUser!.displayName,
                              // tillDate: duration,
                              creationDate: DateTime.now(),
                              goalName: goalName,
                              // listOfTasks: taskControleer.goalTask.value.isEmpty
                              //     ? []
                              //     : taskControleer.goalTask.value,
                              id: commID);
                          communityController.listOfCreatedCommunities
                              .insert(0, createdComm);
                          communityController.update();
                          communityController.createCommunity(
                            invitedUsers: [],
                            community: createdComm,
                          );
                          CommunityID newCom =
                              CommunityID(userID: IsarService.getUserID);
                          newCom.CommunityId = commID;

                          // iser.CreateCommunity(newCom);

// CommunityID?newCommunity =
//         await iser.findCommunity(commID);
//         print("here is the value of the community id");
//         print(newCommunity!.id);
                          choseGoal.Communities.add(newCom);
                          iser.createGoal(choseGoal);

                          Get.back();
                          Get.to(CommunityHomePage(comm: createdComm));
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
      ),
    );
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

  DropdownButtonFormField aspectWidget(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    return DropdownButtonFormField(
      value: isSelected,
      items: aspectList.selectedArabic
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: (val) {
        list.clear();
        bool erase = true;
        setState(() {
          isSelected = val as String;
          String pre = aspectnameInEnglish;
          enabled = true;
          switch (isSelected) {
            case "أموالي":
              aspectnameInEnglish = "money and finances";
              if (pre == aspectnameInEnglish) {
                //if user changes the chose aspect clear the  goal name feild erase = true ;
                erase = false;
              }

              break;
            case "متعتي":
              aspectnameInEnglish = "Fun and Recreation";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
            case "مهنتي":
              aspectnameInEnglish = "career";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
            case "علاقاتي":
              aspectnameInEnglish = "Significant Other";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
            case "بيئتي":
              aspectnameInEnglish = "Physical Environment";

              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
            case "ذاتي":
              aspectnameInEnglish = "Personal Growth";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;

            case "صحتي":
              aspectnameInEnglish = "Health and Wellbeing";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
            case "عائلتي وأصدقائي":
              aspectnameInEnglish = "Family and Friends";
              if (pre == aspectnameInEnglish) {
                erase = false;
              }
              break;
          }
          if (erase) {
            goalNameController.text = "";
          }
          late List<Goal> goalList;
          getgoals().then((value) {
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
        textDirection: TextDirection.rtl,
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
          hintTextDirection: TextDirection.rtl,
          labelText: hint,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  SearchField goalWidget(BuildContext context) {
    return SearchField(
      validator: (value) {
        bool isNotThere = false;
        for (int i = 0; i < list.length; i++) {
          if (value != null && value == list[i]) {
            isNotThere = true;
            break;
          }
        }

        if (value == null || value.isEmpty) {
          return "من فضلك اختر الهدف";
        } else if (!isNotThere) {
          return "هذا الهدف غير موجود ";
        } else {
          return null;
        }
      },
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
      hasOverlay: false,
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
    chosenAspect = await iser.getSepecificAspect(aspectnameInEnglish);
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
