import 'package:flutter/material.dart';

class Alert {
  static final Alert _singleton = Alert._internal();

  factory Alert() {
    return _singleton;
  }

  Alert._internal();

  AlertDialog _dialogMessage;
  AlertDialog _dialogError;
  AlertDialog _dialogBooking;

  void _show(AlertDialog dialog, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void message(BuildContext context, String text) {
    if (_dialogMessage == null)
      _dialogMessage = AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.info, size: 20),
              Text(" Aplicação")
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

    _show(_dialogMessage, context);
  }

  void error(BuildContext context, String text) {
    if (_dialogError == null)
      _dialogError = AlertDialog(
          title: Row(
            children: <Widget>[
              Icon(Icons.report_problem, size: 20),
              Text(" Atenção!")
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

    _show(_dialogError, context);
  }

  void booking(
      BuildContext context, String title, String text, Function function) {
    if (_dialogBooking == null)
      _dialogBooking = AlertDialog(
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

    _show(_dialogBooking, context);
  }
}
