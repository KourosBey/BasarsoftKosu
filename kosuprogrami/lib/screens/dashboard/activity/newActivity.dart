import 'package:flutter/material.dart';

class NewActivy extends StatefulWidget {
  const NewActivy({Key? key}) : super(key: key);

  @override
  State<NewActivy> createState() => _NewActivyState();
}

class _NewActivyState extends State<NewActivy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            routeMenuWidget(context),
            Center(
              child: Container(
                child: GestureDetector(
                    onTap: () {
                      debugPrint("Tıklandı");
                    },
                    child: const Icon(Icons.play_circle_sharp, size: 60)),
              ),
            ),
          ]),
    );
  }

  Center routeMenuWidget(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        decoration: const BoxDecoration(color: Colors.grey),
        child: Container(),
      ),
    );
  }
}
