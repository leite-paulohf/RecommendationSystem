import 'package:flutter/material.dart';
import 'package:tcc_app/components/cell.dart';
import 'package:tcc_app/model/restaurant.dart';

class TableView extends StatelessWidget {
  final List<Restaurant> restaurants;
  final Function booking, favourite;

  TableView(
      {@required this.restaurants,
      @required this.booking,
      @required this.favourite});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.restaurants.length ?? 0,
      itemBuilder: (_, index) {
        var restaurant = this.restaurants[index];
        return Cell(
            restaurant: restaurant,
            booking: this.booking,
            favourite: this.favourite);
      }
    );
  }
}
