import 'dart:async';
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
          StartTime TEXT,
          FinishTime TEXT
      )
      ''');
  }

  Future<List<TimelineModel>> getTimelineList() async {
    Database db = await instance.database;
    var timeline = await db.rawQuery(
        "SELECT id, startTime, finishTime, ROUND((JULIANDAY(FinishTime) - JULIANDAY(StartTime)) * 86400) AS Time FROM Timeline ORDER BY Id DESC;");
    List<TimelineModel> timelineList = timeline.isNotEmpty
        ? timeline.map((c) => TimelineModel.fromMap(c)).toList()
        : [];
    return timelineList;
  }

  Future<int> add(TimelineModel timeline) async {
    Database db = await instance.database;
    return await db.rawInsert(
        "INSERT INTO Timeline(StartTime, FinishTime) VALUES (?, ?)",
        [timeline.startTime, null]);
  }

  Future<int> edit(TimelineModel timeline) async {
    Database db = await instance.database;
    return await db.rawUpdate(
        "UPDATE Timeline SET FinishTime = ? WHERE Id = (SELECT Id FROM Timeline ORDER BY Id DESC LIMIT 1)",
        [timeline.finishTime]);
  }

  Future<int> remove() async {
    Database db = await instance.database;
    return await db.rawDelete(
        "DELETE FROM Timeline WHERE Id = (SELECT Id FROM Timeline ORDER BY Id DESC LIMIT 1)");
  }

  Future<double> timeTotal() async {
    Database db = await instance.database;
    List<Map> timeline = await db.rawQuery(
        "SELECT SUM( ROUND( ( JULIANDAY(FinishTime) - JULIANDAY(StartTime) ) * 86400) ) AS time FROM Timeline;");
    return (timeline[0]['time'] as double);
  }

  Future<bool> checkDisableAddButton() async {
    Database db = await instance.database;
    List<Map> result = await db
        .rawQuery("SELECT StartTime FROM Timeline ORDER BY Id DESC LIMIT 1");
    if (result.length == 0) {
      await add(TimelineModel(startTime: DateTime.now().toIso8601String()));
      return true;
    }
    bool disable = result[0]['StartTime'].toString().substring(0, 10) ==
        DateTime.now().toIso8601String().substring(0, 10);
    return disable;
  }

  String formatedTime({double timeInSecond}) {
    int time = timeInSecond.round();
    int sec = time % 60;
    int hour = time ~/ 60;
    int minute = hour % 60;
    hour = hour ~/ 60;
    return "$hour:$minute:$sec";
  }

  Future<String> checkRemaningTime() async {
    // 192 hours
    int baseTime = 691200;
    double time = await timeTotal();
    int remainingTime = baseTime - time.round();
    DateTime now = DateTime.now();
    int lastDayInMonth = DateTime(now.year, now.month + 1, 0).day;
    int remainingDay = lastDayInMonth - now.day;
    String timePerDay =
        formatedTime(timeInSecond: (remainingTime / remainingDay)) +
            " giờ/$remainingDay ngày";
    return timePerDay;
  }
}
