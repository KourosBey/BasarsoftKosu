import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosuprogrami/provider/emailUserProvider.dart';
import 'package:provider/provider.dart';

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
          return loggedInUI(value, emailUser.user);
        } else if (emailUser.user != null) {
          return loggedInUI(value, emailUser.user);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            backgroundImage: Image.network(
                    model.googleAccount?.photoUrl ?? user?.photoURL ?? "")
                .image,
            radius: 50,
          ),
        )
      ],
    );
  }
}
