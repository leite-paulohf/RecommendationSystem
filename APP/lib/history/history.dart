import 'package:flutter/material.dart';

class History extends StatefulWidget {
	History({Key key}) : super(key: key);

	@override
	HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Container(color: Colors.black26),
			),
		);
	}
}
