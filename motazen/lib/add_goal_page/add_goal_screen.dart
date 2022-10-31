import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';

import '../Sidebar_and_navigation/navigation-bar.dart';
import '../Sidebar_and_navigation/sidebar.dart';

class AddGoal extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
  const AddGoal(
      {super.key,
      required this.isr,
      this.chosenAspectNames,
      required List aspects});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 30.0,
          // notifications button
          backgroundColor: const Color(0xFFffffff),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          leading: const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              tooltip: 'View Requests'),
        ),
        endDrawer: const NavBar(),
        body: SafeArea(
          child: Container(),

          ///add your code here
        ),
        bottomNavigationBar: const navBar(),
      ),
    );
  }
}
