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
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Container(
        color: Colors.teal,
        child: Column(
          children: <Widget>[
            Text(
              restaurant.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.discount.toString(),
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.price.toString(),
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.rating.toString(),
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.kind.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.city.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.neighbourhood.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.cuisine.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.category.name,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              restaurant.moment.name,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
