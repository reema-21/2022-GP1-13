import 'package:motazen/Sidebar_and_navigation/navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../isar_service.dart';
import '../../controllers/aspect_controller.dart';

class GetChosenAspect extends StatefulWidget {
  const GetChosenAspect({
    super.key,
  });

  @override
  State<GetChosenAspect> createState() => _ShowsState();
}

class _ShowsState extends State<GetChosenAspect> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: IsarService().getSelectedAspects(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              //a list of selected aspects
              aspectList.updateSelectedList(snapshot.data!);
              return const NavBar(
                selectedIndex: 0,
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
        ),
      ),
    );
  }
}
