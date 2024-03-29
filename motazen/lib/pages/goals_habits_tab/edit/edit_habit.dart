import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/controllers/edit_controller.dart';
import 'package:motazen/pages/assesment_page/alert_dialog.dart';
import 'package:motazen/theme.dart';
import 'package:provider/provider.dart';
import '../../../Sidebar_and_navigation/navigation_bar.dart';
import '/entities/habit.dart';
import 'package:get/get.dart';
import '../../../../entities/aspect.dart';

class EditHabit extends StatefulWidget {
  final IsarService isr;
  final List<Aspect>? chosenAspectNames;
  final String habitName;
  final String habitFrequency;
  final String habitAspect;
  final int durationInInt;
  final int duraioninString;
  final int id;

  const EditHabit({
    super.key,
    required this.isr,
    this.chosenAspectNames,
    required this.habitName,
    required this.habitFrequency,
    required this.habitAspect,
    required this.durationInInt,
    required this.duraioninString,
    required this.id,
  });

  @override
  State<EditHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<EditHabit> {
  final _editHabitFormKey = GlobalKey<FormState>(
      debugLabel: 'editHabitFormKey-${UniqueKey().toString()}');
  late int durationIndString;
  late int durationInInt;
  final _goalNmaeController = TextEditingController();
  final _goalaspectController = TextEditingController(); // for fixed habits
  final EditMyControleer freq = Get.find();
  final List<String> durations = ['اليوم', 'الأسبوع', 'الشهر', 'السنة'];
  String? isDuration;
  String duratioSelected = "";
  String? isSelected;

  @override
  void initState() {
    super.initState();

    _goalNmaeController.text = widget.habitName;

    freq.setvalue(widget.durationInInt);
    durationIndString = widget.duraioninString;
    durationInInt = widget.durationInInt;
    isDuration = durations[widget.duraioninString];
    for (int i = 0; i < widget.chosenAspectNames!.length; i++) {
      String name = widget.chosenAspectNames![i].name;
      if (name.contains(widget.habitAspect)) {
        isSelected = widget.chosenAspectNames![i].name;
      }
    }
    _goalaspectController.text = isSelected!;
    switch (durationIndString) {
      case 0:
        duratioSelected = " مرات في اليوم ";
        durationIndString = 0;
        break;
      case 1:
        duratioSelected = " مرات في الأسبوع ";
        durationIndString = 1;
        break;
      case 2:
        duratioSelected = " مرات في الشهر ";
        durationIndString = 2;
        break;
      case 3:
        duratioSelected = " مرات في السنة  ";
        durationIndString = 3;
        break;
    }
    // should be the mumber of the string
  }

  String aspectnameInEnglish = "";
  Habit? habit = Habit(userID: IsarService.getUserID);
  _addHabit() async {
    habit = await widget.isr.getSepecificHabit(widget.id);
    habit?.titel = _goalNmaeController.text;

    habit?.durationIndString = durationIndString;
    habit?.durationInNumber = freq.frequency.toInt();
    duratioSelected = freq.frequency.string + duratioSelected;
    habit?.frequency = duratioSelected;

    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    habit?.aspect.value = selected;

    widget.isr.updateHabit(habit!);

    //should be the name days
    // should be the number in frequency
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return NavBar(
          selectedIndex: 1,
          selectedNames:
              Provider.of<AspectController>(context).getSelectedNames(),
        );
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF66BF77),
        title: const Text(
          "تعديل معلومات العادة",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      ' هل انت متاكد من الرجوع ',
                      'بالنقر على "تاكيد"لن يتم حفظ التغييرات التي قمت بها');
                  if (action == DialogsAction.yes) {
                    //! it should return to the habits tab
                    if (mounted) {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return NavBar(
                          selectedIndex: 1,
                          selectedNames: Provider.of<AspectController>(context)
                              .getSelectedNames(),
                        );
                      }));
                    }
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ));
          },
        ),
      ),
      body: Stack(children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _editHabitFormKey,
            child: ListView(children: [
              TextFormField(
                controller: _goalNmaeController,
                //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "من فضلك ادخل اسم العادة";
                  } else {
                    return null;
                  }
                },

                decoration: const InputDecoration(
                  labelText: "اسم العادة",
                  prefixIcon: Icon(
                    Icons.verified_user_outlined,
                    color: Color(0xFF66BF77),
                  ),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      duration: Duration(milliseconds: 900),
                      backgroundColor: Color.fromARGB(255, 230, 38, 38),
                      content: Row(
                        children: [
                          Icon(
                            Icons.error,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text("لا يمكن تغيير جانب حياة العادة ",
                                style: TextStyle(color: Colors.black)),
                          )
                        ],
                      )));
                },
                child: TextFormField(
                  enabled: false,
                  controller: _goalaspectController,
                  //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.

                  decoration: const InputDecoration(
                    labelText: "جانب الحياة ",
                    prefixIcon: Icon(
                      Icons.verified_user_outlined,
                      color: Color.fromARGB(255, 164, 175, 166),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              //Frequency .

              Row(
                children: [
                  const Text("عدد مرات التكرار"),
                  const SizedBox(
                    width: 15,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF66BF77),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 15,
                        ),
                        onPressed: () {
                          freq.increment();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Obx((() => Text(
                        freq.frequency.toString(),
                        style: const TextStyle(fontSize: 20),
                      ))),
                  const SizedBox(width: 10),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF66BF77),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.remove,
                          color: Colors.white, size: 15),
                      onPressed: () {
                        freq.dcrement();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              DropdownButtonFormField(
                value: isDuration,
                items: durations
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    isDuration = val as String;
                    switch (isDuration) {
                      case "اليوم":
                        duratioSelected = " مرات في اليوم ";
                        durationIndString = 0;
                        break;
                      case "الأسبوع":
                        duratioSelected = " مرات في الأسبوع ";
                        durationIndString = 1;
                        break;
                      case "الشهر":
                        duratioSelected = " مرات في الشهر ";
                        durationIndString = 2;
                        break;
                      case "السنة":
                        duratioSelected = " مرات في السنة  ";
                        durationIndString = 3;
                        break;
                    }
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down_circle,
                  color: Color(0xFF66BF77),
                ),
                validator: (value) =>
                    value == null ? 'من فضلك معدل التكرار' : null,
                decoration: const InputDecoration(
                  labelText: "خلال ",
                  prefixIcon: Icon(
                    Icons.av_timer_outlined,
                    color: Color(0xFF66BF77),
                  ),
                  border: UnderlineInputBorder(),
                ),
              ),

              SizedBox(
                height: screenHeight(context) * 0.25,
              ),

              InkWell(
                onTap: () {
                  if (_editHabitFormKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Row(
                      children: [
                        Icon(
                          Icons.thumb_up_sharp,
                          color: kWhiteColor,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text("تم حفظ التغييرات بنجاح "),
                        )
                      ],
                    )));

                    _addHabit();
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
                          txt: 'تعديل العادة',
                          fontSize: 16,
                          fontColor: Colors.white)),
                ),
              )
            ]),
          ),
        ),
      ]),
    );
  }
}
