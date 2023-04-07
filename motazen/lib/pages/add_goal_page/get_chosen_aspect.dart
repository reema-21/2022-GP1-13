// ignore_for_file: camel_case_types

import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../isar_service.dart';
import '../../controllers/aspect_controller.dart';

class getChosenAspect extends StatefulWidget {
  final String? origin;
  const getChosenAspect({
    super.key,
    this.origin,
  });

  @override
  State<getChosenAspect> createState() => _showsState();
}

class _showsState extends State<getChosenAspect> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: IsarService().getSelectedAspects(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              //a list of selected aspects
              aspectList.selected = snapshot.data!;
              return const navBar(
                selectedIndex: 0,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
  }
}
