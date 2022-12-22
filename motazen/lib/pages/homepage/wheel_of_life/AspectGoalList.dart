// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isarService.dart';
import 'package:motazen/theme.dart';

class AspectGoal extends StatefulWidget {
  final IsarService isr;
  final Aspect aspect;
  const AspectGoal({super.key, required this.isr, required this.aspect});

  @override
  State<AspectGoal> createState() => _AspectGoal();
}

class _AspectGoal extends State<AspectGoal> {
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

  String AspectName(String name) {
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
    return "$nameInArabicأهداف ";
  }

  @override
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
            automaticallyImplyLeading: true, // need color
            backgroundColor: Colors.white,
          ),
        ));
  }
}
