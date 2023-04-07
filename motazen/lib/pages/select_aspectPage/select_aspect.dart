// ignore_for_file: camel_case_types, iterable_contains_unrelated_type, list_remove_unrelated_type

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/isar_service.dart';
import 'package:provider/provider.dart';
import '../assesment_page/show.dart';
import 'handle_aspect_data.dart';
import '../../controllers/aspect_controller.dart';
import '../../theme.dart';

class AspectSelection extends StatefulWidget {
  final bool? isRetake;
  const AspectSelection({super.key, this.isRetake});

  @override
  State<AspectSelection> createState() => _selectAspectState();
}

class _selectAspectState extends State<AspectSelection> {
  //use the local storge att instead
  final List<bool> __isSelected = [];
  List<String> selectedAspects = [];
  List<String> unselectedAspects = [];

  @override
  Widget build(BuildContext context) {
    //clean lists
    __isSelected.clear();
    selectedAspects.clear();
    unselectedAspects.clear();
    //list of all aspects
    var aspectList = Provider.of<AspectController>(context);
    for (var i = 0; i < aspectList.allAspects.length; i++) {
      __isSelected.add(aspectList.allAspects[i].isSelected);
      if (aspectList.allAspects[i].isSelected == true) {
        selectedAspects.add(aspectList.allAspects[i].name);
      } else {
        unselectedAspects.add(aspectList.allAspects[i].name);
      }
    }

    Widget doneButton(IsarService isar) {
      return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).colorScheme.primary.withOpacity(0.4);
              } else if (states.contains(MaterialState.disabled)) {
                return kDisabled;
              }
              return kPrimaryColor;
            },
          ),
          padding: const MaterialStatePropertyAll<EdgeInsetsGeometry>(
              kDefaultPadding),
          textStyle: const MaterialStatePropertyAll<TextStyle>(TextStyle(
            color: kPrimaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Frutiger',
          )),
        ),
        onPressed: __isSelected.contains(true)
            ? () {
//call a method that add the index to the local and go to assignment page .
                Get.to(() => AssessmentQuestionsList(
                      unselected: unselectedAspects,
                    ));
              }
            : null,
        child: const Text("التالي"),
      );
    }

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        leading: widget.isRetake == true
            ? Builder(
                builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ));
                },
              )
            : null,
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'هل أنت مستعد ؟',
                style: titleText,
              ),
              Text("اختر الجوانب اللي تريد اضافتها للعجلة", style: subTitle),
            ]),
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
                              spacing: 45,
                              runSpacing: 65,
                              children: List<Widget>.generate(
                                  8,
                                  (int i) => TextButton(
                                      style: ButtonStyle(
                                          splashFactory: NoSplash.splashFactory,
                                          fixedSize: MaterialStateProperty.all(
                                              Size((size.width * 0.4),
                                                  (size.height * 0.1))),
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
                                              ? selectedAspects.add(
                                                  aspectList.allAspects[i].name)
                                              : selectedAspects.remove(
                                                  aspectList
                                                      .allAspects[i].name);
                                          //save unselected aspect name
                                          aspectList.allAspects[i].isSelected
                                              ? unselectedAspects.remove(
                                                  aspectList.allAspects[i].name)
                                              : unselectedAspects.add(aspectList
                                                  .allAspects[i].name);
                                        });
                                      },
                                      child: ListTile(
                                        title: Text(
                                          aspectList.allAspects[i].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: aspectList
                                                      .allAspects[i].isSelected
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
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: doneButton(IsarService()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
