import 'package:flutter/material.dart';
import 'package:kosuprogrami/screens/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 71, 245, 77).withOpacity(0.8),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    )
                  ],
                  border: Border.all(width: 1),
                  borderRadius: BorderRadius.circular(50),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/originals/04/62/84/0462841ea59ce3f31c8d349e670c48f5.gif"),
                      fit: BoxFit.cover)),
              duration: const Duration(seconds: 5),
              curve: Curves.fastOutSlowIn,
            ),
            const Text("Hoşgeldiniz..")
          ],
        )));
  }
}
