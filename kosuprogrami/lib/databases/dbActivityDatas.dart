import 'dart:async';
import 'package:path/path.dart';
import 'package:kosuprogrami/models/activities_model.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseProvider {
  String dbPath = "BasarsoftDB.db";
  final int _version = 1;
  late Database database;

  Future<void> open() async {
    database = await openDatabase(
      dbPath,
      version: _version,
      onCreate: (db, version) {
        createTable(db);
      },
    );
  }

  void createTable(Database db) async {
    await db.execute('''CREATE TABLE Activities( activitiesID int PRIMARY KEY 
        ,startLocLat DOUBLE,
        startLocLong DOUBLE,finalLocLat DOUBLE,
        finalLocLong DOUBLE,distance Double,
        stepCounter integer,weatherCelcius Double,weatherDescription TEXT,
        savedData DATETIME''');
  }

  Future<bool> insert(int id, Activities model) async {
    if (database != null) open();

    final activitiesMap = await database.insert("Activities", model.toJson());

    return activitiesMap != null;
  }

  Future<List<Activities>> getList() async {
    if (database != null) open();
    List<Map> activitiesMap = await database.query(
      "Activities",
    );
    return activitiesMap.map((e) => Activities.fromJson(e)).toList();
  }

  Future<Activities> getItem(int id) async {
    if (database != null) open();
    List<Map> activitiesMap = await database.query("Activities",
        where: 'activitiesID=?', columns: ['activitiesID'], whereArgs: [id]);
    return Activities.fromJson(activitiesMap.first);
  }

  Future<void> close() async {
    database.close();
  }
}
