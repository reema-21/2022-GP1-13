import 'package:datatry/isar_service.dart';
import 'package:isar/isar.dart';//for local Storage
import 'dart:io';//for the directory
import 'package:path_provider/path_provider.dart';
import 'package:isar/isar.dart' ;
import 'package:flutter/material.dart';

Future main() async {
 
  WidgetsFlutterBinding.ensureInitialized(); // to inizlize the db
  Directory doc = await getApplicationDocumentsDirectory();
  IsarService iser = IsarService();
  iser.openIsar(); 
  }