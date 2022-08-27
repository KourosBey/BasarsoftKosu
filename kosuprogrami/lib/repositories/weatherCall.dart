import 'package:location/location.dart';
import 'package:weather/weather.dart';

Future<Weather> getWeatherLocation(LocationData? locationData) async {
  WeatherFactory wf = WeatherFactory(
    "85201f6f17cf22ec413163ca0bbb231e",
  );
  Weather data = await wf.currentWeatherByLocation(
      locationData!.latitude!, locationData.longitude!);

  return data;
}
