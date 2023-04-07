// ignore_for_file: camel_case_types

import 'package:motazen/isar_service.dart';

import 'add_habit.dart';

import 'package:flutter/material.dart';

import '../../entities/aspect.dart';

class getChosenAspectH extends StatefulWidget {
  final IsarService iser;
  const getChosenAspectH({
    super.key,
    required this.iser,
  });

  @override
  State<getChosenAspectH> createState() => _showsState();
}

class _showsState extends State<getChosenAspectH> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: widget.iser.getchoseAspect(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              List? aspects = snapshot.data;
              List<String> selected = [];
              for (int i = 0; i < aspects!.length; i++) {
                Aspect x = aspects[i];
                String nameInArabic = "";
                switch (x.name) {
                  case "أموالي":
                    nameInArabic = "أموالي";
                    break;
                  case "متعتي":
                    nameInArabic = "متعتي";
                    break;
                  case "مهنتي":
                    nameInArabic = "مهنتي";
                    break;
                  case "علاقاتي":
                    nameInArabic = "علاقاتي";
                    break;
                  case "بيئتي":
                    nameInArabic = "بيئتي";
                    break;
                  case "ذاتي":
                    nameInArabic = "ذاتي";
                    break;

                  case "صحتي":
                    nameInArabic = "صحتي";
                    break;
                  case "عائلتي واصدقائي":
                    nameInArabic = "عائلتي واصدقائي";
                    break;
                }

                selected.add(nameInArabic);
              }
              return AddHabit(
                isr: widget.iser,
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
