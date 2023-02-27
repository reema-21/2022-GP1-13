import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motazen/pages/select_aspectPage/handle_aspect_data.dart';
import 'package:motazen/pages/settings/numberof_shown_task.dart';
import 'package:motazen/pages/settings/profile_edit.dart';
import 'package:motazen/primary_button.dart';

import '../../Sidebar_and_navigation/navigation-bar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const navBar(selectedIndex: 0)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
          title: const Text("الإعدادات"),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const navBar(selectedIndex: 0)));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 16, top: 25, right: 16),
          child: ListView(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.person,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "الحساب الشخصي",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                height: 15,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              buildAccountOptionRow(
                title: "تعديل الحساب الشخصي",
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfilePage()));
                },
              ),
              buildAccountOptionRow(
                title: "خانة احتياط",
                onClick: () {},
              ),
              const SizedBox(height: 40),
              Row(
                children: const [
                  Icon(
                    Icons.lightbulb_sharp,
                    color: Colors.green,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "ما يتعلق بالأداء",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(
                height: 15,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              buildAccountOptionRow(
                title: "إعادة التقييم",
                onClick: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.white,
                          content: SizedBox(
                              width: 150,
                              height: 150,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      const Text(
                                        "هل أنت متأكد من إعادة التقييم؟ بيانات جوانب الحياة سوف تحذف.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                      const SizedBox(height: 22),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: <Widget>[
                                          MaterialButton(
                                            color: Colors.red,
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      const initializeAspects()));
                                            },
                                            height: 45,
                                            minWidth: 70,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                            ),
                                            child: const Text(
                                              "نعم، متأكد",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          MaterialButton(
                                            color: Colors.green,
                                            onPressed: () {
                                              Navigator.of(context,
                                                  rootNavigator: true)
                                                  .pop();
                                            },
                                            height: 45,
                                            minWidth: 70,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(50),
                                            ),
                                            child: const Text(
                                              "لا، تراجع",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              )),
                        );
                      });
                },
              ),
              buildAccountOptionRow(
                title: "التحكم بعدد المهام المستعرضة",
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NumberOfShownTaskPage()));
                },
              ),
              // const SizedBox(height: 50),
              // const Center(
              //   child: PrimaryButton(buttonText: 'sign out'),
              // ),
              // const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              onChanged: (bool val) {},
            ))
      ],
    );
  }
}

class buildAccountOptionRow extends StatefulWidget {
  const buildAccountOptionRow({super.key, this.title, this.onClick});
  final title;
  final onClick;

  @override
  State<buildAccountOptionRow> createState() => _buildAccountOptionRowState();
}

class _buildAccountOptionRowState extends State<buildAccountOptionRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return AlertDialog(
        //         title: Text(title),
        //         content: Column(
        //           mainAxisSize: MainAxisSize.min,
        //           children: [
        //             Text("Option 1"),
        //             Text("Option 2"),
        //             Text("Option 3"),
        //           ],
        //         ),
        //         actions: [
        //           ElevatedButton(
        //               onPressed: () {
        //                 Navigator.of(context).pop();
        //               },
        //               child: Text("Close")),
        //         ],
        //       );
        //     });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}





// //---------------------------------------------
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       /// appbar
//       appBar: AppBar(
//         backgroundColor: kPrimaryColor,
//         elevation: 0.0,
//         centerTitle: false,
//         automaticallyImplyLeading: false,
//         leadingWidth: 0.0,
//         title: const Text(
//           'الإعدادات',
//           style: TextStyle(
//             color: kWhiteColor,
//             fontSize: 26,
//           ),
//         ),
//       ),
//
//       /// body
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           const SizedBox(height: 10),
//           ListTile(
//             leading: const Icon(Icons.edit),
//             title: const Text('إعادة التقييم'),
//             onTap: () => Get.to(() => const initializeAspects()),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// //-------------------------------------------------------------
// class SettingsPage extends StatefulWidget {
//   @override
//   _SettingsPageState createState() => _SettingsPageState();
// }
//
// class _SettingsPageState extends State<SettingsPage> {
//   @override
