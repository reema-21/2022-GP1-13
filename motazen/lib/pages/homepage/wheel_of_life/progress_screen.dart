import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/wheel_of_life/AspectGoalList.dart';
import 'package:motazen/theme.dart';

class ProgressScreen extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const ProgressScreen({super.key, required this.isr, required this.aspect});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Icon chooseIcon(String? x) {
    Icon rightIcon = const Icon(Icons.abc);
    switch (x) {
      //Must include all the aspect characters and specify an icon for that
      case "Health and Wellbeing":
        {
          // statements;
          rightIcon = const Icon(Icons.spa, color: Color(0xFFffd400));
        }
        break;

      case "career":
        {
          //statements;
          rightIcon = const Icon(Icons.work, color: Color(0xff0065A3));
        }
        break;
      case "Family and Friends":
        {
          //statements;
          rightIcon = const Icon(Icons.person, color: Color(0xFFff9100));
        }
        break;

      case "Significant Other":
        {
          //statements;
          rightIcon = const Icon(
            Icons.favorite,
            color: Color(0xffff4949),
          );
        }
        break;
      case "Physical Environment":
        {
          //statements;
          rightIcon = const Icon(
            Icons.home,
            color: Color(0xFF9E19F0),
          );
        }
        break;
      case "money and finances":
        {
          //statements;
          rightIcon = const Icon(
            Icons.attach_money,
            color: Color(0xff54e360),
          );
        }
        break;
      case "Personal Growth":
        {
          //statements;
          rightIcon = const Icon(
            Icons.psychology,
            color: Color(0xFF2CDDCB),
          );
        }
        break;
      case "Fun and Recreation":
        {
          //statements;
          rightIcon = const Icon(
            Icons.games,
            color: Color(0xff008adf),
          );
        }
        break;
    }

    return rightIcon;
  }
  @override
  String AspectName (String name){
    String nameInArabic = "";
    switch (name) {
                    case "money and finances":
                      nameInArabic = "أموالي";
                      break;
                    case "Fun and Recreation":
                      nameInArabic = "متعتي";
                      break;
                    case "career":
                      nameInArabic = "مهنتي";
                      break;
                    case "Significant Other":
                      nameInArabic = "علاقاتي";
                      break;
                    case "Physical Environment":
                      nameInArabic = "بيئتي";
                      break;
                    case "Personal Growth":
                      nameInArabic = "ذاتي";
                      break;

                    case "Health and Wellbeing":
                      nameInArabic = "صحتي";
                      break;
                    case "Family and Friends":
                      nameInArabic = "عائلتي وأصدقائي";
                      break;
                  }
                  return nameInArabic ; 

  }
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: chooseIcon(widget.aspect.name),
          title: Text(
                          AspectName(widget.aspect.name),
                          textDirection: TextDirection.rtl,
                          style: titleText2,
                        ),
        automaticallyImplyLeading:true , // need color 
        backgroundColor: Colors.white,
        
    
    
        ),
         
        body:
         Container(
         
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromARGB(255, 236, 239, 240),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(child:
                          customCircularIndicator(
                              "الأهداف", widget.aspect.goals.length.toString(), "greenProgress.png", Colors.green,),
                              onTap: () {
                                Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                               

                                                return AspectGoal(isr: widget.isr, aspect: widget.aspect);
                                              }));
                                            }

                              ),
                              GestureDetector(child:
                          customCircularIndicator(
                              "العادات", widget.aspect.habits.length.toString(), 'yellowProgress.png', Colors.yellow),
                              onTap: () {
                                print("hi");
                              }, ),
                              
                              
                              
GestureDetector(child:
                           customCircularIndicator(
                              "المجتمعات", "3", 'blueProgress.png', Colors.blue),
                              onTap: () {
                                print("hi");
                              }, ),
                              
                          
                          
                          // Fixed for now need to be changed
                        ],
                      )),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color.fromARGB(255, 236, 239, 240),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'أهم أهدافك',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 102, 191, 119),
                                  fontSize: 25),
                            ),
                          ),
                          GestureDetector(
                            child:  customLinearIndicator(
                              "الهدف 1", 60, Colors.green.shade300, Colors.grey),
                              
                              onTap:() {
                                print("hi");
                              }),
                         
                          customLinearIndicator(
                              "الهدف 2", 65, Colors.green.shade300, Colors.grey),
                          customLinearIndicator(
                              "الهدف 3", 20, Colors.green.shade300, Colors.grey),
                        ],
                      )),
                )
              ],
            ),
          
        ),
      ),
    );
  }

  customCircularIndicator(
      String label, String text, String imageName, Color c1) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset(
                  'assets/images/$imageName',
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 43, 42, 42),
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                )

                ///
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50), color: c1),
              )
            ],
          )
        ],
      ),
    );
  }

  customLinearIndicator(String label, double val, Color c1, Color c2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: Text(
            label,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 250,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                minHeight: 25,
                value: 1 - (val / 100.0),
                backgroundColor: c1,
                valueColor: AlwaysStoppedAnimation(c2),
              ),
            ),
          ),
        )
      ],
    );
  }
}
