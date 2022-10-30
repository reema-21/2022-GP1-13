import 'package:flutter/material.dart';
import 'package:motazen/entities/habit.dart';
import"package:motazen/isar_service.dart";

import '../pages/homepage/homepage.dart';

class HabitListScreen extends StatefulWidget {
  final IsarService isr;
  const HabitListScreen({super.key, required this.isr});

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(child: StreamBuilder<List<Habit>>(
      stream: IsarService().getAllHabits(),
      builder:(context, snapshot) {
        if(snapshot.hasData){
          final habits = snapshot.data;
          if(habits!.isEmpty){
            return Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "ليس لديك عادات ",
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
            itemCount: habits.length,
            itemBuilder:(context, index) {
              final habit = habits[index];
              return Card( // here is the code of each item you have 
child: ListTile(
  title: Text(habit.titel)),
              );
              
            });
          
        }
        else{
          return const Center(child: CircularProgressIndicator(),);
        }
      }, ));
}}