// ignore_for_file: list_remove_unrelated_type, non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/community_controller.dart';
import 'package:motazen/entities/CommunityID.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/entities/goal.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/models/community.dart';
import 'package:motazen/pages/add_goal_page/taskLocal_controller.dart';
import 'package:motazen/pages/communities_page/community_home.dart';
import 'package:motazen/pages/goals_habits_tab/taskClass.dart';
import 'package:multiselect/multiselect.dart';

import '../../theme.dart';

Future<dynamic> publicCommunityDetailsPopup(BuildContext context,
    {required Community community}) {
  CommunityController communityController = Get.find();
  bool x = false;

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          content: Container(
            // height: community.listOfTasks!.isEmpty
            //     ? screenHeight(context) * 0.4
            //     : screenHeight(context) * 0.5,
            height: screenHeight(context) * 0.4,
            width: screenWidth(context) * 0.8,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: txt(
                          txt: community.communityName.toString(),
                          fontSize: 22,
                        ),
                      ),
                      Expanded(
                        child: txt(
                          txt: 'جانب الحياة: ${community.aspect.toString()}',
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () async {
                                Navigator.pop(
                                    context); // so that the join window goes
                                final TaskLocalControleer freq =
                                    Get.put(TaskLocalControleer());
                                List<String> durationName = [
                                  'أيام',
                                  'أسابيع',
                                  'أشهر',
                                  'سنوات'
                                ];
                                IsarService iser =
                                    IsarService(); // initialize local storage

                                AddTheEnterdTask(LocalTask newTask,
                                    List<String> tasks) async {
                                  List<String> Taskss = tasks;
                                  await Future.forEach(Taskss, (item) async {
                                    LocalTask? y = LocalTask(
                                        userID: IsarService.getUserID);
                                    String name = item;

                                    y = await iser.findSepecificTask(name);
                                    newTask.TaskDependency.add(
                                        y!); // to link task and it depends tasks ;
                                    // widget.isr.saveTask(y);// to link
                                  });
                                  iser.saveTask(newTask);
                                }

                                final _goalaspectController =
                                    TextEditingController();
                                _goalaspectController.text =
                                    community.goalName!;
                                freq.selectedTasks.value.clear();
                                freq.inputTaskName.text = "";
                                freq.TaskDuration.value = 0;
                                freq.isSelected.value = "أيام";
                                freq.currentTaskDuration.value = 0;
                                final formKey = GlobalKey<FormState>();
                                String? isSelected = "";

                                freq.setvalue(durationName[0]);

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          title: Text(
                                            "أضف الهدف إلى قائمة أهدافك",
                                            style: titleText2,
                                          ),
                                          content: Form(
                                            key: formKey,
                                            child: SingleChildScrollView(
                                                child: Column(children: [
                                              // اسم الهدف
                                              TextFormField(
                                                enabled: false,
                                                controller:
                                                    _goalaspectController,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  labelText: "اسم الهدف ",
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .verified_user_outlined,
                                                    color: Color.fromARGB(
                                                        255, 164, 175, 166),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),

                                              const SizedBox(
                                                height: 20,
                                              ),
                                              //end
                                              TextFormField(
                                                validator: (value) {
                                                  bool Repeated = false;
                                                  for (var i
                                                      in freq.goalTask.value) {
                                                    if (i.name == value) {
                                                      setState(() {
                                                        Repeated = true;
                                                      });
                                                    }
                                                  }
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "من فضلك ادخل اسم المهمة";
                                                    // else if (!RegExp(r'^[ء-ي]+$').hasMatch(value)) {
                                                    //   return "    ا سم الهدف يحب ان يحتوي على حروف فقط";
                                                    // }
                                                  } else if (Repeated) {
                                                    return "يوجد مهمة بنفس الاسم";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                controller: freq.inputTaskName,
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  labelText: "اسم المهمة",
                                                  prefixIcon: Icon(
                                                    Icons
                                                        .verified_user_outlined,
                                                    color: Color(0xFF66BF77),
                                                  ),
                                                  border: OutlineInputBorder(),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  const Text("الفترة"),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: const Color(
                                                          0xFF66BF77),
                                                    ),
                                                    child: Center(
                                                      child: IconButton(
                                                        icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                        onPressed: () {
                                                          freq.incrementCommunity();
                                                          if (freq.TaskDuration !=
                                                              0) {
                                                            freq.storeStatusOpen(
                                                                true);
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Obx((() => Text(
                                                        freq.TaskDuration
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 20),
                                                      ))),
                                                  const SizedBox(width: 10),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      color: const Color(
                                                          0xFF66BF77),
                                                    ),
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          color: Colors.white,
                                                          size: 15),
                                                      onPressed: () {
                                                        freq.dcrement();
                                                        freq.storeStatusOpen(
                                                            true);

                                                        if (freq.TaskDuration ==
                                                            0) {
                                                          freq.storeStatusOpen(
                                                              false);
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(width: 20),
                                                  Obx(
                                                    () => DropdownButton(
                                                      //changes
                                                      value:
                                                          freq.isSelected.value,

                                                      items: durationName
                                                          .map((e) =>
                                                              DropdownMenuItem(
                                                                value: e,
                                                                child: Text(e),
                                                              ))
                                                          .toList(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          isSelected = value;
                                                          for (int i = 0;
                                                              i <
                                                                  durationName
                                                                      .length;
                                                              i++) {
                                                            if (value!.contains(
                                                                durationName[
                                                                    0])) {
                                                              freq.setvalue(
                                                                  durationName[
                                                                      0]);
                                                            } else if (value
                                                                .contains(
                                                                    durationName[
                                                                        1])) {
                                                              freq.setvalue(
                                                                  durationName[
                                                                      1]);
                                                            } else if (value
                                                                .contains(
                                                                    durationName[
                                                                        2])) {
                                                              freq.setvalue(
                                                                  durationName[
                                                                      2]);
                                                            } else {
                                                              freq.setvalue(
                                                                  durationName[
                                                                      3]);
                                                            }
                                                          }

                                                          switch (freq
                                                              .isSelected
                                                              .value) {
                                                            case "أيام":
                                                              freq.setdefult();
                                                              freq.storeStatusOpen(
                                                                  false);

                                                              break;
                                                            case "أسابيع":
                                                              freq.setdefult();
                                                              freq.storeStatusOpen(
                                                                  false);

                                                              break;
                                                            case "أشهر":
                                                              freq.setdefult();
                                                              freq.storeStatusOpen(
                                                                  false);

                                                              break;
                                                            case "سنوات":
                                                              freq.storeStatusOpen(
                                                                  false);

                                                              freq.setdefult();

                                                              break;
                                                          }
                                                        });
                                                      },
                                                      icon: const Icon(
                                                        size: 30,
                                                        Icons
                                                            .arrow_drop_down_circle,
                                                        color:
                                                            Color(0xFF66BF77),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              DropDownMultiSelect(
                                                options: freq.TasksMenue.value,
                                                //need to be righted
                                                decoration:
                                                    const InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          vertical: 10.0,
                                                          horizontal: 10.0),
                                                  labelText:
                                                      "تعتمد على المهام :",
                                                  prefixIcon: Icon(
                                                    Icons.splitscreen,
                                                    color: Color(0xFF66BF77),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  freq.selectedTasks.value =
                                                      value;
                                                  //here you can save the tasks and link it
                                                },
                                                selectedValues:
                                                    freq.selectedTasks.value,
                                              ),

                                              //! Add the button for adding task
                                              SizedBox(
                                                height: 100,
                                                width: 200,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            // TasksNamedropmenue.add(inputTaskName.text);

                                                            LocalTask newTak =
                                                                LocalTask(
                                                                    userID: IsarService
                                                                        .getUserID);
                                                            newTak.name = freq
                                                                .inputTaskName
                                                                .value
                                                                .text;
                                                            String
                                                                durationDescribtion =
                                                                "";
                                                            switch (freq
                                                                .isSelected
                                                                .value) {
                                                              case "أيام":
                                                                newTak.duration =
                                                                    freq.TaskDuration
                                                                        .value;
                                                                durationDescribtion =
                                                                    "أيام";
                                                                newTak.durationDescribtion =
                                                                    durationDescribtion;
                                                                break;
                                                              case "أسابيع":
                                                                newTak
                                                                    .duration = (freq
                                                                        .TaskDuration
                                                                        .value *
                                                                    7);
                                                                durationDescribtion =
                                                                    "أسابيع";
                                                                newTak.durationDescribtion =
                                                                    durationDescribtion;

                                                                break;
                                                              case "أشهر":
                                                                newTak
                                                                    .duration = (freq
                                                                        .TaskDuration
                                                                        .value *
                                                                    30);
                                                                durationDescribtion =
                                                                    "أشهر";
                                                                newTak.durationDescribtion =
                                                                    durationDescribtion;

                                                                break;
                                                              case "سنوات":
                                                                newTak
                                                                    .duration = (freq
                                                                        .TaskDuration
                                                                        .value *
                                                                    360);
                                                                durationDescribtion =
                                                                    "سنوات ";
                                                                newTak.durationDescribtion =
                                                                    durationDescribtion;

                                                                break;
                                                            }

                                                            AddTheEnterdTask(
                                                                newTak,
                                                                freq.selectedTasks
                                                                    .value);
                                                            freq.TasksMenue
                                                                .value
                                                                .add(freq
                                                                    .inputTaskName
                                                                    .value
                                                                    .text);
                                                            // setState(() {
                                                            //   x =
                                                            freq.addTask(
                                                                freq.inputTaskName
                                                                    .value.text,
                                                                freq.isSelected
                                                                    .value,
                                                                freq.TaskDuration
                                                                    .value);
                                                            // }); //ad the enterd to the tasks to the dependncy tasks .

                                                            freq.TaskDuration
                                                                .value = 0;

                                                            freq.storeStatusOpen(
                                                                false);
                                                            freq.incrementTaskDuration();
                                                            freq.currentTaskDuration
                                                                .value = 0;

                                                            freq.setvalue(
                                                                durationName[
                                                                    0]);
                                                            // freq.selectedTasks.value.clear();

                                                          }
                                                        },
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              kPrimaryColor,
                                                          radius: 17,
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.add,
                                                            size: 20,
                                                            color: Colors.white,
                                                          )),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: Get.width * 0.03,
                                                      ),
                                                      txt(
                                                          txt: "إضافة المهمة",
                                                          fontSize: 18),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //! end of the button for adding task
                                              ElevatedButton(
                                                //maybe the condition will be that user added one task
                                                //stateproblen
                                                onPressed: () async {
                                                  //add the goal
                                                  Goal newgoal = Goal(
                                                      userID: IsarService
                                                          .getUserID);
                                                  newgoal.titel =
                                                      community.goalName!;
                                                  newgoal.importance = 1;

                                                  Aspect? selected = await iser
                                                      .findSepecificAspect(
                                                          community.aspect!);

                                                  newgoal.aspect.value =
                                                      selected;
                                                  selected!.goals.add(newgoal);
                                                  iser.createAspect(selected);

                                                  newgoal.goalDuration = freq
                                                      .totalTasksDuration.value;
                                                  newgoal.DescriptiveGoalDuration =
                                                      '${freq.totalTasksDuration.value.toString()} يوما';
                                                  newgoal.startData =
                                                      community.creationDate!;
                                                  newgoal.endDate =
                                                      community.creationDate!;
                                                  var task = [];
                                                  task = freq.goalTask.value;

                                                  for (int i = 0;
                                                      i <
                                                          freq.goalTask.value
                                                              .length;
                                                      i++) {
                                                    LocalTask? y = LocalTask(
                                                        userID: IsarService
                                                            .getUserID);
                                                    String name = "";

                                                    name = task[i].name;

                                                    y = await iser
                                                        .findSepecificTask2(
                                                            name);
                                                    y!.goal.value = newgoal;
                                                    newgoal.task.add(
                                                        y); // to link the task to the goal
                                                    iser.saveTask(y);
                                                    CommunityID newCom =
                                                        CommunityID(
                                                            userID: IsarService
                                                                .getUserID);
                                                    newCom.CommunityId =
                                                        community.id;
                                                    newgoal.Communities.add(
                                                        newCom);
                                                    iser.createGoal(newgoal);

                                                    freq.TaskDuration = 0.obs;
                                                    freq.currentTaskDuration =
                                                        0.obs;
                                                    freq.totalTasksDuration =
                                                        0.obs;
                                                    freq.checkTotalTaskDuration =
                                                        0.obs;

                                                    freq.iscool = false.obs;
                                                    freq.tem = 0.obs;
                                                    freq.isSelected =
                                                        "أيام".obs;
                                                    freq.goalTask =
                                                        Rx<List<LocalTask>>([]);
                                                    freq.TasksMenue =
                                                        Rx<List<String>>([]);
                                                    freq.selectedTasks =
                                                        Rx<List<String>>([]);
                                                    freq.newTasksAddedInEditing =
                                                        Rx<List<LocalTask>>([]);
                                                    freq.TasksMenue.value
                                                        .clear();
                                                    freq.selectedTasks.value
                                                        .clear();
                                                    freq.allTaskForDepency =
                                                        Rx<List<TaskData>>([]);
                                                    freq.tryTask = Rx<TaskData>(
                                                        TaskData());
                                                    freq.itemCount = 0.obs;
                                                    freq.allTaskForDepency.value
                                                        .clear();
                                                    freq.itemCountAdd = 0.obs;

                                                    //-----------------------------------
                                                    community.progressList.add({
                                                      firebaseAuth
                                                          .currentUser!.uid: 0
                                                    });
                                                    communityController
                                                        .listOfJoinedCommunities
                                                        .add(
                                                      Community(
                                                          progressList:
                                                              community
                                                                  .progressList,
                                                          communityName:
                                                              community
                                                                  .communityName,
                                                          aspect:
                                                              community.aspect,
                                                          isPrivate: community
                                                              .isPrivate,
                                                          founderUsername:
                                                              community
                                                                  .founderUsername,
                                                          // tillDate: community.tillDate,
                                                          creationDate:
                                                              community
                                                                  .creationDate,
                                                          goalName: community
                                                              .goalName,
                                                          // listOfTasks: community.listOfTasks,
                                                          id: community.id),
                                                    );
                                                    communityController
                                                        .update();
                                                    await communityController
                                                        .acceptInvitation();

                                                    communityController
                                                        .update();
                                                    Get.to(CommunityHomePage(
                                                        comm: communityController
                                                            .listOfJoinedCommunities
                                                            .last));

                                                    //   }
                                                    //  } : null,
                                                  }
                                                },
                                                child: const Text("انتهيت"),
                                              )
                                            ])),
                                          ));
                                    });
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'انضمام',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            }),
          ),
        );
      });
}
