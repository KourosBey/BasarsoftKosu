import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kosuprogrami/provider/activitiesProvider.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
import 'package:kosuprogrami/provider/googleProvider.dart';
import 'package:kosuprogrami/screens/Shared/colors.dart';
import 'package:kosuprogrami/screens/login/login.dart';
import 'package:kosuprogrami/screens/splash/splashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          create: (context) => ActivitiesProvider(),
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
