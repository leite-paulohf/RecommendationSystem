import 'package:flutter/material.dart';
import 'package:tcc_app/model/restaurant.dart';

class Cell extends StatelessWidget {
  final Restaurant restaurant;
  final Function booking, favourite;

  Cell(
      {@required this.restaurant,
      @required this.booking,
      @required this.favourite});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
    );
  }
}
