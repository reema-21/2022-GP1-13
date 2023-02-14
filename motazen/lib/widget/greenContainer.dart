// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../theme.dart';

Container greenTextContainer(BuildContext context,
    {required String text, required bool isSelected, double? width}) {
  return Container(
    width: width ?? screenWidth(context) * 0.4,
    height: screenHeight(context) * 0.04,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      color: isSelected ? kPrimaryColor : kPrimaryColor.withOpacity(0.5),
    ),
    child: Center(child: txt(txt: text, fontSize: 12, fontColor: Colors.white)),
  );
}
