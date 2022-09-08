import 'dart:async';
import 'package:path/path.dart';
import 'package:kosuprogrami/models/activities_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class UserDatabaseProvider {
  final int _version = 1;
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database = await initDb();

    _database = await initDb();

    return _database;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Basarsoft.db");
    return await openDatabase(path, onCreate: _onCreate, version: _version);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Activities( 
      activitiesID int autoincremented ,
      userToken TEXT,
      startLocLat REAL,
      startLocLong REAL,finalLocLat REAL,
      finalLocLong REAL,distance REAL,
      stepCounter integer,
      weatherCelcius REAL,
      weatherDescription TEXT,
      polylinePoints TEXT)''');
  }

  Future<int> insertActivities(Activities model) async {
    var dbClient = await database;
    return await dbClient!.insert(
      "Activities",
      model.toJson(),
    );
  }
  // Future<void> open() async {
  //   var dbPath = await getDatabasesPath();
  //   String path = join(dbPath, 'basarsoft.db');
  //   database =
  //       await openDatabase(path, version: _version, onCreate: (db, version) {
  //     createTable(db, _version);
  //   }, onUpgrade: ((db, oldVersion, newVersion) => {}));
  // }

  // void createTable(Database db, int version) async {
  //   await db.execute('''CREATE TABLE Activities( activitiesID int PRIMARY ,
  //       startLocLat REAL,userToken TEXT,
  //       startLocLong REAL,finalLocLat REAL,
  //       finalLocLong REAL,distance REAL,polylinePoints TEXT,
  //       stepCounter integer,weatherCelcius REAL,weatherDescription TEXT,
  //       savedData TEXT''');
  // }

  // Future<bool> insert(model) async {
  //   if (database != null) await open();

  //   final activitiesMap = await database!.insert("Activities", model);

  //   return activitiesMap != null;
  // }

  // Future<List<Activities>> getList() async {
  //   if (database != null) open();
  //   List<Map> activitiesMap = await database!.query(
  //     "Activities",
  //   );
  //   return activitiesMap.map((e) => Activities.fromJson(e)).toList();
  // }

  // Future<Activities> getItem(int id) async {
  //   if (database != null) open();
  //   List<Map> activitiesMap = await database!.query("Activities",
  //       where: 'activitiesID=?', columns: ['activitiesID'], whereArgs: [id]);
  //   return Activities.fromJson(activitiesMap.first);
  // }

  // Future<void> close() async {
  //   database!.close();
  // }
}
