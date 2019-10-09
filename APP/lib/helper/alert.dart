import 'package:flutter/material.dart';

class Alert {
  static void show(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("Ops!"),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ]);
      },
    );
  }
}
