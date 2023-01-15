// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/data/data.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/greenContainer.dart';
import 'package:provider/provider.dart';

import '../../Sidebar_and_navigation/sidebar.dart';
import '../add_goal_page/add_Task2.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  TextEditingController communityNameController = TextEditingController();

  TextEditingController goalNameController = TextEditingController();
  CommunityController communityController = Get.find();

  TaskControleer taskControleer = Get.find();

  bool private = true;

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

  // List<Community> listOfUsers = [
  //   'user1',
  //   'user2',
  //   'user3',
  //   'user4',
  //   'user5',
  //   'user6',
  //   'user7',
  //   'user8',
  //   'user9',
  //   'user10'
  // ];

  // List of items in our dropdown menu
  var items = [
    'Finance',
    'Family',
    'Fun',
    'Career',
    'Health',
    'Enviroment',
    'Relationships',
    'Pesonal Growth',
  ];
  @override
  void dispose() {
    communityNameController.dispose();
    goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  const Spacer(),
                  txt(
                    txt: 'انشاء مجتمع',
                    fontSize: 32,
                    fontColor: kPrimaryColor,
                  ),
                  const Spacer(
                    flex: 2,
                  )
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.03,
              ),
              textformField(
                  hint: "اسم المجتمع", controller: communityNameController),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(txt: "نوع المجتمع", fontSize: 16),
                  ],
                ),
              ),
              isPrivateWidget(context),

              // inviteFriendsWidget(context),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              textformField(hint: "اسم الهدف", controller: goalNameController),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(txt: "الجانب", fontSize: 16),
                  ],
                ),
              ),
              aspectWidget(context),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(txt: "الفترة", fontSize: 16),
                  ],
                ),
              ),
              durationWidget(context),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 8),
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    txt(txt: "إضافة مهمة:", fontSize: 16),
                    SizedBox(
                      width: Get.width * 0.05,
                    ),
                    InkWell(
                      onTap: () {
                        if (difference != 0) {
                          Get.to(() => AddTask(
                              goalTask: const [],
                              isr: IsarService(),
                              goalDurtion: difference));
                        } else {
                          getWarningSnackBar('اختر الفترة أولا');
                        }
                      },
                      child: const CircleAvatar(
                        backgroundColor: kPrimaryColor,
                        radius: 12,
                        child: Center(
                            child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.white,
                        )),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight(context) * 0.05,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      String commID =
                          '${DateTime.now().toUtc().millisecondsSinceEpoch}_${firebaseAuth.currentUser!.uid}';
                      if (communityNameController.text.isNotEmpty &&
                          goalNameController.text.isNotEmpty &&
                          difference != 0) {
                        final createdComm = Community(
                            progressList: [
                              {firebaseAuth.currentUser!.uid: 0}
                            ],
                            communityName: communityNameController.text,
                            aspect: aspect,
                            isPrivate: private,
                            founderUsername:
                                firebaseAuth.currentUser!.displayName,
                            tillDate: duration,
                            creationDate: DateTime.now(),
                            goalName: goalNameController.text,
                            listOfTasks: taskControleer.goalTask.value.isEmpty
                                ? []
                                : taskControleer.goalTask.value,
                            id: commID);
                        communityController.listOfCreatedCommunities
                            .insert(0, createdComm);
                        communityController.update();
                        communityController.createCommunity(
                          invitedUsers: [],
                          community: createdComm,
                        );

                        Get.back();
                        Get.to(CommunityHomePage(comm: createdComm));
                      } else {
                        getWarningSnackBar('فضلا ادخل جميع المعلومات');
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

  Container aspectWidget(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    return Container(
      height: screenHeight(context) * 0.07,
      width: screenWidth(context),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10, top: 5, left: 10),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DropdownButton(
            dropdownColor: kPrimaryColor,
            underline: Container(),
            borderRadius: BorderRadius.circular(5),
            iconSize: 24,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            items: aspectList.selectedArabic.map((String item) {
              return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    textDirection: TextDirection.ltr,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 12,
                        ),
                        child: txt(
                          txt: item,
                          fontColor: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                aspect = newValue!;
              });
            },
          ),
        ),
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
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          textDirection: TextDirection.rtl,
          enabled: isEnabled,
          controller: controller,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "من فضلك ادخل اسم الهدف";
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
      ),
    );
  }
}
