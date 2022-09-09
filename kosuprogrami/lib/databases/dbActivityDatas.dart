import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:kosuprogrami/models/activities_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class UserDatabaseProvider extends ChangeNotifier {
  final int _version = 1;
  static Database? _database;

  String userToken = "userToken";
  String startLocLat = "startLocLat";
  String startLocLong = "startLocLong";
  String finalLocLat = "finalLocLat";
  String finalLocLong = "finalLocLong";
  String distance = "distance";
  String stepCounter = "stepCounter";
  String weatherCelcius = "weatherCelcius";
  String weatherDescription = "weatherDescription";
  String savedTime = "savedTime";
  List<Activities> get items => [];
  Future<Database?> get database async {
    if (_database != null) return _database = await initDb();

    _database = await initDb();

    return _database;
  }

  initDb() async {
    var dbFolder = await getDatabasesPath();
    String path = join(dbFolder, "Basarsoft.db");
    return await openDatabase(path,
        onCreate: _onCreate, version: _version, onUpgrade: _onUpgrade);
  }

  FutureOr<void> _onUpgrade(Database db, int oldVersion, int version) async {
    if (oldVersion > version) {
//

    }
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE Activities( 
      activitiesID INTEGER   ,
      userToken TEXT,
      startLocLat REAL,
      startLocLong REAL,finalLocLat REAL,
      finalLocLong REAL,distance REAL,
      stepCounter integer,
      weatherCelcius REAL,
      weatherDescription TEXT,    
      savedTime TEXT,
      PRIMARY KEY("activitiesID" AUTOINCREMENT))''');
    await db.execute(''' 
    CREATE TABLE PolylinesPoints(
      polylineID INTEGER ,
      polylineLat REAL,
      polylineLong REAL,
      activitiesID int ,
      PRIMARY KEY("polylineID" AUTOINCREMENT),
      CONSTRAINT fk_Activities
        FOREIGN KEY(activitiesID)
        REFERENCES PolylinesPoints(activitiesID)
    )
    ''');
  }

  Future<int> insertActivities(Activities model) async {
    var dbClient = await database;
    return await dbClient!.insert(
      "Activities",
      model.toJson(),
    );
  }

  Future<int> insertPolylines(PolylinesPoints poli) async {
    var dbClient = await database;
    return await dbClient!.insert("PolylinesPoints", poli.tojson());
  }

  Future<bool> haveData() async {
    var dbClient = await database;
    List<Map> maps =
        await dbClient!.rawQuery("select * from Activities where activitiesID");

    return maps.isEmpty;
  }

  FutureOr<List<Activities>> getLastDatas() async {
    var dbClient = await database;

    List<Map> lastID = await dbClient!.rawQuery(
        "Select * from  PolylinesPoints where activitiesID=(select Max(activitiesID) from PolylinesPoints  )");

    List<PolylinesPoints> ourId =
        lastID.map((e) => PolylinesPoints.fromJson(e)).toList();

    List<Map> maps = await dbClient.rawQuery(
        "select * from Activities where activitiesID=${ourId[0].activitiesID}");

    return maps.map((e) => Activities.fromJson(e)).toList();
  }

  Future<List<PolylinesPoints>> getPoliesDatas(int id) async {
    var dbClient = await database;
    List<Map> maps = await dbClient!
        .rawQuery("select * from PolylinesPoints where activitiesID=${id}");
    return maps.map((e) => PolylinesPoints.fromJson(e)).toList();
  }

  Future<int> getID() async {
    var dbClient = await database;
    List<Map> lastID = await dbClient!.rawQuery(
        "Select * from  PolylinesPoints where activitiesID=(select Max(activitiesID) from PolylinesPoints  )");
    List<PolylinesPoints> ourID =
        lastID.map((e) => PolylinesPoints.fromJson(e)).toList();
    return ourID[0].activitiesID;
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
