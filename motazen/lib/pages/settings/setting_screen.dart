import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:motazen/controllers/aspect_controller.dart';
import 'package:motazen/pages/select_aspectPage/handle_aspect_data.dart';
import 'package:motazen/pages/settings/numberof_shown_task.dart';
import 'package:motazen/pages/settings/profile_edit.dart';
import 'package:provider/provider.dart';
import '../../Sidebar_and_navigation/navigation_bar.dart';

//REEMAS
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> aspectNames =
        Provider.of<AspectController>(context).getSelectedNames();
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => NavBar(
                      selectedIndex: 0,
                      selectedNames: aspectNames,
                    )));
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
                      builder: (context) => NavBar(
                          selectedIndex: 0, selectedNames: aspectNames)));
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
              const Row(
                children: [
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
              BuildAccountOptionRow(
                title: "تعديل الحساب الشخصي",
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()));
                },
              ),
              const SizedBox(height: 40),
              const Row(
                children: [
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
              BuildAccountOptionRow(
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
                                                          const InitializeAspects(
                                                            isRetake: true,
                                                          )));
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
              BuildAccountOptionRow(
                title: "التحكم بعدد المهام المستعرضة",
                onClick: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NumberOfShownTaskPage()));
                },
              ),
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

class BuildAccountOptionRow extends StatefulWidget {
  const BuildAccountOptionRow({super.key, required this.title, this.onClick});
  final String title;
  final dynamic onClick;

  @override
  State<BuildAccountOptionRow> createState() => _BuildAccountOptionRowState();
}

class _BuildAccountOptionRowState extends State<BuildAccountOptionRow> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onClick();
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
