import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:motazen/Sidebar_and_navigation/navigation-bar.dart';
import 'package:motazen/pages/settings/tasklist_variables.dart';
import 'package:motazen/primary_button.dart';
import 'package:motazen/theme.dart';

class NumberOfShownTaskPage extends StatefulWidget {
  const NumberOfShownTaskPage({super.key});

  @override
  State<NumberOfShownTaskPage> createState() => _NumberOfShownTaskPageState();
}

class _NumberOfShownTaskPageState extends State<NumberOfShownTaskPage> {
  int taskToShow = defaultTasklist ? totalTaskNumbers : toShowTaskNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text('عدد المهام المستعرضة'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 230, 255, 224),
          image: DecorationImage(
            image: AssetImage("assets/images/shownTaskBG.png"),
            fit: BoxFit.fill,
          ),
        ),
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 260,
                      width: 260,
                      decoration: const BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(150))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'مهام',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const Text(
                            ' / ',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '${defaultTasklist ? totalTaskNumbers : toShowTaskNumber}',
                            style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                    width: MediaQuery.of(context).size.width / 1.25,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: const [
                                Text(
                                  ':',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Text('التحكم بعدد المهام المستعرضة في القائمة:',
                                    style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (taskToShow < totalTaskNumbers) {
                                        taskToShow++;
                                      } else if (totalTaskNumbers == 0) {
                                        Fluttertoast.showToast(
                                            msg: "لا يوجد أي مهمة حاليًا",
                                            toastLength: Toast.LENGTH_LONG);
                                      }
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: kPrimaryColor),
                                    child: Text(
                                      '+',
                                      style: textButton.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width:
                                  MediaQuery.of(context).size.width / 2.8,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.grey, width: 4),
                                      color: Colors.white),
                                  child: Text(
                                    '$taskToShow',
                                    style: textButton.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (taskToShow != 0) taskToShow--;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: kPrimaryColor),
                                    child: Text(
                                      '-',
                                      style: textButton.copyWith(
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 30),
                            child: InkWell(
                              onTap: () {
                                if (toShowTaskNumber != taskToShow) {
                                  setState(() {
                                    toShowTaskNumber = taskToShow;
                                    defaultTasklist = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: "تم العملية بنجاح",
                                      toastLength: Toast.LENGTH_LONG);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const navBar(selectedIndex: 0)));
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                      "للتغيير عليك بإدخال قيمة",
                                      toastLength: Toast.LENGTH_LONG);
                                }
                              },
                              child: const PrimaryButton(buttonText: "حفظ التغييرات"),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
