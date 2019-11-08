import 'package:flutter/material.dart';

class Alert {
  static void show(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.report_problem, size: 20),
                Text(" Service Error")
              ],
            ),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"),
                  textColor: Colors.teal,
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      },
    );
  }
}
