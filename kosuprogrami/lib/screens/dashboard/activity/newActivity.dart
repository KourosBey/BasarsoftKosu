import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kosuprogrami/models/activities_model.dart';
import 'package:kosuprogrami/provider/activitiesProvider.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather.dart';

import '../../../databases/dbActivityDatas.dart';
import '../../../provider/googleProvider.dart';
import '../../../repositories/weatherCall.dart';

class NewActivy extends StatefulWidget {
  const NewActivy({Key? key}) : super(key: key);

  @override
  State<NewActivy> createState() => _NewActivyState();
}

class _NewActivyState extends State<NewActivy> {
  late UserDatabaseProvider databaseProvider;

  @override
  void initState() {
    super.initState();
    databaseProvider = UserDatabaseProvider();
  }

  bool firstPlay = false;
  bool isStart = false;
  bool loading = true;
  StreamSubscription? _locationSubscription;
  final Location _locationTracker = Location();
  Marker? marker;
  Marker? fisrtLocationMarker;
  Circle? circle;
  int? adimSay = 0;
  PolylinePoints? polylineDistance = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  late Polyline polylinezzz;
  GoogleMapController? _controller;
  double distance = 0.0;
  bool clickPlay = false;
  bool newPlayButton = false;
  Weather? currentLocationWeather;
  int saat = 0;
  int dakika = 0;
  int saniye = 0;
  Timer? _timer;
  List<PolylinesPoints> sendPolies = [];
  static CameraPosition initialLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 18.0,
  );

  void _startTimer() {
    setState(() {
      isStart = !isStart;
      if (isStart) {
        _timer = Timer.periodic(
            const Duration(milliseconds: 100),
            (Timer timer) => setState(() {
                  saniye++;
                  if (saniye == 100) {
                    dakika++;
                    saniye = 0;
                  }
                  if (dakika == 60) {
                    saat++;
                  }
                }));
      }
    });
  }

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");

    return byteData.buffer.asUint8List();
  }

  void getDirections(LocationData currentLocation) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylineDistance!.getRouteBetweenCoordinates(
      "AIzaSyAzb-o3T89SUI6soC6GuJNW8Bk0VpD4NG4",
      PointLatLng(fisrtLocationMarker!.position.latitude,
          fisrtLocationMarker!.position.longitude),
      PointLatLng(currentLocation.latitude!, currentLocation.longitude!),
      travelMode: TravelMode.walking,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    addPolyLine(polylineCoordinates);

    setState(() {
      adimSay = ((distance * 100000).toInt() / 70).toInt();
      distance = totalDistance;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  void addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: polylineCoordinates,
      width: 8,
    );
    polylinezzz = polyline;
    polylines[id] = polyline;

    setState(() {});
  }

  void getFirstLocation() async {
    Uint8List imageData = await getMarker();
    var location = await _locationTracker.getLocation();
    LatLng firstLocation = LatLng(location.latitude!, location.longitude!);
    currentLocationWeather = await getWeatherLocation(location);

    if (_controller != null) {
      _controller?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(location.latitude!, location.longitude!),
          tilt: 2,
          zoom: 18.00)));
      updateMarkerAndCircle(location, imageData);
    }
    setState(() {
      fisrtLocationMarker = Marker(
        markerId: const MarkerId("firstLocation"),
        position: firstLocation,
        draggable: false,
        zIndex: 2,
        flat: false,
        icon: BitmapDescriptor.defaultMarker,
      );
      loading = false;
    });
  }

  void updateMarkerAndCircle(
      LocationData newLocalData, Uint8List imageData) async {
    LatLng latlng = LatLng(newLocalData.latitude!, newLocalData.longitude!);

    setState(() {
      marker = Marker(
          markerId: const MarkerId("home"),
          position: latlng,
          rotation: newLocalData.heading!,
          draggable: false,
          zIndex: 2,
          flat: true,
          anchor: const Offset(0.5, 0.5),
          icon: BitmapDescriptor.fromBytes(imageData));
      circle = Circle(
          circleId: const CircleId("car"),
          radius: newLocalData.accuracy!,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: latlng,
          fillColor: Colors.blue.withAlpha(70));
    });
  }

  void getCurrentLocation() async {
    try {
      Uint8List imageData = await getMarker();

      var location = await _locationTracker.getLocation();

      updateMarkerAndCircle(location, imageData);

      if (_locationSubscription != null) {
        _locationSubscription!.cancel();
      }

      _locationSubscription =
          _locationTracker.onLocationChanged.listen((newLocalData) {
        if (_controller != null) {
          _controller?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  bearing: 192.8334901395799,
                  target:
                      LatLng(newLocalData.latitude!, newLocalData.longitude!),
                  tilt: 5,
                  zoom: 18.00)));

          updateMarkerAndCircle(newLocalData, imageData);
          getDirections(newLocalData);
        }
      });
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<GoogleSignInProvider, EmailUserProvider,
        ActivitiesProvider>(
      builder: ((
        context,
        value,
        emailUser,
        activities,
        child,
      ) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange,
          ),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                routeMenuWidget(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        child: GestureDetector(
                          onTap: () {
                            if (clickPlay) {
                              _timer!.cancel();

                              isStart = false;
                              clickPlay = false;
                            } else {
                              clickPlay = true;
                              firstPlay = true;
                              _startTimer();
                              getCurrentLocation();
                            }
                            setState(() {
                              newPlayButton = clickPlay;
                            });
                          },
                          child: newPlayButton
                              ? const Icon(Icons.pause_circle_filled_sharp,
                                  size: 60)
                              : const Icon(Icons.play_circle_sharp, size: 60),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        child: GestureDetector(
                            onTap: () {
                              if (clickPlay) {
                                _timer!.cancel();
                                isStart = false;
                                clickPlay = false;
                                newPlayButton = false;

                                activities.addActivities(
                                  value.googleAccount != null
                                      ? value.googleAccount!.id
                                      : emailUser.user!.uid,
                                  marker!.position.latitude,
                                  marker!.position.longitude,
                                  fisrtLocationMarker!.position.latitude,
                                  fisrtLocationMarker!.position.longitude,
                                  distance,
                                  adimSay!,
                                  currentLocationWeather!.temperature!.celsius!,
                                  currentLocationWeather!.weatherDescription!,
                                  polylinezzz,
                                );
                              } else {
                                getCurrentLocation();
                              }
                            },
                            child:
                                const Icon(Icons.stop_circle_sharp, size: 60)),
                      ),
                    ),
                  ],
                ),
                statusForExercise(),
              ]),
        );
      }),
    );
  }

  Center statusForExercise() {
    return Center(
      child: Container(
          decoration: const BoxDecoration(color: Colors.grey),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          distance.toStringAsFixed(2).toString() + " KM",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Toplam Mesafe",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          adimSay.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Attığınız Adım Sayısı",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          currentLocationWeather != null
                              ? "${(currentLocationWeather!.temperature!.celsius)!.toInt()}\u2103 "
                              : "Yükleniyor..".toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Sıcaklık",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: currentLocationWeather != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(
                                'http://openweathermap.org/img/w/${(currentLocationWeather!.weatherIcon!)}.png',
                                scale: 1.25,
                              ),
                              Text(
                                "${(currentLocationWeather!.weatherDescription)}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )
                              // 60 dakikada bir Request oluşturulabiliyor.
                            ],
                          )
                        : const Text("Yükleniyor.."),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          "$saat" r"'" ":" "$dakika" r"''" ":" "$saniye" r"'''",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Geçen Süre",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          distance != 0
                              ? "${(distance / ((saat.toDouble() + ((dakika).toDouble() / 60 + (saniye / 6000).toDouble())))).toStringAsFixed(2)}"
                                  " KM/S"
                              : "0",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Ortalama Hız",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  Center routeMenuWidget(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: const BoxDecoration(color: Colors.grey),
        child: Container(
          child: _buildGoogleMap(context),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        compassEnabled: false,
        polylines: firstPlay == true
            ? Set<Polyline>.of(polylines.values)
            : Set<Polyline>.of({}),
        markers: Set.of((marker != null) && firstPlay == true
            ? [marker!, fisrtLocationMarker!]
            : []),
        circles: Set.of((circle != null) && firstPlay == true ? [circle!] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          setState(() {
            getFirstLocation();
          });
        },
      ),
    );
  }
}
