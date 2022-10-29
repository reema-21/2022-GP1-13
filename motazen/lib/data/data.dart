import 'package:flutter/material.dart';
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

class WheelData with ChangeNotifier {
  List<Data> data = [];
  Future<void> copyList(List<Data> list) async {
    data = await list;
    notifyListeners();
  }
}
// class WheelData {
//   static List<Data> data = [
    // Data(
    //     name: 'career',
    //     points: 80,
    //     color: const Color(0xff0065A3),
    //     icon: const Icon(Icons.work)),
    // Data(
    //     name: 'relationships',
    //     points: 40,
    //     color: const Color(0xffff4949),
    //     icon: const Icon(Icons.work)),
    // Data(
    //     name: 'enviroment',
    //     points: 95,
    //     color: const Color(0xFF9E19F0),
    //     icon: const Icon(Icons.work)),
    // Data(
    //     name: 'finance',
    //     points: 50,
    //     color: const Color(0xff54e360),
    //     icon: const Icon(Icons.attach_money)),
    // Data(
    //     name: 'entertainment',
    //     points: 70,
    //     color: const Color(0xff008adf),
    //     icon: const Icon(Icons.games)),
    // Data(
    //     name: 'personal development',
    //     points: 80,
    //     color: const Color(0xFF2CDDCB),
    //     icon: const Icon(Icons.work)),
    // Data(
    //     name: 'health',
    //     points: 60,
    //     color: const Color(0xFFffd400),
    //     icon: const Icon(Icons.health_and_safety)),
    // Data(
    //     name: 'friends and family',
    //     points: 95,
    //     color: const Color(0xFFff9100),
  
