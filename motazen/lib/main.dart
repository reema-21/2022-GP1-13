import 'package:motazen/entities/aspect.dart';
import 'package:motazen/isar_service.dart';
import 'package:motazen/assesment_page/show.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // to inizlize the db
  IsarService iser = IsarService(); // inislize the local storage 
  
  iser.openIsar();
  Aspect x = Aspect(); 
  x.name= "Fun and Recreation";
  x.percentagePoints=0;
  Aspect y = Aspect();
  y.name="career";
  y.percentagePoints=0;
  iser.createAspect(x);
  iser.createAspect(y);
  runApp(MaterialApp(home: shows(iser: iser ))); // my widget // the one where i will create the quastion list .
}

