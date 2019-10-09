import 'package:flutter/material.dart';

class Button extends StatelessWidget {
	final Function submitted;
	final String label;

	Button({@required this.label, @required this.submitted});

	@override
	Widget build(BuildContext context) {
		return _form();
	}

	Widget _form() {
		return ButtonTheme(
			height: 50,
			shape: RoundedRectangleBorder(
					borderRadius: BorderRadius.circular(25)),
			child: RaisedButton(
				color: Colors.teal,
				textColor: Colors.white,
				onPressed: this.submitted,
				child: Text(this.label),
			),
		);
	}
}
