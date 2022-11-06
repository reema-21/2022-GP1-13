// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import '/entities/habit.dart';

import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:get/get.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import"my_controller.dart";
import '../../entities/aspect.dart';

//TODO
//alertof completion //tasks // getbeck to the list page // goal dependency
class AddHabit extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  const AddHabit({super.key, required this.isr, this.chosenAspectNames});

  @override
  State<AddHabit> createState() => _AddHabitState();
}

class _AddHabitState extends State<AddHabit> {
  final formKey411 = GlobalKey<FormState>();
  late String _habitName;
  final MyControleer freq = Get.put(MyControleer());
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final _goalNmaeController = TextEditingController();
  final List<String> durations =['اليوم','الأسبوع','الشهر','السنة'];

  String? isSelected;
  String? isDuration ; 
  String duratioSelected ="";
  @override
  void initState() {
    super.initState();
    _goalNmaeController.addListener(_updateText);
  }

  void _updateText() {
    setState(() {
      _habitName = _goalNmaeController.text;
    });
  }

  Habit newhabit = Habit();
  String aspectnameInEnglish = "";
  int seletedduration = 0 ; 
  _AddHabit() async {
    newhabit.titel = _habitName;
    newhabit.durationIndString = seletedduration ; 
newhabit.durationInNumber = freq.frequency.toInt();
    duratioSelected=freq.frequency.string+duratioSelected;
    newhabit.frequency = duratioSelected;
    print(newhabit.frequency);
    Aspect? selected =
        await widget.isr.findSepecificAspect(aspectnameInEnglish);
    newhabit.aspect.value = selected;
    widget.isr.createHabit(newhabit);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Goals_habit(iser: widget.isr);
    }));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return GetMaterialApp(
      home: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
resizeToAvoidBottomInset: false,
             floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
             

            floatingActionButton: FloatingActionButton(
              
              child: Icon(Icons.add),
              
              onPressed: () {

                  if (formKey411.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Row(
                      children: [
                        Icon(Icons.thumb_up_sharp),
                        SizedBox(width: 20),
                        Expanded(
                          child: Text("تمت اضافة العادة "),
                        )
                      ],
                    )));

                    _AddHabit();
                  }
                }),
            key: _scaffoldkey,
            appBar: AppBar(
              backgroundColor: const Color(0xFF66BF77),
              title: const Text(
                "إضافة عادة جديدة",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                IconButton(
                    // ignore: prefer_const_constructors
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () async {
                      final action = await AlertDialogs.yesCancelDialog(
                          context,
                          ' هل انت متاكد من الرجوع ',
                          'بالنقر على "تاكيد"لن يتم حفظ معلومات العادة  ');
                      if (action == DialogsAction.yes) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Goals_habit(
                            iser: widget.isr,
                          );
                        }));
                      } else {}
                    }),
              ],
            ),
            body: Stack(children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey411,
                  child: ListView(children: [
                    TextFormField(
                      controller: _goalNmaeController,
                      //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "من فضلك ادخل اسم العادة";
                        } else {
                          print("hi");
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

                    /// Aspect selectio

                    DropdownButtonFormField(
                      value: isSelected,
                      items: widget.chosenAspectNames
                          ?.map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          isSelected = val as String;
                          switch (isSelected) {
                            case "أموالي":
                              aspectnameInEnglish = "money and finances";
                              break;
                            case "متعتي":
                              aspectnameInEnglish = "Fun and Recreation";
                              break;
                            case "مهنتي":
                              aspectnameInEnglish = "career";
                              break;
                            case "علاقاتي":
                              aspectnameInEnglish = "Significant Other";
                              break;
                            case "بيئتي":
                              aspectnameInEnglish = "Physical Environment";
                              break;
                            case "ذاتي":
                              aspectnameInEnglish = "Personal Growth";
                              break;

                            case "صحتي":
                              aspectnameInEnglish = "Health and Wellbeing";
                              break;
                            case "عائلتي وأصدقائي":
                              aspectnameInEnglish = "Family and Friends";
                              break;
                          }
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down_circle,
                        color: Color(0xFF66BF77),
                      ),
                      validator: (value) => value == null
                          ? 'من فضلك اختر جانب الحياة المناسب للعادة'
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
                    const SizedBox(
                      height: 30,
                    ),
                    //Frequency .


                    //add pluse mins 
                    // TextFormField(
                    //   controller: _habitFrequencyController,
                    //   //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return "من فضلك ادخل عدد مرات تكرار العادة";
                    //     } else {
                    //       print("hi");
                    //       return null;
                    //     }
                    //   },

                    //   decoration: const InputDecoration(
                    //     labelText: "عدد مرات تكرار العادة",
                    //     prefixIcon: Icon(
                    //       Icons.verified_user_outlined,
                    //       color: Color(0xFF66BF77),
                    //     ),
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),
                    //  const SizedBox(
                    //   height: 25,
                    // ),
Row(
  children: [
    Text("عدد مرات التكرار"),
     const SizedBox(
                      width: 15,
                    ),
  Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25)
      , color: Color(0xFF66BF77),

    ),
    child: Center(
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white,size: 15, ),
        onPressed: (){freq.increment();},
      ),
    ),
  ),
  SizedBox(width:10,),
  Obx((() => Text("${freq.frequency.toString()}",
  style: TextStyle(fontSize: 20),))),
   
   
    SizedBox(width:10),

  Container(
    width: 30,
    height: 30,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25)
      , color: Color(0xFF66BF77),

    ),
    child: IconButton(
      icon: Icon(Icons.remove, color: Colors.white,size:15),
      onPressed: (){freq.dcrement();},
    ),
  ),
   
],),
  SizedBox(
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
                            seletedduration=0;

                              duratioSelected = " مرات في اليوم ";
                              break;
                            case "الأسبوع":
                            seletedduration=1;
                              duratioSelected = " مرات في الأسبوع ";
                              break;
                            case "الشهر":
                            seletedduration=2;
                              duratioSelected = " مرات في الشهر ";
                              break;
                              case "السنة":
                              seletedduration=3;
                              duratioSelected = " مرات في السنة  ";
                              break;
                            
                          }
                        });
                      },
                        icon: const Icon(
                          Icons.arrow_drop_down_circle,
                          color: Color(0xFF66BF77),
                        ),
                        validator: (value) => value == null
                            ? 'من فضلك أدخل معدل التكرار'
                            : null,
                        decoration: const InputDecoration(
                          labelText: "خلال ",
                          prefixIcon: Icon(
                            Icons.av_timer_outlined,
                            color: Color(0xFF66BF77),
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),



                    // end of pluse mins
                  ]),
                ),
              ),
            ]),
           
          )),
    );
  }
}
