import 'package:flutter/material.dart';
import 'package:tcc_app/components/cell.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/service/favorites.dart';

class TableView extends StatefulWidget {
  final Axis direction;
  final List<Restaurant> restaurants;
  final Function booking, favorite;

  TableView({
    Key key,
    @required this.direction,
    @required this.restaurants,
    @required this.booking,
    @required this.favorite,
  }) : super(key: key);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final cache = Cache();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<int>>(
      future: _favorites(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return ListView.builder(
                scrollDirection: this.widget.direction,
                itemCount: this.widget.restaurants.length ?? 0,
                itemBuilder: (_, index) {
                  var restaurant = this.widget.restaurants[index];
                  var favorited = snapshot.data.contains(restaurant.id);
                  return Cell(
                      size: MediaQuery.of(context).size,
                      restaurant: restaurant,
                      favorited: favorited,
                      booking: this.widget.booking,
                      favorite: this.widget.favorite);
                });
          default:
            return Loader().show();
        }
      },
    );
  }

  Future<List<int>> _favorites() async {
    var user = await this.cache.userCache();
    if (user.id == null) return [];
    var restaurants = await this.cache.restaurantsCache(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      this.cache.setRestaurants(result.item2, user.id, "favorites");
      restaurants = result.item2;
    }

    var ids = restaurants.map((restaurant) {
      return restaurant.id;
    }).toList();

    return ids;
  }
}
