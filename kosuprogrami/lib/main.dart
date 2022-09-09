import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kosuprogrami/provider/activitiesProvider.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
import 'package:kosuprogrami/provider/googleProvider.dart';
import 'package:kosuprogrami/screens/Shared/colors.dart';
import 'package:kosuprogrami/screens/login/login.dart';
import 'package:kosuprogrami/screens/splash/splashScreen.dart';
import 'package:provider/provider.dart';

import 'databases/dbActivityDatas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  UserDatabaseProvider user = UserDatabaseProvider();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: const LoginPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => EmailUserProvider(),
          child: const LoginPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => ActivitiesProvider(user),
          child: const LoginPage(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "DEMO",
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const SplashScreen(),
      ),
    );
  }
}
