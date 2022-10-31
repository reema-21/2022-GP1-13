import 'package:flutter/material.dart';
import 'package:motazen/isar_service.dart';
import '../assesment_page/alert_dialog.dart';
import 'package:date_field/date_field.dart';

import '../Sidebar_and_navigation/navigation-bar.dart';
import '../Sidebar_and_navigation/sidebar.dart';

class AddGoal extends StatefulWidget {
  final IsarService isr;
  final List<String>? chosenAspectNames;
<<<<<<< Updated upstream
  const AddGoal(
      {super.key,
      required this.isr,
      this.chosenAspectNames,
      required List aspects});
=======
  const AddGoal({super.key, required this.isr, this.chosenAspectNames});
>>>>>>> Stashed changes

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  late String _goalName;
   DateTime? selectedDate;
  
  final _goalNmaeController = TextEditingController();
  final _dueDateController = TextEditingController();

  String? isSelected = "";
  @override
  void initState() {
isSelected = widget.chosenAspectNames?[0];
    // TODO: implement initState
    super.initState();
    _goalNmaeController.addListener(_updateText);
    _dueDateController.addListener(_updateText);

  }

 

  void _updateText() {
    setState(() {
      _goalName = _goalNmaeController.text;
      
    });
  }

  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 30.0,
          // notifications button
          backgroundColor: const Color(0xFFffffff),
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0.0,
          leading: const IconButton(
              onPressed: null,
              icon: Icon(
                Icons.notifications,
                color: Colors.black,
              ),
              tooltip: 'View Requests'),
        ),
        endDrawer: const NavBar(),
        body: SafeArea(
          child: Container(),

          ///add your code here
        ),
        bottomNavigationBar: const navBar(),
=======
    // ignore: prefer_const_constructors
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text(
              "إضافة هدف جديد",
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                  // ignore: prefer_const_constructors
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                  onPressed: () async {
                    final action = await AlertDialogs.yesCancelDialog(
                        context,
                        ' هل انت متاكد من الرجوع ',
                        'بالنقر على "تاكيد"لن يتم حفظ جوانب الحياة التي قمت باختيارها  ');
                    if (action == DialogsAction.yes) {
                      //return to the previouse page different code for the ios .
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {return homePag();}));
                    } else {}
                  }),
            ],
          ),
          body: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: ListView(children: [
                  TextFormField(
                    controller: _goalNmaeController, //take out the goal name //you might need to make sure it is eneterd before add and ot contian chracter.
                    decoration: const InputDecoration(
                      labelText: "اسم الهدف",
                      prefixIcon: Icon(Icons.verified_user_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height:30,),
/// Aspect selectio 

        DropdownButtonFormField(

          value: isSelected,
          items: widget.chosenAspectNames?.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),

         onChanged: (val){
          setState(() {
            isSelected=val as String;
          });
         },
         icon: const Icon(Icons.arrow_drop_down_circle,
         color: Colors.black,),
         decoration: InputDecoration(
          labelText: "جوانب الحياة ",
          prefixIcon: Icon(Icons.pie_chart,color: Colors.black,),
       border: UnderlineInputBorder( ),
         ),
        ),
        SizedBox(height:25,),
//due date .
  DateTimeFormField( //make it with time write now there is a way for only date 
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.black45),
                    errorStyle: TextStyle(color: Colors.redAccent),
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.event_note),
                    labelText: 'تاريخ الاستحقاق',
                  ),
                  firstDate: DateTime.now().add(const Duration(days:1)),
                  lastDate: DateTime.now().add(const Duration(days:360)), //oneYear
                  initialDate: DateTime.now().add(const Duration(days: 20)),
                  autovalidateMode: AutovalidateMode.always,
                  // validator: (DateTime? e) =>
                  //     (e?.day ?? 0) == 2 ? 'Please not the first day' : null,
                  onDateSelected: (DateTime value) {
                    print(value);
                  },
                ),
         
            ],
          ),
              ),
            ]),
          bottomSheet: TextButton(child: const Text("إضافة"), onPressed: () {}),
        ),
>>>>>>> Stashed changes
      ),
    );
  }
}
