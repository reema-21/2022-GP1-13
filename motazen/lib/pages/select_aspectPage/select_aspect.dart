// ignore_for_file: camel_case_types, iterable_contains_unrelated_type, list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assesment_page/show.dart';
import '../assesment_page/alert_dialog.dart';
import 'handle_aspect_data.dart';
import '/isar_service.dart';
import '../../data/data.dart';
import '../../theme.dart';

class AspectSelection extends StatefulWidget {
  final IsarService isr;
  final List<dynamic>? aspects;
  const AspectSelection({super.key, required this.isr, this.aspects});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  final List<bool> __isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<String> selectedAspects = [];
  @override
  Widget build(BuildContext context) {
    //list of all aspects
    var aspectList = Provider.of<WheelData>(context);

    Widget doneButton(IsarService isar) {
      return ElevatedButton(
        onPressed: __isSelected.contains(true)
            ? () {
//call a method that add the index to the local and go to assignment page .
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AssessmentQuestionsList(
                        iser: widget.isr,
                        fixedAspect: widget.aspects,
                        chosenAspect: selectedAspects);
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
          toolbarHeight: 86,
          automaticallyImplyLeading: false,
          title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'هل أنت مستعد لإنشاء عجلة الحياة الخاصة بك ؟',
                  textDirection: TextDirection.rtl,
                  style: titleText2,
                ),
                Text("اختر الجوانب اللي تريد اضافتها للعجلة", style: subTitle),
              ]),
          backgroundColor: kWhiteColor,
          iconTheme: const IconThemeData(color: kBlackColor),
          elevation: 0.0,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              //align the aspect buttons
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                      height: size.height - (size.height / 3),
                      width: size.width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 35,
                              runSpacing: 40,
                              children: List<Widget>.generate(
                                  8,
                                  (int i) => TextButton(
                                      style: ButtonStyle(
                                          splashFactory: NoSplash.splashFactory,
                                          fixedSize: MaterialStateProperty.all(
                                              const Size(150, 90)),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  __isSelected[i]
                                                      ? Color(aspectList
                                                              .data[i].color)
                                                          .withOpacity(0.8)
                                                      : kDisabled),
                                          elevation:
                                              MaterialStateProperty.all(10)),
                                      onPressed: () {
                                        setState(() {
                                          //update status in local storage
                                          handle_aspect().updateStatus(
                                              aspectList.data[i].name);
                                          //change selected value
                                          __isSelected[i]
                                              ? __isSelected[i] = false
                                              : __isSelected[i] = true;
                                          //save selected aspect name
                                          __isSelected[i]
                                              ? selectedAspects
                                                  .add(aspectList.data[i].name)
                                              : selectedAspects.remove(
                                                  aspectList.data[i].name);
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          aspectList.aspectsArabic[i],
                                          style: TextStyle(
                                              fontFamily: 'Frutiger',
                                              fontSize: 15,
                                              color: __isSelected[i]
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
                                                .allAspects[i].iconFontPackage,
                                            matchTextDirection: aspectList
                                                .allAspects[i].iconDirection,
                                          ),
                                          color: __isSelected[i]
                                              ? kWhiteColor
                                              : kDarkGreyColor,
                                          size: 27,
                                        ),
                                      )),
                                  growable: false),
                            ),
                          ]))),
              Container(
                color: kWhiteColor.withOpacity(0),
                margin:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
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
