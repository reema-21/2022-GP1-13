// ignore_for_file: await_only_futures, camel_case_types

import 'package:flutter/material.dart';
import '../pages/select_aspectPage/select_aspect.dart';
import '/entities/aspect.dart';
import '/isar_service.dart';
import 'package:provider/provider.dart';
import '../pages/select_aspectPage/handle_aspect_data.dart';
import 'models.dart';

/// Fake data used to demo the application.
final fakeData = Todo(id: 'todo-tag-1', description: 'مهام اليوم', items: [
  Item(
    id: 'todo-1-item-1',
    description: 'اتصل علي أحمد',
    icon: const Icon(
      Icons.person,
      color: Color(0xFFff9100),
    ),
  ),
  Item(
    id: 'todo-1-item-2',
    description: 'حل الواجب',
    icon: const Icon(
      Icons.work,
      color: Color(0xff0065A3),
    ),
  ),
  Item(
    id: 'todo-1-item-3',
    description: 'ذاكر للإختبار',
    icon: const Icon(
      Icons.work,
      color: Color(0xff0065A3),
    ),
  ),
  Item(
    id: 'todo-1-item-4',
    description: 'انتهي من المشروع',
    icon: const Icon(
      Icons.work,
      color: Color(0xff0065A3),
    ),
  ),
  Item(
    id: 'todo-1-item-5',
    description: 'استثمر',
    icon: const Icon(
      Icons.attach_money,
      color: Color(0xff54e360),
    ),
  ),
  Item(
    id: 'todo-1-item-6',
    description: 'العب',
    icon: const Icon(
      Icons.games,
      color: Color(0xff008adf),
    ),
  ),
]);

////////////////////////////////////////Aspect Data\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

class WheelData with ChangeNotifier {
  List<Data> data = [
    //add friends and family aspect
    Data(name: 'Family and Friends', color: 4294938880, icon: Icons.person),
    //add Health and Wellbeing aspect
    Data(name: 'Health and Wellbeing', color: 4294956032, icon: Icons.spa),
    //add Personal Growth aspect
    Data(name: 'Personal Growth', color: 4281130443, icon: Icons.psychology),
    //add Physical Environment aspect
    Data(name: 'Physical Environment', color: 4288551408, icon: Icons.home),
    //add Significant Other aspect
    Data(name: 'Significant Other', color: 4294920521, icon: Icons.favorite),
    //add career aspect
    Data(name: 'career', color: 4278216099, icon: Icons.work),
    //add Fun and Recreation aspect
    Data(name: 'Fun and Recreation', color: 4278225631, icon: Icons.games),
    //add money and finances aspect
    Data(
        name: 'money and finances',
        color: 4283753312,
        icon: Icons.attach_money),
  ];
  final List<String> aspectsArabic = [
    'عائلتي و أصدقائي',
    'صحتي',
    'ذاتي',
    'بيئتي',
    'علاقاتي',
    'مهنتي',
    'متعتي',
    'أموالي'
  ];
  List<Aspect> allAspects = [];
  List<Aspect> selected = [];
  List<Aspect>? listWPoints = [];

  Future<void> copyDataList(List<Data> list) async {
    data = await list;
    notifyListeners();
  }

  Future<void> copyAspectList(List<Aspect>? list) async {
    listWPoints = await list;
    notifyListeners();
  }

  contains(String s) {
    for (var i = 0; i < data.length; i++) {
      if (data[i].name == s) {
        return true;
      } else {
        return false;
      }
    }
  }
}

class getAllAspects extends StatefulWidget {
  const getAllAspects({
    super.key,
  });

  @override
  State<getAllAspects> createState() => _getAllAspectsState();
}

class _getAllAspectsState extends State<getAllAspects> {
  final IsarService isar = IsarService();
  @override
  Widget build(BuildContext context) {
    var aspectList = Provider.of<WheelData>(context);
    //initialize aspects to DB
    return Scaffold(
      body: Center(
        child: FutureBuilder(
            future: Future.wait([
              handle_aspect().initializeAspects(aspectList.data),
              handle_aspect().getAspects(),
            ]),
            builder: ((context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                while (true) {
                  if (snapshot.data![0] == 1) {
                    aspectList.allAspects = snapshot.data![1];

                    return AspectSelection(
                      isr: isar,
                      aspects: aspectList.allAspects,
                    );
                  }
                }
              } else {
                return const CircularProgressIndicator();
              }
            })),
      ),
    );
  }
}
