import 'package:flutter/material.dart';

class ErrorState extends StatelessWidget {
  const ErrorState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("something wrong"),
      ),
    );
  }
}
