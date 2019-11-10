import 'package:flutter/material.dart';

class Alert {
  bool isShowing = false;

  void show(BuildContext context, String text) {
    if (this.isShowing) return;
    this.isShowing = true;
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
                  this.isShowing = false;
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void error(BuildContext context, String text) {
    if (this.isShowing) return;
    this.isShowing = true;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(Icons.report_problem, size: 20),
                Text(" Ops!")
              ],
            ),
            content: Text(text),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                textColor: Colors.teal,
                onPressed: () {
                  this.isShowing = false;
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void booking(
      BuildContext context, String title, String text, Function function) {
    if (this.isShowing) return;
    this.isShowing = true;
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
                  this.isShowing = false;
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
