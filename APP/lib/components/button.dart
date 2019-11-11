import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String label;
  final Function submitted;

  Button({
    Key key,
    @required this.label,
    @required this.submitted,
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return _form();
  }

  Widget _form() {
    return ButtonTheme(
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: RaisedButton(
        color: Colors.teal,
        textColor: Colors.white,
        onPressed: () {
          this.widget.submitted();
        },
        child: Text(this.widget.label),
      ),
    );
  }
}
