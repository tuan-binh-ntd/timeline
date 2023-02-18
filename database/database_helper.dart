import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;
  //Future<Database> get database async => _database ??= await _initDatabase();

  // Future<Database> _initDatabase() async {
  //   Directory documentsDirectory = await getApplicationDocumentDirectory();
  //   String path = join(documentsDirectory.path, 'timeline.db');
  //   return await openDatabase(path,version: 1,onCreate: _onCreate)
  // }
}
