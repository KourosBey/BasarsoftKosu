import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PolylinesPoints {
  double polylineLat;
  double polylineLong;
  int activitiesID;
  PolylinesPoints({
    required this.polylineLat,
    required this.polylineLong,
    required this.activitiesID,
  });

  factory PolylinesPoints.fromJson(Map<dynamic, dynamic> json) {
    return PolylinesPoints(
      polylineLat: json["polylineLat"],
      polylineLong: json["polylineLong"],
      activitiesID: json["activitiesID"],
    );
  }

  Map<String, dynamic> tojson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["polylineLat"] = polylineLat;
    data["polylineLong"] = polylineLong;
    data["activitiesID"] = activitiesID;

    return data;
  }
}

class Activities {
  String userToken;
  double startLocLat; //+
  double startLocLong; //+
  double finalLocLat; //+
  double finalLocLong; //+
  double distance; //+

  // List<double> polylineLat;
  // List<double> polylineLong; //+
  int stepCounter; //+
  double weatherCelcius; //+
  String weatherDescription; //+
  DateTime savedDate;

  Activities(
      {required this.userToken,
      required this.distance,
      required this.finalLocLong,
      required this.finalLocLat,

      // required this.polylineLat,
      // required this.polylineLong,
      required this.savedDate,
      required this.startLocLat,
      required this.startLocLong,
      required this.stepCounter,
      required this.weatherCelcius,
      required this.weatherDescription});

  factory Activities.fromJson(Map<dynamic, dynamic> json) {
    return Activities(
        userToken: json["userToken"],
        distance: json["distance"],
        finalLocLong: json["startLocLong"],
        finalLocLat: json["startLocLat"],

        // polylineLat: json["polylineLat"],
        // polylineLong: json["polylineLong"],
        savedDate: DateTime.parse(json["savedTime"]),
        startLocLat: json["startLocLat"],
        startLocLong: json["startLocLong"],
        stepCounter: json["stepCounter"],
        weatherCelcius: json["weatherCelcius"],
        weatherDescription: json["weatherDescription"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userToken'] = userToken;
    data['startLocLat'] = startLocLat;
    data['startLocLong'] = startLocLong;
    data['finalLocLat'] = finalLocLat;
    data['finalLocLong'] = finalLocLong;
    data['distance'] = distance;

    // data['polylineLat'] = List<double>.from(polylineLat.map((e) => e));
    // data['polylineLong'] = List<double>.from(polylineLong.map((e) => e));
    data['stepCounter'] = stepCounter;
    data['weatherCelcius'] = weatherCelcius;
    data['weatherDescription'] = weatherDescription;
    data['savedTime'] = savedDate.toIso8601String();
    return data;
  }
}
