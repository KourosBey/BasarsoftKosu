import 'dart:async';

import 'package:kosuprogrami/models/activities_model.dart';
import 'package:sqflite/sqflite.dart';

class UserDatabaseProvider {
  final String _userDatabaseName = "BasarsoftDB";
  Database? _db;

  Future<void> open(saveActivity) async {
    _db = await openDatabase(
      _userDatabaseName,
      version: 1,
      onCreate: (db, version) {},
    );

    await _db!.insert("Activities", saveActivity,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
