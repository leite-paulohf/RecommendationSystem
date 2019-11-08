import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/favorites.dart';

class Favorites extends StatefulWidget {
  Favorites({Key key}) : super(key: key);

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = FavoritesViewModel(interface: FavoritesService());
  final preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("Favoritos"),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body() {
    return FutureBuilder<List<Restaurant>>(
      future: _favorites(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var restaurants = snapshot.data ?? [];
            if (restaurants.isNotEmpty)
              return _list(restaurants);
            else
              return _empty();
            break;
          default:
            return Loader().show();
        }
      },
    );
  }

  Widget _list(List<Restaurant> restaurants) {
    return ScopedModel<FavoritesViewModel>(
      model: this.viewModel,
      child: TableView(
        direction: Axis.vertical,
        restaurants: restaurants,
        booking: _booking,
        favourite: _favourite,
      ),
    );
  }

  Widget _empty() {
    return Center(
        child: Column(
      children: <Widget>[
        Expanded(child: Container()),
        Icon(Icons.inbox, color: Colors.black26, size: 80),
        Text("Você não possui restaurantes favoritos",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black26,
            )),
        Expanded(child: Container()),
      ],
    ));
  }

  Future<List<Restaurant>> _favorites() async {
    var user = await this.preferences.user();
    if (user.id == null) {
      return [];
    }
    var result = await this.viewModel.favorites(user.id);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _removeFavourite() async {
    var user = await this.preferences.user();
    var restaurant = this.viewModel.restaurant;
    var result = await this.viewModel.removeFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  void _booking() {}

  void _favourite() {
    _removeFavourite();
  }
}
