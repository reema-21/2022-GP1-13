// ignore_for_file: camel_case_types, iterable_contains_unrelated_type, list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assesment_page/show.dart';
import 'handle_aspect_data.dart';
import '/isar_service.dart';
import '../../data/data.dart';
import '../../theme.dart';

class AspectSelection extends StatefulWidget {
  final IsarService isr;
  const AspectSelection({super.key, required this.isr});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  //use the local storge att instead
  final List<bool> __isSelected = [];
  List<String> selectedAspects = [];
  @override
  Widget build(BuildContext context) {
    //list of all aspects
    var aspectList = Provider.of<WheelData>(context);
    for (var i = 0; i < aspectList.allAspects.length; i++) {
      __isSelected.add(aspectList.allAspects[i].isSelected);
      if (aspectList.allAspects[i].isSelected == true) {
        selectedAspects.add(aspectList.allAspects[i].name);
      }
    }

    Widget doneButton(IsarService isar) {
      return ElevatedButton(
        ///add style
        onPressed: __isSelected.contains(true)
            ? () {
//call a method that add the index to the local and go to assignment page .
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AssessmentQuestionsList(
                        iser: widget.isr, chosenAspect: selectedAspects);
                  },
                ));
              }
            : null,
        child: const Text("التالي"),
      );
    }

    Size size = MediaQuery.of(context).size;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: AppBar(
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'هل أنت مستعد ؟',
                  textDirection: TextDirection.rtl,
                  style: titleText,
                ),
                Text("اختر الجوانب اللي تريد اضافتها للعجلة", style: subTitle),
              ]),
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: kBlackColor),
          elevation: 0.0,
          toolbarHeight: 86,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              //align the aspect buttons
              Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: size.height - (size.height / 3),
                      width: size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SingleChildScrollView(
                              child: Wrap(
                                spacing: 40,
                                runSpacing: 55,
                                children: List<Widget>.generate(
                                    8,
                                    (int i) => TextButton(
                                        style: ButtonStyle(
                                            splashFactory:
                                                NoSplash.splashFactory,
                                            fixedSize:
                                                MaterialStateProperty.all(
                                                    const Size(150, 90)),
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    aspectList.allAspects[i]
                                                            .isSelected
                                                        ? Color(aspectList
                                                                .allAspects[i]
                                                                .color)
                                                            .withOpacity(0.8)
                                                        : kDisabled),
                                            elevation:
                                                MaterialStateProperty.all(10)),
                                        onPressed: () {
                                          setState(() {
                                            //update status in local storage
                                            handle_aspect().updateStatus(
                                                aspectList.allAspects[i].name);
                                            //change selected value
                                            aspectList.allAspects[i].isSelected
                                                ? aspectList.allAspects[i]
                                                    .isSelected = false
                                                : aspectList.allAspects[i]
                                                    .isSelected = true;
                                            //save selected aspect name
                                            aspectList.allAspects[i].isSelected
                                                ? selectedAspects.add(aspectList
                                                    .allAspects[i].name)
                                                : selectedAspects.remove(
                                                    aspectList
                                                        .allAspects[i].name);
                                          });
                                        },
                                        child: ListTile(
                                          title: Text(
                                            aspectList.aspectsArabic[i],
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: aspectList.allAspects[i]
                                                        .isSelected
                                                    ? kWhiteColor
                                                    : kBlackColor),
                                          ),
                                          trailing: Icon(
                                            IconData(
                                              aspectList
                                                  .allAspects[i].iconCodePoint,
                                              fontFamily: aspectList
                                                  .allAspects[i].iconFontFamily,
                                              fontPackage: aspectList
                                                  .allAspects[i]
                                                  .iconFontPackage,
                                              matchTextDirection: aspectList
                                                  .allAspects[i].iconDirection,
                                            ),
                                            color: aspectList
                                                    .allAspects[i].isSelected
                                                ? kWhiteColor
                                                : kDarkGreyColor,
                                            size: 27,
                                          ),
                                        )),
                                    growable: false),
                              ),
                            ),
                          ]))),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: doneButton(widget.isr),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
