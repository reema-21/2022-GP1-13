import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:provider/provider.dart';
import '../assesment_page/show.dart';
import '../../controllers/aspect_controller.dart';
import '../../theme.dart';

class AspectSelection extends StatefulWidget {
  final List<Aspect>? previousAspects;
  final bool? isRetake;
  const AspectSelection({super.key, this.previousAspects, this.isRetake});

  @override
  State<AspectSelection> createState() => _SelectAspectState();
}

class _SelectAspectState extends State<AspectSelection> {
  List<String> selectedAspects = [];
  List<String> unselectedAspects = [];

  @override
  void initState() {
    //clean lists
    selectedAspects.clear();
    unselectedAspects.clear();
    //list of all aspects
    for (var i = 0; i < widget.previousAspects!.length; i++) {
      if (widget.previousAspects![i].isSelected == true) {
        selectedAspects.add(widget.previousAspects![i].name);
      } else {
        unselectedAspects.add(widget.previousAspects![i].name);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);

    if (selectedAspects.isEmpty) {
      for (var i = 0; i < aspectList.allAspects.length; i++) {
        if (aspectList.allAspects[i].isSelected == true) {
          selectedAspects.add(aspectList.allAspects[i].name);
        } else {
          unselectedAspects.add(aspectList.allAspects[i].name);
        }
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
        onPressed: selectedAspects.isNotEmpty
            ? () {
//call a method that add the index to the local and go to assignment page .
                Get.to(() => AssessmentQuestionsList(
                      unselected: unselectedAspects,
                      selected: selectedAspects,
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
                                                  selectedAspects.contains(
                                                          aspectList
                                                              .allAspects[i]
                                                              .name)
                                                      ? Color(aspectList
                                                              .allAspects[i]
                                                              .color)
                                                          .withOpacity(0.8)
                                                      : kDisabled),
                                          elevation:
                                              MaterialStateProperty.all(10)),
                                      onPressed: () {
                                        //! remove this section if the code doesn't work
                                        //save unselected aspect name
                                        if (selectedAspects.contains(
                                            aspectList.allAspects[i].name)) {
                                          selectedAspects.remove(
                                              aspectList.allAspects[i].name);
                                        } else {
                                          selectedAspects.add(
                                              aspectList.allAspects[i].name);
                                        }

                                        //save unselected aspect name
                                        if (unselectedAspects.contains(
                                            aspectList.allAspects[i].name)) {
                                          unselectedAspects.remove(
                                              aspectList.allAspects[i].name);
                                        } else {
                                          unselectedAspects.add(
                                              aspectList.allAspects[i].name);
                                        }
                                        setState(() {});
                                      },
                                      child: ListTile(
                                        title: Text(
                                          aspectList.allAspects[i].name,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: selectedAspects.contains(
                                                      aspectList
                                                          .allAspects[i].name)
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
                                          color: selectedAspects.contains(
                                                  aspectList.allAspects[i].name)
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
