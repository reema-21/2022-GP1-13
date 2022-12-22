// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/auth_controller.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/add_goal_page/task_controller.dart';
import 'package:motazen/pages/communities_page/add_CommunityGoalTask.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/theme.dart';
import 'package:motazen/widget/greenContainer.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';

import '../../Sidebar_and_navigation/sidebar.dart';
import '../../data/data.dart';
import '../../models/user.dart';

class CreateCommunity extends StatefulWidget {
  const CreateCommunity({super.key});

  @override
  State<CreateCommunity> createState() => _CreateCommunityState();
}

class _CreateCommunityState extends State<CreateCommunity> {
  TextEditingController communityNameController = TextEditingController();
  TextEditingController inviteFriendsController = TextEditingController();
  FocusNode inviteFriendsFocusNode = FocusNode();
  TextEditingController goalNameController = TextEditingController();
  CommunityController communityController = Get.find();
  AuthController authController = Get.find();
  TaskControleer taskControleer = Get.find();

  bool private = true;
  bool shouldEnabled = false;
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
  String? aspect;
  List<Userr> selectedUsers = [];
  List<Userr> newSelectedUsersList = [];

  // List of items in our dropdown menu

  @override
  void dispose() {
    communityNameController.dispose();
    inviteFriendsController.dispose();
    goalNameController.dispose();
    inviteFriendsFocusNode.dispose();
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
          title: Text(
            'إنشاء مجتمع',
            style: titleText,
          ),
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
                    txt: '',
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
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(txt: "دعوة الأصدقاء", fontSize: 16),
                  ],
                ),
              ),
              inviteFriendsWidget(context),
              SizedBox(
                height: screenHeight(context) * 0.01,
              ),
              textformField(hint: "اسم الهدف", controller: goalNameController),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    txt(txt: "جوانب الحياة", fontSize: 16),
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
                    txt(txt: ":إضافة المهام", fontSize: 16),
                    SizedBox(
                      width: Get.width * 0.05,
                    ),
                    InkWell(
                      onTap: () {
                        if (difference != 0) {
                          Get.to(() => AddCommunityGoalTask(
                              goalTask: const [], goalDurtion: difference));
                        } else {
                          getWarningSnackBar('فضلا ادخل الفترة');
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
                          difference != 0 &&
                          newSelectedUsersList.isNotEmpty) {
                        communityController.listOfCreatedCommunities.add(
                          Community(
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
                              id: commID),
                        );
                        communityController.update();
                        communityController.createCommunity(
                          invitedUsers: newSelectedUsersList,
                          community: Community(
                              communityName: communityNameController.text,
                              aspect: aspect,
                              founderUsername:
                                  firebaseAuth.currentUser!.displayName,
                              isPrivate: private,
                              tillDate: duration,
                              creationDate: DateTime.now(),
                              goalName: goalNameController.text,
                              listOfTasks: taskControleer.goalTask.value.isEmpty
                                  ? []
                                  : taskControleer.goalTask.value,
                              id: commID),
                        );

                        Get.back();
                        Get.to(CommunityHomePage(
                            comm: communityController
                                .listOfCreatedCommunities.last));
                      } else {
                        getWarningSnackBar('يجب تعبئة جميع الخانات للإستمرار');
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
                              txt: 'إنشاء',
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
                  txt(txt: '${difference.toString()} days', fontSize: 16),
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

  Container inviteFriendsWidget(BuildContext context) {
    return Container(
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
                  shouldEnabled = true;
                });
                inviteFriendsController.text = '';
                inviteFriendsFocusNode.requestFocus();
              },
              child: const Icon(
                Icons.add,
                color: kPrimaryColor,
              ),
            ),
          ),
          Expanded(
            child: shouldEnabled || newSelectedUsersList.isEmpty
                ? inviteFriendssearchField(context)
                : inviteFriendsListView(context),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }

  SizedBox inviteFriendsListView(BuildContext context) {
    return SizedBox(
      height: screenHeight(context) * 0.07,
      child: ListView(
        reverse: true,
        scrollDirection: Axis.horizontal,
        children: newSelectedUsersList.map((Userr user) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all()),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: txt(
                      txt: user.userName!,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            newSelectedUsersList.remove(user);
                            selectedUsers.remove(user);
                            if (newSelectedUsersList.isEmpty) {
                              inviteFriendsController.text = '';
                            }
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
          );
        }).toList(),
      ),
    );
  }

  Padding inviteFriendssearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SearchField(
          searchInputDecoration:
              const InputDecoration(border: InputBorder.none),
          focusNode: inviteFriendsFocusNode,
          controller: inviteFriendsController,
          onSuggestionTap: (p0) {
            newSelectedUsersList.clear();
            setState(() {
              inviteFriendsFocusNode.unfocus();
              shouldEnabled = false;
            });

            for (var user in authController.usersList) {
              if (user.userName == p0.searchKey) {
                selectedUsers.add(user);
                break;
              }
            }

            newSelectedUsersList = selectedUsers.toSet().toList();
            for (var user in newSelectedUsersList) {
              if (user.userID == firebaseAuth.currentUser!.uid) {
                newSelectedUsersList.remove(user);
              }
            }
          },
          suggestions: ((authController.usersList)
                ..removeWhere((e) => e.userID == firebaseAuth.currentUser!.uid))
              .map(
                (e) => SearchFieldListItem(
                  e.userName!,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        txt(txt: e.userName!, fontSize: 16),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
          suggestionState: Suggestion.expand,
          textInputAction: TextInputAction.next,
          hint: 'اختر اسم المستخدم',
          hasOverlay: false,
          searchStyle: TextStyle(
            fontSize: 18,
            color: Colors.black.withOpacity(0.8),
          ),
          itemHeight: screenHeight(context) * 0.07,
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
