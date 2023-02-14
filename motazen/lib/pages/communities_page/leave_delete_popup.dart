// ignore_for_file: list_remove_unrelated_type
//new
import 'package:flutter/material.dart';

import '../../theme.dart';

shouldLeave(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          content: Container(
            height: screenHeight(context) * 0.2,
            width: screenWidth(context) * 0.7,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'Leave',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'Cancel',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            }),
          ),
        );
      });
}

shouldDelete(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          scrollable: true,
          content: Container(
            height: screenHeight(context) * 0.2,
            width: screenWidth(context) * 0.7,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
            child: StatefulBuilder(builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'Delete',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: screenHeight(context) * 0.05,
                                width: screenWidth(context) * 0.2,
                                decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: txt(
                                        txt: 'Cancel',
                                        fontSize: 16,
                                        fontColor: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
              );
            }),
          ),
        );
      });
}
