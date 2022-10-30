import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import "package:motazen/isar_service.dart";
import 'package:motazen/pages/homepage/homepage.dart';

import '../assesment_page/alert_dialog.dart';

class GoalListScreen extends StatefulWidget {
  final IsarService isr;
  const GoalListScreen({super.key, required this.isr});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: StreamBuilder<List<Goal>>(
      stream: IsarService().getAllGoals(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final goals = snapshot.data;
          if (goals!.isEmpty) {
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ليس لديك أهداف ",
                  style: TextStyle(color: Colors.black12, fontSize: 30),
                ),
                GestureDetector(
                  child: const Icon(Icons.add, color: Colors.black12, size: 30),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Homepage(); // must be the
                    }));
                  },
                )
              ],
            )); // here add a plust button to add
          }
          return ListView.builder(
            
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                final startData = goals[index].dueDate;
                return Container(
                  decoration:BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.only(bottom:4),
                  child: Card(
                    elevation: 3,
                    // here is the code of each item you have
                    child: ListTile(
                      
                      trailing:TextButton(child: Icon(Icons.delete ), onPressed: () async {
                        final action = await AlertDialogs.yesCancelDialog(
                      context,
                      ' هل انت متاكد من حذف هذا الهدف  ',
                'بالنقر على "تاكيد"لن تتمكن من استرجاع الهدف ا  ');
                  if (action == DialogsAction.yes) {
                    widget.isr.deleteGoal(goal);
                  } else {}





                      },),
                      tileColor: (index % 2 == 0) ? Colors.white :  Color.fromARGB(99, 102, 191, 118),
               leading: const Icon(Icons.heart_broken) ,
                      subtitle: Text("Due Date : $startData"), // if not null added 
                      title: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(goal.titel),
                      ),
                      iconColor: Colors.yellow,//switch then based on aspect .
                      contentPadding: EdgeInsets.all(7),
                      onTap:(){ // should return me to the page with add field 
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Homepage(); // must be the
                      }));
                      } ,

                      ),
                      
                  ),
                );
              });
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    )
    );
  }
}
