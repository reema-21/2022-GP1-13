// ignore_for_file: camel_case_types

import "package:motazen/assesment_page/alert_dialog.dart";
import 'package:flutter/material.dart';
import 'package:motazen/assesment_page/show.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import '../theme.dart';

class AspectSelection extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? aspects;
  const AspectSelection({super.key, required this.isr, this.aspects});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  var indexs =
      []; //must have the selected aspct // change it to have all aspects
  //make sure to always empty data before a new use
  int? selectedIndex;

  bool isSelected(String selectedaaspect) {
    //already implemented in isar
    if (indexs.contains(selectedaaspect)) {
      return true;
    }
    return false;
  }

  saveChosenAspect(IsarService isar) async {
    for (int i = 0; i < indexs.length; i++) {
      Aspect x = Aspect();
      x.name = indexs[i];
      x.percentagePoints = 0;
      isar.createAspect(x);
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AssessmentQuestionsList(
          iser: widget.isr, fixedAspect: widget.aspects, chosenAspect: indexs);
    }));
  }

  @override
  Widget build(BuildContext context) {
    Widget doneButton(IsarService isar) {
      //once all quastion answare and the user is n any quastion it will be enabeld
      bool isAllQuastionAnswerd = true;
      if (indexs.isEmpty) {
        isAllQuastionAnswerd = false;
      }

      return ElevatedButton(
        onPressed: isAllQuastionAnswerd
            ? () {
//call a method that add the index to the local and go to assignment page .
                saveChosenAspect(widget.isr);
              }
            : null,
        child: const Text("التالي"),
      );
    }

    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          title: const Text(
            'هل أنت مستعد لإنشاء عجلة الحياة الخاصة بك ؟',
            textDirection: TextDirection.rtl,
            style: TextStyle(
                fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          backgroundColor: const Color(0xFF86BE90),
          elevation: 0.0,
          actions: [
            IconButton(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.arrow_back_ios_new,
                    color: const Color.fromARGB(255, 245, 241, 241)),
                onPressed: () async {
                  final action = await AlertDialogs.yesCancelDialog(
                      context,
                      ' هل انت متاكد من الرجوع ',
                      'بالنقر على "تاكيد"لن يتم حفظ جوانب الحياة التي قمت باختيارها  ');
                  if (action == DialogsAction.yes) {
                    //return to the previouse page different code for the ios .
                    // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
                  } else {}
                }),
          ],
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5,
                child: ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                      height: 100,
                      decoration:
                          const BoxDecoration(color: Color(0xFF86BE90))),
                ),
              ),
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  padding: const EdgeInsets.only(right: 35),
                  height: 90,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 134, 190, 144)),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "اختر الجوانب اللي تريد اضافتها للعجلة",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ]),
                  ),
                ),
              ),
              //align the aspect buttons
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: size.height - (size.height / 3),
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("Family and Friends")
                                            ? const Color(0xFFff9100)

                                            ///get colors from db
                                            : const Color.fromARGB(
                                                101, 255, 145, 0),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            widget.aspects?[0],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Family and Friends")

                                            ///use set isSelectes instead and set it to  true
                                            ? indexs
                                                .remove("Family and Friends")
                                            : indexs.add("Family and Friends"));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 18,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color:
                                            isSelected("Health and Wellbeing")
                                                ? const Color(0xFFffd400)
                                                : const Color.fromARGB(
                                                    99, 255, 213, 0),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.spa,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[1],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Health and Wellbeing")
                                            ? indexs
                                                .remove("Health and Wellbeing")
                                            : indexs
                                                .add("Health and Wellbeing"));
                                      });
                                    },
                                  ),
                                ]),
                            const SizedBox(
                              height: 15,
                              width: 10,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("Personal Growth")
                                            ? const Color(0xFF2CDDCB)
                                            : const Color.fromARGB(
                                                92, 44, 221, 203),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.psychology,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[2],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Personal Growth")
                                            ? indexs.remove("Personal Growth")
                                            : indexs.add("Personal Growth"));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 18,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color:
                                            isSelected("Physical Environment")
                                                ? const Color(0xFF9E19F0)
                                                : const Color.fromARGB(
                                                    92, 158, 25, 240),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.home,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[3],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Physical Environment")
                                            ? indexs
                                                .remove("Physical Environment")
                                            : indexs
                                                .add("Physical Environment"));
                                      });
                                    },
                                  ),
                                ]),
                            const SizedBox(
                              height: 15,
                              width: 10,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("Significant Other")
                                            ? const Color(0xffff4949)
                                            : const Color.fromARGB(
                                                103, 255, 73, 73),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.favorite,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[4],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Significant Other")
                                            ? indexs.remove("Significant Other")
                                            : indexs.add("Significant Other"));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 18,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("career")
                                            ? const Color(0xff0065A3)
                                            : const Color.fromARGB(
                                                103, 0, 100, 163),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.work,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[5],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("career")
                                            ? indexs.remove("career")
                                            : indexs.add("career"));
                                      });
                                    },
                                  ),
                                ]),
                            const SizedBox(
                              height: 15,
                              width: 10,
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("Fun and Recreation")
                                            ? const Color(0xff008adf)
                                            : const Color.fromARGB(
                                                106, 90, 112, 124),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(8, 8))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.games,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[6],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("Fun and Recreation")
                                            ? indexs
                                                .remove("Fun and Recreation")
                                            : indexs.add("Fun and Recreation"));
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                    width: 18,
                                  ),
                                  GestureDetector(
                                    child: Container(
                                      height: 92,
                                      width: 182,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: isSelected("money and finances")
                                            ? const Color(0xff54e360)
                                            : const Color.fromARGB(
                                                90, 84, 227, 96),
                                        border: Border.all(
                                            color: Colors.white, width: 10),
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 50,
                                              color: const Color(0xFF0B0C2A)
                                                  .withOpacity(0.09),
                                              offset: const Offset(10, 10))
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.attach_money,
                                            size: 30,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.aspects?[7],
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        (indexs.contains("money and finances")
                                            ? indexs
                                                .remove("money and finances")
                                            : indexs.add("money and finances"));
                                      });
                                    },
                                  ),
                                ]),
                          ]))),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: doneButton(widget.isr),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
