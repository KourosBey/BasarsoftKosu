import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;

  login() async {
    googleAccount = await _googleSignIn.signIn();
    notifyListeners();
  }

  logOut() async {
    googleAccount = await _googleSignIn.signOut();
    notifyListeners();
  }
}
