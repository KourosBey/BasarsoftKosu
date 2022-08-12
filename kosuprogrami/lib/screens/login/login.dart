import "package:flutter/material.dart";
import 'package:kosuprogrami/provider/googleProvider.dart';
import 'package:kosuprogrami/screens/main/mainPage.dart';
import 'package:kosuprogrami/services/AuthService.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loginUI(),
    );
  }

  Widget loginUI() {
    return Consumer<GoogleSignInProvider>(
      builder: ((context, value, child) {
        if (value.googleAccount != null) {
          return loggedInUI(value);
        } else {
          return loginControls(context);
        }
      }),
    );
  }

  Widget loggedInUI(GoogleSignInProvider model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundImage:
              Image.network(model.googleAccount!.photoUrl ?? "").image,
          radius: 50,
        ),
      ],
    );
  }

  Widget loginControls(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    final AuthService _authService = AuthService();
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
                                      builder: (context) => const MainPage()));
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
                                    builder: ((context) => const LoginPage())))
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
                          onPressed: () => {
                            Provider.of<GoogleSignInProvider>(context,
                                    listen: false)
                                .login()
                          },
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
}
