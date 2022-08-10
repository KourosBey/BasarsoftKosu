import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kosuprogrami/login/loginView.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registerCard(context),
    );
  }
}

Widget registerCard(BuildContext context) {
  return Center(
    child: Form(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(
              "https://ak.picdn.net/shutterstock/videos/545377/thumb/1.jpg?ip=x480"),
          fit: BoxFit.cover,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 0.5,
                      color: Colors.black87,
                    ),
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Column(children: [
                  TextFormField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: 'Kayıt olma ekranı',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      hintText: 'Password',
                      filled: false,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      hintText: 'Re-Password',
                      filled: false,
                      fillColor: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[300]),
                        onPressed: () => {},
                        child: const Text("Kayıt Ol"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[300]),
                        onPressed: () => {
                          Navigator.pop(context),
                        },
                        child: const Text(" Geri Dön"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Ya "),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.google,
                        textColor: Colors.white,
                        backgroundColor: Colors.green[300],
                        text: "Google ile kayıt ol",
                        onPressed: () => {},
                      ),
                    ],
                  ),
                ]),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
