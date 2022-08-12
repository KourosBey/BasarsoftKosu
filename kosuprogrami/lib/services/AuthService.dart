import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kosuprogrami/screens/login/login.dart';
import 'package:kosuprogrami/screens/main/mainPage.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  handleAuthState() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return const MainPage();
        } else {
          return const LoginPage();
        }
      },
    );
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    var user;
    try {
      user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("I cant found your account..");
      } else if (e.code == "wrong-password") {
        print('Wrong passowrd try again');
      }
    }
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User?> createPerson(String name, String email, String password) async {
    var user;
    try {
      user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(user.user.uid).set({
        'userName': name,
        'email': email,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("Weak pass");
      } else if (e.code == 'email-already-in-use') {
        print('Email already taken..');
      }
    }
    return user!.user;
  }
}
