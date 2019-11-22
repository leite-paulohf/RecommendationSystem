import 'package:flutter/material.dart';
import 'package:tcc_app/components/cell.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/favorites.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tuple/tuple.dart';

class TableView extends StatefulWidget {
  final Axis direction;
  final List<Restaurant> restaurants;
  final bool preference;
  final Function booking, favorite, like, unlike;

  TableView({
    Key key,
    @required this.direction,
    @required this.restaurants,
    @required this.preference,
    @required this.booking,
    @required this.favorite,
    @required this.like,
    @required this.unlike,
  }) : super(key: key);

  @override
  _TableViewState createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  final restaurants = RestaurantViewModel(interface: RestaurantService());
  final favorites = FavoritesViewModel(interface: FavoritesService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple2<List<int>, List<int>>>(
      future: _favoritesAndPreferences(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var favorites = snapshot.data.item1;
            var preferences = snapshot.data.item2;
            return ListView.builder(
                scrollDirection: this.widget.direction,
                itemCount: this.widget.restaurants.length ?? 0,
                itemBuilder: (_, index) {
                  var restaurant = this.widget.restaurants[index];
                  var favorited = favorites.contains(restaurant.id);
                  var liked = preferences.contains(restaurant.id);
                  return Cell(
                      size: MediaQuery.of(context).size,
                      restaurant: restaurant,
                      favorited: favorited,
                      preference: this.widget.preference ?? false,
                      liked: liked,
                      booking: this.widget.booking,
                      favorite: this.widget.favorite,
                      like: this.widget.like,
                      unlike: this.widget.unlike);
                });
          default:
            return Loader().show();
        }
      },
    );
  }

  Future<Tuple2<List<int>, List<int>>> _favoritesAndPreferences() async {
    var favorites = await _favorites();
    var preferences = await _preferences();
    return Tuple2(favorites, preferences);
  }

  Future<List<int>> _favorites() async {
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var restaurants = await Cache().restaurantsCache(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      Cache().setRestaurants(result.item2, user.id, "favorites");
      restaurants = result.item2;
    }

    var ids = restaurants.map((restaurant) {
      return restaurant.id;
    }).toList();

    return ids;
  }

  Future<List<int>> _preferences() async {
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var restaurants = await Cache().restaurantsCache(user.id, "preferences");
    if (restaurants.isEmpty) {
      var result = await this.restaurants.preferencesAPI(user.id);
      Cache().setRestaurants(result.item2, user.id, "preferences");
      restaurants = result.item2;
    }

    var ids = restaurants.map((restaurant) {
      return restaurant.id;
    }).toList();

    return ids;
  }
}
