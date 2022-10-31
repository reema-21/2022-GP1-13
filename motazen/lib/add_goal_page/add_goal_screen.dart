import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';

class AddGoal extends StatefulWidget {
   final IsarService isr;
   final List<String>? chosenAspectNames ;
  const AddGoal({super.key, required this.isr, this.chosenAspectNames});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Directionality(textDirection: TextDirection.rtl , child: Scaffold(),),)
  }
}