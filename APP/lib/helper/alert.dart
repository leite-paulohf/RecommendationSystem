import 'package:flutter/material.dart';

class Alert {
  bool _isShowing = false;

  void show(BuildContext context, String text) {
    if (_isShowing) return;
    _isShowing = true;
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
                  _isShowing = false;
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void error(BuildContext context, String text) {
    if (_isShowing) return;
    _isShowing = true;
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
                  _isShowing = false;
                  Navigator.of(context).pop();
                },
              )
            ]);
      },
    );
  }

  void booking(
      BuildContext context, String title, String text, Function function) {
    if (_isShowing) return;
    _isShowing = true;
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
                  _isShowing = false;
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
