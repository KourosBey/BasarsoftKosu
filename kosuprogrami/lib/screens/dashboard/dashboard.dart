import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Consumer2<GoogleSignInProvider, EmailUserProvider>(
      builder: ((
        context,
        value,
        emailUser,
        child,
      ) {
        if (value.googleAccount != null) {
          return Scaffold(
              backgroundColor: Color.fromARGB(255, 229, 252, 230),
              body: loggedInUI(value, emailUser.user));
        } else if (emailUser.user != null) {
          return Scaffold(
              backgroundColor: Color.fromARGB(255, 229, 252, 230),
              body: loggedInUI(value, emailUser.user));
        } else {
          return Container();
        }
      }),
    );

    // Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     CircleAvatar(
    //       backgroundImage: Image.network("").image,
    //       radius: 50,
    //     ),
    //   ],
    // );
  }

  // Widget loggedInEmailUI(User? email) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Center(
  //         child: CircleAvatar(
  //           backgroundImage: Image.network(email?.photoURL ?? "").image,
  //           radius: 50,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget loggedInUI(GoogleSignInProvider model, User? user) {
    int hedef = 10000;

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.green,
              child: CircleAvatar(
                backgroundImage: Image.network(
                        model.googleAccount?.photoUrl ?? user?.photoURL ?? "")
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
              allExercise(hedef)
            ],
          )),
          const Padding(padding: EdgeInsets.all(20.0)),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 25,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.orange,
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
                  children: const [Text("Son Yapılan İdman")]),
            ),
          ),
          const Padding(padding: EdgeInsets.all(20.0)),
          Center(
              child: Container(
                  decoration:
                      const BoxDecoration(color: Colors.orange, boxShadow: [
                    BoxShadow(
                        offset: Offset(4.0, 4.0),
                        blurRadius: 5.0,
                        color: Colors.grey),
                  ]),
                  width: MediaQuery.of(context).size.width - 25,
                  height: 120)),
          const Padding(padding: EdgeInsets.all(20.0)),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: iconsBox(),
                    width: 100,
                    height: 50,
                    child: favoriteIcons(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Container(
                    decoration: iconsBox(),
                    width: 100,
                    height: 50,
                    child: favoriteIcons(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Container(
                    decoration: iconsBox(),
                    width: 100,
                    height: 50,
                    child: favoriteIcons(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Container(
                    decoration: iconsBox(),
                    width: 100,
                    height: 50,
                    child: favoriteIcons(),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                  Container(
                    decoration: iconsBox(),
                    width: 100,
                    height: 50,
                    child: favoriteIcons(),
                  ),
                ],
              ),
            ),
          )
        ]);
  }

  BoxDecoration iconsBox() {
    return const BoxDecoration(
      color: Colors.orange,
      boxShadow: [
        BoxShadow(
            offset: Offset(4.0, 4.0), blurRadius: 5.0, color: Colors.grey),
      ],
    );
  }

  Center favoriteIcons() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Icon(
            Icons.favorite,
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

  Row allExercise(int hedef) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: const BoxDecoration(
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
                    percent: 0.5,
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
                            "${hedef - (hedef * 0.5).toInt()}"),
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
                    percent: 0.5,
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
                            "${hedef - (hedef * 0.5).toInt()}"),
                  ],
                ))
              ]),
        ),
      ],
    );
  }
}
