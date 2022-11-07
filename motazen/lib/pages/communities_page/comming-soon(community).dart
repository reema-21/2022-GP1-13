// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/theme.dart';

class Communities extends StatelessWidget {
  const Communities({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'comming soon',
          style: titleText,
        ),
      ),
      bottomNavigationBar: const navBar(),
    );
  }
}
