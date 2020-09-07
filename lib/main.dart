import 'package:flutter/material.dart';
import 'package:photographie/ui/home.dart';

void main() {
  runApp(Photography());
}

class Photography extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GS Photographie',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat',
      ),
      home: HomeUI(),
    );
  }

}
