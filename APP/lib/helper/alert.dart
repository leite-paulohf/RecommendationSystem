import 'package:flutter/material.dart';

class Alert {
  static void show(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.restaurant, size: 20),
                Text(" Sucesso!")
              ],
            ),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                textColor: Colors.teal,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  static void error(BuildContext context, String text) {
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
                },
              )
            ]);
      },
    );
  }

  static void booking(
      BuildContext context, String title, String text, Function function) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.restaurant, size: 20),
                Text(" $title"),
              ],
            ),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text("CANCELAR"),
                textColor: Colors.teal,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("CONCLUIR"),
                textColor: Colors.teal,
                onPressed: function,
              )
            ]);
      },
    );
  }
}
