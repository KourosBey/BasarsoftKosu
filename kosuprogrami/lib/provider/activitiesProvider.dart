import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kosuprogrami/models/activities_model.dart';

import '../databases/dbActivityDatas.dart';

class ActivitiesProvider with ChangeNotifier {
  List<PolylinesPoints>? polylinePoints;

  List<Activities> items = [];
  int id = 0;
  List<PolylinesPoints> poliePoints = [];
  UserDatabaseProvider _dbProvider;

  ActivitiesProvider(
    this._dbProvider,
  ) {
    if (_dbProvider != null) getList();
  }

  FutureOr<void> addActivities(
    String _userToken,
    double _startLoclat,
    double _startLocLong,
    double _finalLocLat,
    double _finalLocLong,
    double _distance,
    int _stepCounter,
    double _weatherCelcius,
    String _weatherDescription,
    Polyline _polylinecordinates,
  ) async {
    Activities newActivity = Activities(
        userToken: _userToken,
        distance: _distance,
        finalLocLong: _finalLocLong,
        finalLocLat: _finalLocLat, // savedDate: savedDate,
        startLocLat: _startLoclat,
        startLocLong: _startLocLong,
        stepCounter: _stepCounter,
        weatherCelcius: _weatherCelcius,
        weatherDescription: _weatherDescription,
        savedDate: DateTime.now());

    var insertReq = await UserDatabaseProvider().insertActivities(newActivity);
    polylinePoints = addArgs(_polylinecordinates, insertReq);

    polylinePoints?.forEach((element) async {
      await UserDatabaseProvider().insertPolylines(element);
    });
    notifyListeners();
  }

  Future<void> getList() async {
    items = await UserDatabaseProvider().getLastDatas();
    id = await UserDatabaseProvider().getID();
    poliePoints = await UserDatabaseProvider().getPoliesDatas(id);
    notifyListeners();
  }

  List<PolylinesPoints> addArgs(Polyline polylinecordinates, int actID) {
    Iterable<LatLng> polyLinePoints = polylinecordinates.points.map((e) => e);
    List<String> listem = [];
    List<PolylinesPoints> polimm = [];
    int index = 0;
    for (var element in polyLinePoints) {
      PolylinesPoints addPoly = PolylinesPoints(
          polylineLat: element.latitude,
          polylineLong: element.longitude,
          activitiesID: actID);
      index++;
      polimm.add(addPoly);
    }

    return polimm;

    // Object? polydenme = polylinecordinates.toJson();
    // var polydeneme2 = jsonDecode("polydeneme", {polydenme!});
  }
}
