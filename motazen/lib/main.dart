import 'package:motazen/isar_service.dart';
import 'package:motazen/show.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'assesmentQuestionPageGlobals.dart'; // for the global varible
import "package:motazen/QuastoinAssesment.dart";
import 'show.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // to inizlize the db
  IsarService iser = IsarService();
  
  iser.openIsar();
  runApp(MaterialApp(home: shows(iser: iser ))); // my widget
}

