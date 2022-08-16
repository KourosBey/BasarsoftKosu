import 'package:firebase_auth/firebase_auth.dart';
import 'package:kosuprogrami/services/AuthService.dart';
import 'package:flutter/material.dart';

class EmailUserProvider extends ChangeNotifier {
  User? user;
  login(String email, String password) async {
    await AuthService()
        .signInWithEmailPassword(email, password)
        .then((value) => user = value);
    notifyListeners();
  }

  logout() {}
}
