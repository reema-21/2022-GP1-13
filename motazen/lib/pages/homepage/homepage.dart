import 'package:flutter/material.dart';
import '/pages/homepage/wheel_of_life/pie_chart_page.dart';
import '/Sidebar_and_navigation/navigation-bar.dart';
import '/Sidebar_and_navigation/sidebar.dart';
import '/data/data.dart';
import '/pages/homepage/daily_tasks/display_list.dart';

// import 'homepage/wheel_of_life/render-chart.dart'; file accidentally deleted add later
// how is it implemented
class Homepage extends StatefulWidget {
  const Homepage({super.key});
  @override
  State<Homepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<Homepage> {
//progress Widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //displays the visualization (wheel of life)
            Stack(
              children: [
                Positioned(
                  top: -55.8,
                  left: 20,
                  child: Container(
                    margin: const EdgeInsets.all(0.0),
                    width: 350,
                    height: 500,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage('assets/images/wheelHome.png'),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                const life_wheel(),
              ],
            ),
            // displays the daily tasks list
            Flexible(
              child: Center(
                child: TodoCard(
                  todo: fakeData,
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: navBar,
    );
  }
}
