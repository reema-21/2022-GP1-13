// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

import "/assesment_page/alert_dialog.dart";
import 'handle_aspect_data.dart';
import '/assesment_page/show.dart';
import '/entities/aspect.dart';
import '/isar_service.dart';
import '../data/data.dart';
import '../theme.dart';

class AspectSelection extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? aspects;
  const AspectSelection({super.key, required this.isr, this.aspects});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  @override
  Widget build(BuildContext context) {
    //list of all aspects
    var aspectList = Provider.of<WheelData>(context);

    //local list of selected variables
    List<Aspect> selectedAspects = [];

    Widget doneButton(IsarService isar) {
      //once all quastion answare and the user is n any quastion it will be enabeld
      bool isAllQuastionAnswerd = true;
      if (selectedAspects.isEmpty) {
        isAllQuastionAnswerd = false;
      }

      return ElevatedButton(
        onPressed: isAllQuastionAnswerd
            ? () {
//call a method that add the index to the local and go to assignment page .
                selectedAspects = handle_aspect().getSelectedAspects();
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
                                        color: handle_aspect().getAspectColor(
                                            'Family and Friends'),
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
                                      handle_aspect()
                                          .updateStatus('Family and Friends');
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
                                        color: handle_aspect().getAspectColor(
                                            'Health and Wellbeing'),
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
                                      handle_aspect()
                                          .updateStatus('Health and Wellbeing');
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
                                        color: handle_aspect()
                                            .getAspectColor('Personal Growth'),
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
                                      handle_aspect()
                                          .updateStatus('Personal Growth');
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
                                        color: handle_aspect().getAspectColor(
                                            'Physical Environment'),
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
                                      handle_aspect()
                                          .updateStatus('Physical Environment');
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
                                        color: handle_aspect().getAspectColor(
                                            'Significant Other'),
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
                                      handle_aspect()
                                          .updateStatus('Significant Other');
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
                                        color: handle_aspect()
                                            .getAspectColor('career'),
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
                                      handle_aspect().updateStatus('career');
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
                                        color: handle_aspect().getAspectColor(
                                            'Fun and Recreation'),
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
                                      handle_aspect()
                                          .updateStatus('Fun and Recreation');
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
                                        color: handle_aspect().getAspectColor(
                                            'money and finances'),
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
                                      handle_aspect()
                                          .updateStatus('money and finances');
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
