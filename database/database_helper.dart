import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/timeline.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'timeline.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Timeline(
          Id INTEGER PRIMARY KEY,
          Name TEXT
      )
      ''');
  }

  Future<List<TimelineModel>> getGroceries() async {
    Database db = await instance.database;
    var timeline = await db.query('Timeline', orderBy: 'name');
    List<TimelineModel> timelineList = timeline.isNotEmpty
        ? timeline.map((c) => TimelineModel.fromMap(c)).toList()
        : [];
    return timelineList;
  }

  Future<int> add(TimelineModel timeline) async {
    Database db = await instance.database;
    return await db.insert('Timeline', timeline.toMap());
  }
}
