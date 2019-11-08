import 'package:flutter/material.dart';
import 'package:tcc_app/components/cell.dart';
import 'package:tcc_app/model/restaurant.dart';

class TableView extends StatelessWidget {
  final Axis direction;
  final List<Restaurant> restaurants;
  final Function booking, favorite;

  TableView(
      {@required this.direction,
      @required this.restaurants,
      @required this.booking,
      @required this.favorite});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: this.direction,
        itemCount: this.restaurants.length ?? 0,
        itemBuilder: (_, index) {
          var restaurant = this.restaurants[index];
          return Cell(
              restaurant: restaurant,
              booking: this.booking,
              favorite: this.favorite);
        });
  }
}
