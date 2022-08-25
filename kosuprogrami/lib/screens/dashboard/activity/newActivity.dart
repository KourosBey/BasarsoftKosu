import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NewActivy extends StatefulWidget {
  const NewActivy({Key? key}) : super(key: key);

  @override
  State<NewActivy> createState() => _NewActivyState();
}

class _NewActivyState extends State<NewActivy> {
  StreamSubscription? _locationSubscription;
  final Location _locationTracker = Location();
  Marker? marker;
  Marker? fisrtLocationMarker;
  Circle? circle;

  Map<PolylineId, Polyline> polylines = {};
  GoogleMapController? _controller;

  static CameraPosition initialLocation = const CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 12.0,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("assets/car_icon.png");

    return byteData.buffer.asUint8List();
  }

  void getDirections(LocationData currentLocation) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints? polylineDistance;
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
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void getFirstLocation(LocationData firstLocationData) {
    LatLng firstLocation =
        LatLng(firstLocationData.latitude!, firstLocationData.longitude!);

    setState(() {
      fisrtLocationMarker = Marker(
        markerId: const MarkerId("firstLocation"),
        position: firstLocation,
        draggable: false,
        zIndex: 2,
        flat: false,
        icon: BitmapDescriptor.defaultMarker,
      );
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
      getFirstLocation(location);
      updateMarkerAndCircle(location, imageData);
      getDirections(location);

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
                  zoom: 16.00)));
          updateMarkerAndCircle(newLocalData, imageData);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            routeMenuWidget(context),
            Center(
              child: Container(
                child: GestureDetector(
                    onTap: () {
                      getCurrentLocation();
                    },
                    child: const Icon(Icons.play_circle_sharp, size: 60)),
              ),
            ),
            statusForExercise(),
          ]),
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
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
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
                      children: const [
                        Text(
                          "fark",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
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
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
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
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
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
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: const [
                        Text(
                          "5.2KM",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "yürüdüğünüz yol",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ],
              )
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
        polylines: Set<Polyline>.of(polylines.values),
        markers:
            Set.of((marker != null) ? [marker!, fisrtLocationMarker!] : []),
        circles: Set.of((circle != null) ? [circle!] : []),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
      ),
    );
  }

  // LocationData? currentLocation;
  // void stateSet() async {
  //   Position position = await _determinePosition();
  //   setState(() {
  //     googleMapController?.animateCamera(CameraUpdate.newCameraPosition(
  //         CameraPosition(
  //             target: LatLng(position.latitude, position.latitude), zoom: 20)));
  //   });
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error("Location services are disabled");
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error("Location Permission Denied");
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error("Permission Denied Forever");
  //   }
  //   Position position = await Geolocator.getCurrentPosition();
  //   return position;
  // }
}
