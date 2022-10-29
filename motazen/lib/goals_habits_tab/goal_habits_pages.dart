import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class goals_habit extends StatefulWidget {
  const goals_habit({super.key});

  @override
  State<goals_habit> createState() => _goals_habitState();
}

class _goals_habitState extends State<goals_habit> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Center(child: Text("أهدافي وعاداتي")),
                bottom: const TabBar(tabs: [
                     Tab(
                      text: "أهدافي",
                      icon: Icon(Icons.playlist_add_check,
                      )
                      
                    ), //Goals page
                     Tab(
                      text: "عاداتي",
                      icon: Icon(Icons.receipt_long),
                    ),  //habits page
                  ]),
              ),
              body: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children:  [
                  
                  const Expanded(
                    child: TabBarView(
                      children: [
                        //firstTap
                     Text("data"),
                     //second
                     Text("hello")
                  
                  
                    ]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
