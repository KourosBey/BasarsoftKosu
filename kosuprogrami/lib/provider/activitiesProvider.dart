import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kosuprogrami/models/activities_model.dart';

class ActivitiesProvider with ChangeNotifier {
  List<PolylinesPoints>? polylinePoints;
  void addActivities(
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
  ) {
    Activities newActivity = Activities(
        userToken: _userToken,
        distance: _distance,
        finalLocLong: _finalLocLong,
        finalLocLat: _finalLocLat,
        polyLinePoints: addArgs(_polylinecordinates),
        // savedDate: savedDate,
        startLocLat: _startLoclat,
        startLocLong: _startLocLong,
        stepCounter: _stepCounter,
        weatherCelcius: _weatherCelcius,
        weatherDescription: _weatherDescription);

    var deneme = newActivity.toJson();
    Activities deneme2 = Activities.fromJson(deneme);
  }

  List<PolylinesPoints> addArgs(Polyline polylinecordinates) {
    Iterable<LatLng> polyLinePoints = polylinecordinates.points.map((e) => e);

    List<PolylinesPoints> polimm = [];
    for (var element in polyLinePoints) {
      PolylinesPoints addPoly = PolylinesPoints(
          polylineLat: element.latitude, polylineLong: element.longitude);
      polimm.add(addPoly);
    }

    return polimm;
    // Object? polydenme = polylinecordinates.toJson();
    // var polydeneme2 = jsonDecode("polydeneme", {polydenme!});
  }
}
