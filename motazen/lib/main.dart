import 'package:motazen/isar_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:motazen/select_aspectPage/fetch_all_aspects.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // to inizlize the db
  IsarService iser = IsarService(); // inislize the local storage 
  
  iser.openIsar();
  
  runApp(MaterialApp(home: fetchAspect(iser: iser ))); // my widget // the one where i will create the quastion list .
}

