// ignore_for_file: file_names
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

///add page redirection later
Widget navBar = Container(
  decoration: BoxDecoration(
    color: Colors.white,
    border: Border(
      top: BorderSide(width: 0.5, color: Colors.grey.shade300),
    ),
  ),
  child: const Padding(
    padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
    child: GNav(
        gap: 8, // the tab button gap between icon and text
        color: Color(0xFF000000), // unselected icon color
        activeColor: Color(0xFFFFFFFF), // selected icon and text color
        iconSize: 24, // tab button icon size
        tabBackgroundColor: Color(0xFF66BF77), // selected tab background color
        padding: EdgeInsets.all(16.0), // navigation bar padding
        tabs: [
          GButton(
            icon: LineIcons.book,
            text: 'مذكرتي',
          ),
          GButton(
            icon: LineIcons.peopleCarry,
            text: 'مجتمعاتي',

          ),
          GButton(
            icon: LineIcons.check, //click here move me to a page 
            text: 'عاداتي وأهدافي',
          ),
          GButton(
            icon: LineIcons.home,
            text: 'الرئسية',
          )
        ]),
        
  ),
);
