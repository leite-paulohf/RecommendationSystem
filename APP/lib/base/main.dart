import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.teal), home: Home());
  }
}
