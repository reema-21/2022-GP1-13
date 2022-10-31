// ignore_for_file: file_names

import 'package:isar/isar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:motazen/goals_habits_tab/goal_habits_pages.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/pages/homepage/homepage.dart';
import 'package:motazen/select_aspectPage/select_aspect.dart';

///add page redirection later
///
class navBar extends StatefulWidget {
  const navBar({super.key});

  @override
  State<navBar> createState() => _MynavBar();
}

class _MynavBar extends State<navBar> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Homepage(),
    Goals_habit(iser: IsarService())
  ];

  navigate(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            color: const Color(0xFF000000), // unselected icon color
            activeColor:
                const Color(0xFFFFFFFF), // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor:
                const Color(0xFF66BF77), // selected tab background color
            padding: const EdgeInsets.all(16.0), // navigation bar padding
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'الرئسية',
              ),
              GButton(
                icon: LineIcons.check, //click here move me to a page
                text: 'عاداتي وأهدافي',
              ),
              GButton(
                icon: LineIcons.peopleCarry,
                text: 'مجتمعاتي',
              ),
              GButton(
                icon: LineIcons.book,
                text: 'مذكرتي',
              ),
            ],
            onTabChange: navigate,
          ),
        ),
      ),
    );
  }
}
