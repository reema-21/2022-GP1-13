import "package:motazen/assesment_page/alert_dialog.dart";
import 'package:flutter/material.dart';
import 'package:motazen/assesment_page/show.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';

import '../assesment_page/assesment_question_page_assignments.dart';
import 'data.dart';

class selectAspect extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? aspects;
  const selectAspect({super.key, required this.isr,  this.aspects});

  @override
  State<selectAspect> createState() => _selectAspectState();
}

class _selectAspectState extends State<selectAspect> {
  var indexs = []; //must have the selected aspct
  int? selectedIndex;


  bool isSelected(String selectedaaspect) {
    if (indexs.contains(selectedaaspect)) {
      return true;
    }
    return false;
  }


  


  saveChosenAspect(IsarService isar) async {
    for (int i = 0 ; i< indexs.length ; i++){
     Aspect x = Aspect(); 
  x.name= indexs[i];
  x.percentagePoints=0;
  isar.createAspect(x);
  print(x.name);
  

    }

     Navigator.push(context, MaterialPageRoute(builder: (context) {
                return shows(iser: widget.isr ,fixedAspect: widget.aspects ,chosenAspect:indexs);
              }));
  }
  
  Widget build(BuildContext context) {
    String f = widget.aspects?[0];
Widget doneButton(IsarService isar) {
    //once all quastion answare and the user is n any quastion it will be enabeld
    bool isAllQuastionAnswerd = true;
    if (indexs.isEmpty){
      isAllQuastionAnswerd=false;
    }
   
    return ElevatedButton(
      onPressed: isAllQuastionAnswerd
          ? () {
//call a method that add the index to the local and go to assignment page .
             saveChosenAspect(widget.isr );
            }
          : null,
      child: const Text("التالي"),
    );
  }
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: Stack(children: [
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24),
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 134, 190, 144)),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                // ignore: prefer_const_constructors
                                icon: Icon(Icons.arrow_back_ios_new,
                                    color: const Color.fromARGB(
                                        255, 245, 241, 241)),
                                onPressed: () async {
                                  final action = await AlertDialogs.yesCancelDialog(
                                      context,
                                      ' هل انت متاكد من الرجوع ',
                                      'بالنقر على "تاكيد"لن يتم حفظ جوانب الحياة التي قمت باختيارها  ');
                                  if (action == DialogsAction.yes) {
                                    //return to the previouse page different code for the ios .
                                    // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
                                  } else {
                                    print("bey");
                                  }
                                }),
                          ],
                        ),
                        const Text(
                          "هل أنت مستعد لإنشاء عجلة الحياة الخاصة بك ؟",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text(
                          "اختر الجوانب اللي تريد اضافتها للعجلة",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ]),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      height: size.height - (size.height / 5),
                      width: size.width,
                      // ignore: prefer_const_constructors
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // ignore: prefer_const_constructors
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(34),
                          topRight: Radius.circular(34),
                        ),
                      ),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Family and Friends")
                                                  ? const Color(0xFFff9100)
                                                  :  const Color.fromARGB(101, 255, 145, 0),
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
                                              ? indexs
                                                  .remove("Family and Friends")
                                              : indexs
                                                  .add("Family and Friends"));
                                        });
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Health and Wellbeing")
                                                  ? const Color(0xFFffd400)
                                                  :Color.fromARGB(99, 255, 213, 0),
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
                                      width:5,
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
                                        print(indexs);
                                      },
                                    ),
                                  ]),
                              SizedBox(
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Personal Growth")
                                                  ? const Color(0xFF2CDDCB)
                                                  : Color.fromARGB(92, 44, 221, 203),
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
                                      width:5,
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
                                              ? indexs
                                                  .remove("Personal Growth")
                                              : indexs
                                                  .add("Personal Growth"));
                                        });
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Physical Environment")
                                                  ? const Color(0xFF9E19F0)
                                                  : Color.fromARGB(92, 158, 25, 240),
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
                                      width:5,
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
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Significant Other")
                                                  ? const Color(0xffff4949)
                                                  : Color.fromARGB(103, 255, 73, 73),
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
                                      width:5,
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
                                              ? indexs
                                                  .remove("Significant Other")
                                              : indexs
                                                  .add("Significant Other"));
                                        });
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("career")
                                                  ?const Color(0xff0065A3)
                                                  : Color.fromARGB(103, 0, 100, 163),
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
                                      width:5,
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
                                              ? indexs
                                                  .remove("career")
                                              : indexs
                                                  .add("career"));
                                        });
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("Fun and Recreation")
                                                  ? const Color(0xff008adf)
                                                  : Color.fromARGB(
                                                      106, 90, 112, 124),
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
                                              Icons.games,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                             const SizedBox(
                                      width:5,
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
                                              : indexs
                                                  .add("Fun and Recreation"));
                                        });
                                        print(indexs);
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
                                          borderRadius:
                                              BorderRadius.circular(24),
                                          color:
                                              isSelected("money and finances")
                                                  ?  const Color(0xff54e360)
                                                  :  Color.fromARGB(90, 84, 227, 96),
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
                                      width:5,
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
                                              : indexs
                                                  .add("money and finances"));
                                        });
                                        print(indexs);
                                      },
                                    ),
                                   
                                  ]),
                            ]),
                      )))
            ],),
            bottomSheet: doneButton(widget.isr),
            ),),

            );



// class AspectCard extends StatelessWidget {
//   final  Color color;
//   final String aspectName;
//   final Icon icon  ;
//   const AspectCard({super.key, required this.color, required this.aspectName, required this.icon});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height:155 ,
//       width: 192,
//       decoration:BoxDecoration(
//         color:color ,
//       borderRadius:BorderRadius.circular(24)
//       )
//     );
//   }
  }
}
