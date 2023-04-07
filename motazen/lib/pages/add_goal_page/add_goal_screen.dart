// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, must_be_immutable, unused_local_variable
//manar
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/entities/LocalTask.dart';
import 'package:motazen/entities/goal.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:motazen/models/taskClass.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/controllers/taskLocal_controller.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../Sidebar_and_navigation/navigation-bar.dart';
import '../../entities/aspect.dart';
import '../../theme.dart';
import '../assesment_page/alert_dialog.dart';
import 'add_Task2.dart';

class AddGoal extends StatefulWidget {
  List<LocalTask> goalsTasks = [];
  final IsarService isr;
  AddGoal({super.key, required this.isr, required this.goalsTasks});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  DateRangePickerController newSelectedDate = DateRangePickerController();

  final formKey = GlobalKey<FormState>();
  late String _goalName;
  DateTimeRange? selectedDates;

  int goalDuration = 0;
  String duration = "لا يوجد فترة";
  int importance = 0;
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final _dueDateController = TextEditingController();
  final TaskLocalControleer freq = Get.put(TaskLocalControleer());
  bool isFirstclick = true;

  String? isSelected;
  @override
  void initState() {
    importance = 1;
    super.initState();
    _goalNmaeController.addListener(_updateText);
    _dueDateController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _goalName = _goalNmaeController.text;
    });
  }

  Goal newgoal = Goal(userID: IsarService.getUserID);

  _Addgoal() async {
    newgoal.titel = _goalName;
    newgoal.importance = importance;
    Aspect? selected = await widget.isr.findSepecificAspect(isSelected!);
    newgoal.aspect.value = selected; // link aspect to the goal
    selected!.goals.add(newgoal);
    // widget.isr.createAspect(selected); //Note: what is it used for
    newgoal.DescriptiveGoalDuration = duration;
    newgoal.goalDuration = goalDuration;
    newgoal.startData = selectedDates!.start;
    newgoal.endDate = selectedDates!.end;
    widget.goalsTasks = freq.goalTask.value;
    var task = [];
    task = freq.goalTask.value;

    for (int i = 0; i < freq.goalTask.value.length; i++) {
      LocalTask? y = LocalTask(userID: IsarService.getUserID);
      String name = "";

      name = task[i].name;

      y = await widget.isr.findSepecificTask2(name);
      y!.goal.value = newgoal;
      newgoal.task.add(y); // to link the task to the goal
      widget.isr.saveTask(y);
    }
    await widget.isr.addAspectGoalLink(newgoal, selected);
    widget.isr.createGoal(newgoal);
    freq.TaskDuration = 0.obs;
    freq.currentTaskDuration = 0.obs;
    freq.totalTasksDuration = 0.obs;
    freq.checkTotalTaskDuration = 0.obs;

    freq.iscool = false.obs;
    freq.tem = 0.obs;
    freq.isSelected = "أيام".obs;
    freq.goalTask = Rx<List<LocalTask>>([]);
    freq.TasksMenue = Rx<List<String>>([]);
    freq.selectedTasks = Rx<List<String>>([]);
    freq.newTasksAddedInEditing = Rx<List<LocalTask>>([]);
    freq.TasksMenue.value.clear();
    freq.selectedTasks.value.clear();
    freq.allTaskForDepency = Rx<List<TaskData>>([]);
    freq.tryTask = Rx<TaskData>(TaskData());
    freq.itemCount = 0.obs;
    freq.allTaskForDepency.value.clear();
    freq.itemCountAdd = 0.obs;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const navBar(
            selectedIndex: 1,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      /// key
      key: _scaffoldkey,

      /// appbar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF66BF77),
        title: const Text(
          "إضافة هدف جديد",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () async {
              final action = await AlertDialogs.yesCancelDialog(
                  context,
                  ' هل انت متاكد من الرجوع للخلف',
                  'بالنقر على "تأكيد" لن يتم حفظ معلومات الهدف  ');
              if (action == DialogsAction.yes) {
                //to have intionals values all thetime
                // delete the added tasks .
                for (int i = 0; i < freq.goalTask.value.length; i++) {
                  widget.isr.deleteTask3(freq.goalTask.value[i]);
                }

                //...............................
                freq.TaskDuration = 0.obs;
                freq.currentTaskDuration = 0.obs;
                freq.checkTotalTaskDuration = 0.obs;
                freq.totalTasksDuration = 0.obs;
                freq.iscool = false.obs;
                freq.tem = 0.obs;
                freq.isSelected = "أيام".obs;
                freq.goalTask = Rx<List<LocalTask>>([]);
                freq.newTasksAddedInEditing = Rx<List<LocalTask>>([]);
                freq.TasksMenue.value.clear();
                freq.selectedTasks.value.clear();
                freq.allTaskForDepency.value.clear();
                freq.itemCount = 0.obs;
                freq.itemCountAdd = 0.obs;
                Rx<List<String>> TasksMenue = Rx<List<String>>([]);
                Rx<List<String>> selectedTasks = Rx<List<String>>([]);
                Rx<List<TaskData>> allTaskForDepency = Rx<List<TaskData>>([]);
                Rx<TaskData> tryTask = Rx<TaskData>(TaskData());

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const navBar(
                        selectedIndex: 1,
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),

      /// body
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  /// field
                  TextFormField(
                    controller: _goalNmaeController,
                    //take out the goal name
                    //you might need to make sure it is eneterd before add and ot contian chracter.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "من فضلك ادخل اسم الهدف";
                      } else {
                        return null;
                      }
                    },

                    decoration: const InputDecoration(
                      labelText: "اسم الهدف",
                      prefixIcon: Icon(
                        Icons.task,
                        color: Color(0xFF66BF77),
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// Aspect selection dropdown
                  DropdownButtonFormField(
                    value: isSelected,
                    items: aspectList
                        .getSelectedNames()
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
                          isSelected = val as String;
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      color: Color(0xFF66BF77),
                    ),
                    validator: (value) => value == null
                        ? 'من فضلك اختر جانب الحياة المناسب للهدف'
                        : null,
                    decoration: const InputDecoration(
                      labelText: "جوانب الحياة ",
                      prefixIcon: Icon(
                        Icons.pie_chart,
                        color: Color(0xFF66BF77),
                      ),
                      border: UnderlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),

                  /// time selection
                  durationWidget(context),
                  const SizedBox(height: 30),

                  /// rating
                  Row(
                    children: [
                      const Text("الأهمية  :"),
                      const SizedBox(
                        width: 5,
                      ),
                      RatingBar.builder(
                        initialRating: 1,
                        itemCount: 3,
                        itemPadding: const EdgeInsets.all(9),
                        itemSize: 60,
                        tapOnlyMode: false,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Padding(
                                padding: EdgeInsets.all(15.0),
                                child: Icon(Icons.circle,
                                    color: Color(0xFF66BF77)),
                              );

                            case 1:
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.circle,
                                  color: Color(0xFF66BF77),
                                  size: 100,
                                ),
                              );
                            case 2:
                              return const Icon(
                                Icons.circle,
                                color: Color(0xFF66BF77),
                                size: 10000,
                              );

                            default:
                              return const Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                          }
                        },
                        onRatingUpdate: (rating) {
                          setState(() {
                            importance = rating.toInt();
                          });
                        },
                      )
                    ],
                  ),
                  const SizedBox(height: 30),

                  /// add task
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (selectedDates != null && goalDuration != 0) {
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AddTask(
                                      goalTask: widget.goalsTasks,
                                      isr: widget.isr,
                                      goalDurtion: goalDuration,
                                    );
                                  },
                                ),
                              );
                            }
                          } else {
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
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
                                        child: Text(
                                          "لإضافة المهام يجب تحديد فترة الهدف",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
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
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.03,
                      ),
                      txt(txt: "إضافة مهام", fontSize: 18),
                    ],
                  ),
                  //! change the space between the items and the submit button
                  SizedBox(
                    height: screenHeight(context) * 0.25,
                  ),
                  InkWell(
                    onTap: () {
                      if (isFirstclick) {
                        isFirstclick = false;

                        if ((formKey.currentState!.validate())) {
                          if (goalDuration != 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.green.shade300,
                                duration: const Duration(milliseconds: 500),
                                content: Row(
                                  children: const [
                                    Icon(Icons.thumb_up_sharp),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: Text("تمت اضافة الهدف "),
                                    ),
                                  ],
                                ),
                              ),
                            );

                            _Addgoal();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
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
                                      child: Text(
                                        " يجب تحديد فترة الهدف",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
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
                              txt: 'إضافة هدف',
                              fontSize: 16,
                              fontColor: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
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
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        DateTimeRange newDate;
                        return Scaffold(
                          body: Container(
                              color: Colors.white,
                              child: SfDateRangePicker(
                                  headerStyle: const DateRangePickerHeaderStyle(
                                      backgroundColor: kPrimaryColor),
                                  //to give restriction
                                  minDate: DateTime.now(),
                                  controller: newSelectedDate,
                                  confirmText: "تأكيد ",
                                  cancelText: "إلغاء",
                                  todayHighlightColor: Colors.blue,
                                  showActionButtons: true,
                                  onCancel: () {
                                    newSelectedDate.selectedRange = null;
                                    Navigator.pop(context);
                                  },
                                  onSubmit: (p0) {
                                    newDate = DateTimeRange(
                                        start: newSelectedDate
                                            .selectedRange!.startDate!,
                                        end: newSelectedDate
                                            .selectedRange!.endDate!);
                                    setState(() {
                                      if (newDate.duration.inDays <
                                          freq.checkTotalTaskDuration.value) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                duration: const Duration(
                                                    milliseconds: 1000),
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        255, 243, 9, 9),
                                                content: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.error,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Expanded(
                                                      child: Text(
                                                          "فترة الهدف ستصبح أقل من فترة المهام المدخلة",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    )
                                                  ],
                                                )));
                                      } else {
                                        goalDuration = newDate.duration.inDays;
                                        duration =
                                            '${goalDuration.toString()} يوما';
                                        selectedDates = newDate;
                                        Navigator.pop(context);
                                      }
                                    });
                                  },
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  initialSelectedRange: selectedDates != null
                                      ? PickerDateRange(
                                          selectedDates!.start,
                                          selectedDates!.end,
                                        )
                                      : null)),
                        );
                      });
                },

                ////
                // DateTimeRange? newDate = await showDateRangePicker(
                //   initialDateRange:
                //       selectedDates, // make here the goal selectd in datails '
                //   context: context,
                //   firstDate: DateTime.now().subtract(const Duration(days: 0)),
                //   lastDate: DateTime(2100),
                //   builder: (BuildContext context, Widget? child) {
                //     return Theme(
                //       data: ThemeData.light().copyWith(
                //         colorScheme: const ColorScheme.light(
                //           primary: kPrimaryColor,
                //           onPrimary: Colors.white,
                //           onSurface: kPrimaryColor,
                //         ),
                //       ),
                //       child: child!,
                //     );
                //   },
                // );

                //   setState(() {

                //     if (newDate != null) {
                //       if (newDate.duration.inDays <
                //           freq.totalTasksDuration.value) {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           SnackBar(
                //             duration: const Duration(milliseconds: 1000),
                //             backgroundColor: const Color.fromARGB(255, 243, 9, 9),
                //             content: Row(
                //               children: const [
                //                 Icon(
                //                   Icons.error,
                //                   color: Color.fromARGB(255, 0, 0, 0),
                //                 ),
                //                 SizedBox(width: 20),
                //                 Expanded(
                //                   child: Text(
                //                     "فترة الهدف ستصبح أقل من فترة المهام المدخلة",
                //                     style: TextStyle(color: Colors.black),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         );
                //       } else {
                //         goalDuration = newDate.duration.inDays;
                //         duration = '${goalDuration.toString()} يوما';
                //         selectedDates = newDate;
                //       }
                //     }
                //   });
                // },
                child: const Icon(
                  Icons.calendar_month,
                  color: kPrimaryColor,
                )),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  txt(txt: '${goalDuration.toString()} يوما', fontSize: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
