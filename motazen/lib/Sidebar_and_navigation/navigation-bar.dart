// ignore_for_file: file_names, camel_case_types

import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:motazen/theme.dart';
import '/pages/goals_habits_tab/goal_habits_pages.dart';
import '/isar_service.dart';
import '/pages/homepage/homepage.dart';

///add page redirection later
///
class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _MynavBar();
}

class _MynavBar extends State<navBar> {
  navigate(int index) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    IsarService isar = IsarService();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 0.5, color: Colors.grey.shade300),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          child: GNav(
            gap: 8, // the tab button gap between icon and text
            color: kBlackColor, // unselected icon color
            activeColor: kWhiteColor, // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor: kPrimaryColor, // selected tab background color
            padding: const EdgeInsets.all(16.0), // navigation bar padding
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'الرئسية',
                onPressed: () {
                  const Homepage();
                },
              ),
              GButton(
                icon: LineIcons.check, //click here move me to a page
                text: 'عاداتي وأهدافي',
                onPressed: () {
                  Goals_habit(
                    iser: isar,
                  );
                },
              ),
              GButton(
                  icon: LineIcons.peopleCarry,
                  text: 'مجتمعاتي',
                  onPressed: () {
                    null;
                  }),
              GButton(
                  icon: LineIcons.book,
                  text: 'مذكرتي',
                  onPressed: () {
                    null;
                  }),
            ],
            onTabChange: navigate,
          ),
        ),
      ),
    );
  }
}
