import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosuprogrami/login/registerView.dart';
import 'package:kosuprogrami/services/auth_service.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Shared/errorPage.dart';

AuthService _authService = AuthService();

class LoginStateView extends StatelessWidget {
  const LoginStateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginCard(context),
    );
  }
}

Widget loginCard(BuildContext context) {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Color buttonColor = const Color.fromARGB(25, 255, 255, 255);
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
                    controller: _emailController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.account_circle),
                      hintText: 'Username',
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.key),
                      hintText: 'Password',
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
                        onPressed: () => {
                          _authService
                              .signInWithEmailPassword(_emailController.text,
                                  _passwordController.text)
                              .then((value) {
                            return Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CircularProgressIndicator()));
                          })
                        },
                        child: const Text("Giriş Yap"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[300]),
                        onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const RegisterView())))
                        },
                        child: const Text(" Kayıt ol"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text("Ya da"),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialLoginButton(
                        buttonType: SocialLoginButtonType.google,
                        textColor: Colors.white,
                        backgroundColor: Colors.green[300],
                        text: "Google ile giriş yap",
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
