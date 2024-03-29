import 'package:motazen/Sidebar_and_navigation/navigation_bar.dart';
import 'package:motazen/controllers/item_list_controller.dart';
import 'package:motazen/entities/aspect.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../isar_service.dart';
import '../../controllers/aspect_controller.dart';

class GetChosenAspect extends StatefulWidget {
  const GetChosenAspect({Key? key}) : super(key: key);

  @override
  State<GetChosenAspect> createState() => _ShowsState();
}

class _ShowsState extends State<GetChosenAspect> {
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<AspectController>(context);
    final tasklist = Provider.of<ItemListProvider>(context);

    return Scaffold(
      body: Center(
        child: FutureBuilder<List<Aspect>>(
          future: IsarService().getSelectedAspects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              aspectList.updateSelectedList(snapshot.data!);
              return FutureBuilder(
                future: tasklist.createTaskTodoList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return NavBar(
                      selectedIndex: 0,
                      selectedNames: aspectList.getSelectedNames(),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
