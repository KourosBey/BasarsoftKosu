import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Activities {
  String userToken;
  double startLocLat; //+
  double startLocLong; //+
  double finalLocLat; //+
  double finalLocLong; //+
  double distance; //+
//  List<LatLng> polylineData; //+
  int stepCounter; //+
  double weatherCelcius; //+
  String weatherDescription; //+
  // DateTime savedDate;

  Activities(
      {required this.userToken,
      required this.distance,
      required this.finalLocLong,
      required this.finalLocLat,
      //   required this.polylineData,
      //  required this.savedDate,
      required this.startLocLat,
      required this.startLocLong,
      required this.stepCounter,
      required this.weatherCelcius,
      required this.weatherDescription});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
        userToken: json["userToken"],
        distance: json["distance"],
        finalLocLong: json["startLocLong"],
        finalLocLat: json["startLocLat"],
        //   polylineData: json["polylineData"],
        //    savedDate: json["savedTime"],
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
    //  data['polylineData'] = List<LatLng>.from(polylineData.map((e) => e));
    data['stepCounter'] = stepCounter;
    data['weatherCelcius'] = weatherCelcius;
    data['weatherDescription'] = weatherDescription;
    //  data['savedTime'] = savedDate;
    return data;
  }
}
