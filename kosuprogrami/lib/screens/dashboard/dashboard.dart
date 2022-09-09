import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kosuprogrami/databases/dbActivityDatas.dart';
import 'package:kosuprogrami/models/activities_model.dart';
import 'package:kosuprogrami/models/empty_activities_model.dart';
import 'package:kosuprogrami/provider/activitiesProvider.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
import 'package:kosuprogrami/screens/dashboard/activity/historyActivity.dart';
import 'package:kosuprogrami/screens/dashboard/activity/newActivity.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../provider/googleProvider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late UserDatabaseProvider databaseProvider;

  @override
  void initState() {
    super.initState();

    databaseProvider = UserDatabaseProvider();
  }

  int step = 0;
  Map<PolylineId, Polyline> polylinesLast = {};
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
            backgroundColor: const Color.fromARGB(255, 229, 252, 230),
            body: loggedInUI(value, emailUser.user, activities));
      }),
    );
  }

  addPolyline(ActivitiesProvider activities) {
    PolylineId id = const PolylineId("poly");

    List<LatLng> poliesLatz = [];
    LatLng latlng;
    for (var poli in activities.poliePoints) {
      latlng = LatLng(poli.polylineLat, poli.polylineLong);
      poliesLatz.add(latlng);
    }

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.black,
      points: poliesLatz,
      width: 8,
    );
    getAllStep(activities);
    setState(() {
      polylinesLast[id] = polyline;
    });
  }

  void getAllStep(ActivitiesProvider activities) {
    int stepCounter = 0;
    for (var items in activities.items) {
      stepCounter += items.stepCounter;
    }
    setState(() {
      step = stepCounter;
    });
  }

  Widget loggedInUI(
      GoogleSignInProvider model, User? user, ActivitiesProvider activities) {
    int hedef = 1000;

    GoogleMapController? _controller;
    Map<PolylineId, Polyline> polylines = {};
    activities.getList();
    List<Activities> a = activities.items;
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.green,
                  child: CircleAvatar(
                    backgroundImage: Image.network(
                            model.googleAccount?.photoUrl ??
                                user?.photoURL ??
                                "")
                        .image,
                    radius: 50,
                  ),
                ),
              ),
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${model.googleAccount?.displayName ?? user?.displayName ?? "Default"}",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                        shadows: [
                          Shadow(
                              offset: Offset(2.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.grey)
                        ]),
                  ),
                  const Padding(padding: EdgeInsets.all(20.0)),
                  allExercise(hedef, activities)
                ],
              )),
              const Padding(padding: EdgeInsets.all(20.0)),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 25,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(4.0, 4.0),
                          blurRadius: 5.0,
                          color: Colors.grey),
                    ],
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("Son İdman Haritası"),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Center(
                            child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width - 50,
                          height: 120,
                          child: GoogleMap(
                            polylines: Set<Polyline>.of(polylinesLast.values),
                            mapType: MapType.normal,
                            compassEnabled: false,
                            initialCameraPosition: CameraPosition(
                              target: LatLng(activities.items.first.finalLocLat,
                                  activities.items.first.finalLocLong),
                              zoom: 18.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller = controller;
                              addPolyline(activities);
                            },
                          ),
                        ))
                      ]),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20.0)),
              Center(
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.orange,
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(4.0, 4.0),
                            blurRadius: 5.0,
                            color: Colors.grey),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: MediaQuery.of(context).size.width - 25,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Son Yapılan İdman Detay"),
                      Padding(padding: const EdgeInsets.all(10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 5.0,
                                      color: Colors.black),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                const Text("Yürünen Mesafe"),
                                Text(
                                    "${activities.items.first.distance.toStringAsFixed(2).toString()}" +
                                        "KM"),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 5.0,
                                      color: Colors.black),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                const Text("Hava Sıcaklığı"),
                                Text(
                                    "${activities.items.first.weatherCelcius.toStringAsFixed(2).toString()}\u2103"),
                              ],
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(4.0, 4.0),
                                      blurRadius: 5.0,
                                      color: Colors.black),
                                ],
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: Column(
                              children: [
                                const Text("Hava Durumu"),
                                Text(activities.items.first.weatherDescription),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.all(20.0)),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => const NewActivy())))
                      },
                      child: Container(
                        decoration: iconsBox(),
                        width: MediaQuery.of(context).size.width / 2.25,
                        height: 50,
                        child: newActivity(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20.0),
                    ),
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => HistoryActivity())))
                      },
                      child: Container(
                        decoration: iconsBox(),
                        width: MediaQuery.of(context).size.width / 2.25,
                        height: 50,
                        child: historyIcons(),
                      ),
                    )
                  ],
                ),
              )
            ]));
  }

  BoxDecoration iconsBox() {
    return const BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      color: Colors.orange,
      boxShadow: [
        BoxShadow(
            offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.grey),
      ],
    );
  }

  Center historyIcons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.history,
            color: Colors.white,
            size: 30.0,
            shadows: [
              Shadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                blurRadius: 5.0,
              )
            ],
          ),
          Text(
            "Yeni Etkinlik Başlat",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Center newActivity() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.add,
            color: Colors.white,
            size: 30.0,
            shadows: [
              Shadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                blurRadius: 5.0,
              )
            ],
          ),
          Text(
            "Yeni Etkinlik Başlat",
            style: TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  Row allExercise(int hedef, ActivitiesProvider activities) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.orange,
            boxShadow: [
              BoxShadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 5.0,
                  color: Colors.grey),
            ],
          ),
          width: MediaQuery.of(context).size.width / 2.25,
          height: 120,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: const Text(
                    "Günlük Yürüyüş",
                    style: TextStyle(),
                  ),
                ),
                Center(
                  child: CircularPercentIndicator(
                    radius: 30,
                    lineWidth: 5.0,
                    animation: true,
                    percent: ((hedef - (step)) / (hedef * 100)),
                    center: const Text("Hedef"),
                  ),
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        style:
                            const TextStyle(fontSize: 12, fontFamily: "Arial"),
                        "Günlük Kalan Hedefiniz : " +
                            "${hedef - (step).toInt()}"),
                  ],
                ))
              ]),
        ),
        const Padding(
            padding: EdgeInsets.only(
          left: 5.0,
        )),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.orange,
            boxShadow: [
              BoxShadow(
                  offset: Offset(4.0, 4.0),
                  blurRadius: 5.0,
                  color: Colors.grey),
            ],
          ),
          width: MediaQuery.of(context).size.width / 2.25,
          height: 120,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 10.0, top: 5.0),
                  child: const Text(
                    "Aylık Yürüyüş",
                    style: TextStyle(),
                  ),
                ),
                Center(
                  child: CircularPercentIndicator(
                    radius: 30,
                    lineWidth: 5.0,
                    animation: true,
                    percent: ((hedef * 7 - (step)) / (hedef * 100)),
                    center: const Text("Hedef"),
                  ),
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                        style:
                            const TextStyle(fontSize: 12, fontFamily: "Arial"),
                        "Aylık Kalan Hedefiniz : " +
                            "${hedef * 7 - (step).toInt()}"),
                  ],
                ))
              ]),
        ),
      ],
    );
  }
}
