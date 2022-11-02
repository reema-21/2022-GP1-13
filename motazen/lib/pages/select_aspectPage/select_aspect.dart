// ignore_for_file: camel_case_types, iterable_contains_unrelated_type, list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:provider/provider.dart';

import '../assesment_page/show.dart';
import '../assesment_page/alert_dialog.dart';
import 'handle_aspect_data.dart';
import '/isar_service.dart';
import '../../data/data.dart';
import '../../theme.dart';

class AspectSelection extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? aspects;
  const AspectSelection({super.key, required this.isr, this.aspects});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    //list of all aspects
    var aspectList = Provider.of<WheelData>(context);

    //a temporary list that holds the selected aspect names (remove when the get color bug is fixed)
    List<String> selectedAspects = [];

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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AssessmentQuestionsList(
                        iser: widget.isr,
                        fixedAspect: widget.aspects,
                        chosenAspect: selectedAspects);
                  },
                ));
              }
            : null,
        child: const Text("التالي"),
      );
    }

//initialize aspects to DB
    handle_aspect().initializeAspects(aspectList.data);
    Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      builder: (context, snapshot) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: kWhiteColor,
            appBar: AppBar(
              title: const Text(
                'هل أنت مستعد لإنشاء عجلة الحياة الخاصة بك ؟',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
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
                      }
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
                          margin: const EdgeInsets.symmetric(horizontal: 4),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: _isSelected
                                                ? Color(aspectList
                                                        .data[0].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[0].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect().updateStatus(
                                              'Family and Friends');
                                          //temp solution
                                          if (selectedAspects
                                              .contains('Family and Friends')) {
                                            selectedAspects
                                                .remove('Family and Friends');
                                            setState(() {
                                              _isSelected = false;
                                            });
                                          } else {
                                            selectedAspects
                                                .add('Family and Friends');
                                            setState(() {
                                              _isSelected = true;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        width: 18,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects.contains(
                                                    'Health and Wellbeing')
                                                ? Color(aspectList
                                                        .data[1].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[1].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect().updateStatus(
                                              'Health and Wellbeing');
                                        },
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 15,
                                  width: 10,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects
                                                    .contains('Personal Growth')
                                                ? Color(aspectList
                                                        .data[2].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[2].color)
                                                    .withOpacity(0.18),
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
                                          //temp solution
                                          if (selectedAspects
                                              .contains('Personal Growth')) {
                                            selectedAspects
                                                .remove('Personal Growth');
                                          } else {
                                            selectedAspects
                                                .add('Personal Growth');
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        width: 18,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects
                                                    .contains('Personal Growth')
                                                ? Color(aspectList
                                                        .data[2].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[2].color)
                                                    .withOpacity(0.18),
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
                                                    fontSize: 18),
                                              )
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          handle_aspect().updateStatus(
                                              'Physical Environment');
                                          //temp solution
                                          if (selectedAspects.contains(
                                              'Physical Environment')) {
                                            selectedAspects
                                                .remove('Physical Environment');
                                          } else {
                                            selectedAspects
                                                .add('Physical Environment');
                                          }
                                        },
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 15,
                                  width: 10,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects.contains(
                                                    'Significant Other')
                                                ? Color(aspectList
                                                        .data[4].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[4].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect().updateStatus(
                                              'Significant Other');
                                          //temp solution
                                          if (selectedAspects
                                              .contains('Significant Other')) {
                                            selectedAspects
                                                .remove('Significant Other');
                                          } else {
                                            selectedAspects
                                                .add('Significant Other');
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        width: 18,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects
                                                    .contains('career')
                                                ? Color(aspectList
                                                        .data[5].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[5].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect()
                                              .updateStatus('career');
                                          //temp solution
                                          if (selectedAspects
                                              .contains('career')) {
                                            selectedAspects.remove('career');
                                          } else {
                                            selectedAspects.add('career');
                                          }
                                        },
                                      ),
                                    ]),
                                const SizedBox(
                                  height: 15,
                                  width: 10,
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects.contains(
                                                    'Fun and Recreation')
                                                ? Color(aspectList
                                                        .data[6].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[6].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect().updateStatus(
                                              'Fun and Recreation');
                                          //temp solution
                                          if (selectedAspects
                                              .contains('Fun and Recreation')) {
                                            selectedAspects
                                                .remove('Fun and Recreation');
                                          } else {
                                            selectedAspects
                                                .add('Fun and Recreation');
                                          }
                                        },
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        width: 18,
                                      ),
                                      GestureDetector(
                                        child: Container(
                                          height: 92,
                                          width: 170,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: selectedAspects.contains(
                                                    'money and finances')
                                                ? Color(aspectList
                                                        .data[7].color)
                                                    .withOpacity(1)
                                                : Color(aspectList
                                                        .data[7].color)
                                                    .withOpacity(0.18),
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
                                          handle_aspect().updateStatus(
                                              'money and finances');
                                          //temp solution
                                          if (selectedAspects.contains(
                                              'money and financesn')) {
                                            selectedAspects
                                                .remove('money and finances');
                                          } else {
                                            selectedAspects
                                                .add('money and finances');
                                          }
                                        },
                                      ),
                                    ]),
                              ]))),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 60, horizontal: 30),
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
      },
    );
  }
}
