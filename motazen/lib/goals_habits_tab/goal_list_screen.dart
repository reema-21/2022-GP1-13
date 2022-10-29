import 'package:flutter/material.dart';
import 'package:motazen/entities/goal.dart';
import"package:motazen/isar_service.dart";

class GoalListScreen extends StatefulWidget {
  final IsarService isr;
  const GoalListScreen({super.key, required this.isr});

  @override
  State<GoalListScreen> createState() => _GoalListScreenState();
}

class _GoalListScreenState extends State<GoalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: StreamBuilder<List<Goal>>(
      stream: IsarService().getAllGoals(),
      builder:(context, snapshot) {
        if(snapshot.hasData){
          final goals = snapshot.data;
          if(goals!.isEmpty){
            return const Center(child: Text("no goals "),); // here add a plust button to add
          }
          return ListView.builder(
            itemCount: goals.length,
            itemBuilder:(context, index) {
              final goal = goals[index];
              return Card( // here is the code of each item you have 
child: ListTile(
  title: Text(goal.titel)),
              );
              
            });
          
        }
        else{
          return const Center(child: CircularProgressIndicator(),)
        }
      }, ));
}}