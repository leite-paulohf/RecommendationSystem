import 'package:flutter/material.dart';

class Alert {
  static final Alert _singleton = Alert._internal();

  factory Alert() {
    return _singleton;
  }

  Alert._internal();

  void _show(AlertDialog dialog, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  void message(BuildContext context, String text) {
    var dialog = AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.info, size: 20, color: Colors.green),
            Text(" Sucesso!", style: TextStyle(color: Colors.green))
          ],
        ),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Colors.teal,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);

    _show(dialog, context);
  }

  void error(BuildContext context, String text) {
    var dialog = AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.report_problem, size: 20, color: Colors.deepOrange),
            Text(" Atenção!", style: TextStyle(color: Colors.deepOrange))
          ],
        ),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "OK",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Colors.teal,
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ]);

    _show(dialog, context);
  }

  void booking(
      BuildContext context, String title, String text, Function function) {
    var dialog = AlertDialog(
        title: Row(
          children: <Widget>[
            Icon(Icons.restaurant, size: 20, color: Colors.teal),
            Text(" $title",
                style: TextStyle(color: Colors.teal),
                overflow: TextOverflow.fade,
                maxLines: 1,
                softWrap: false)
          ],
        ),
        content: Text(text),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "CANCELAR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Colors.teal,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              "CONCLUIR",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            textColor: Colors.teal,
            onPressed: function,
          )
        ]);

    _show(dialog, context);
  }
}
