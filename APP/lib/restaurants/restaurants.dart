import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/favorites.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tcc_app/model/error.dart';

class Restaurants extends StatefulWidget {
  Restaurants({Key key}) : super(key: key);

  @override
  RestaurantsState createState() => RestaurantsState();
}

class RestaurantsState extends State<Restaurants> {
  final _key = GlobalKey<ScaffoldState>();
  final _height = 257.0;
  final viewModel = RestaurantViewModel(interface: RestaurantService());
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final preferences = Preferences();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("Restaurants"),
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
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 8)),
        _header("RESTAURANTES"),
        _section(_restaurants()),
        _headerLogged("RESTAURANTES RECOMENDADOS"),
        _sectionLogged(_generalRecommendations()),
        _headerLogged("RECOMENDAÇÕES: SUA PRÓXIMA RESERVA"),
        _sectionLogged(_usagesRecommendations()),
        _headerLogged("RECOMENDAÇÕES: SEU PRÓXIMO FAVORITO"),
        _sectionLogged(_favoritesRecommendations()),
      ],
    );
  }

  Widget _headerLogged(String title) {
    return FutureBuilder<User>(
      future: this.preferences.user(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = snapshot.data;
            if (user.id != null)
              return _header(title);
            else
              return Container();
            break;
          default:
            return Container();
        }
      },
    );
  }

  Widget _sectionLogged(Future future) {
    return FutureBuilder<User>(
      future: this.preferences.user(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = snapshot.data;
            if (user.id != null)
              return _section(future);
            else
              return Container();
            break;
          default:
            return Container();
        }
      },
    );
  }

  Widget _header(String title) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Text(title,
          style: TextStyle(
              color: Colors.black54,
              fontSize: 17,
              fontWeight: FontWeight.w700)),
    );
  }

  Widget _section(Future future) {
    return FutureBuilder<List<Restaurant>>(
      future: future,
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
            return Container(
              height: _height,
              child: Loader().show(),
            );
        }
      },
    );
  }

  Widget _list(List<Restaurant> restaurants) {
    return Container(
      height: _height,
      child: ScopedModel<RestaurantViewModel>(
        model: this.viewModel,
        child: TableView(
          direction: Axis.horizontal,
          restaurants: restaurants ?? [],
          booking: _booking,
          favorite: _favorite,
        ),
      ),
    );
  }

  Widget _empty() {
    return Container(
        height: _height,
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Icon(Icons.inbox, color: Colors.black26, size: 80),
            Text("Sem restaurantes disponíveis",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black26,
                )),
            Expanded(child: Container()),
          ],
        ));
  }

  Future<List<Restaurant>> _restaurants() async {
    var user = await this.preferences.user();
    var city = user.cityId ?? 10;
    var client = user.id;
    var key = "restaurants";
    var restaurants = await this.preferences.restaurants(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.restaurantsAPI(city);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, client, key);
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _generalRecommendations() async {
    var user = await this.preferences.user();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var key = "general_recommendations";
    var restaurants = await this.preferences.restaurants(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.generalAPI(city, client);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, client, key);
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _usagesRecommendations() async {
    var user = await this.preferences.user();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var key = "usages_recommendations";
    var restaurants = await this.preferences.restaurants(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.usagesAPI(city, client);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, client, key);
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _favoritesRecommendations() async {
    var user = await this.preferences.user();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var key = "favorites_recommendations";
    var restaurants = await this.preferences.restaurants(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.favoritesAPI(city, client);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, client, key);
        return result.item2;
      default:
        Alert.error(context, Error.from(code).message);
        return [];
    }
  }

  void _favorites(Restaurant restaurant) async {
    var user = await this.preferences.user();
    if (user.id == null) return;
    var restaurants = await this.preferences.restaurants(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      this.preferences.set(result.item2, user.id, "favorites");
      restaurants = result.item2;
    }
    if (restaurants.contains(restaurant)) {
      _removeFavourite(restaurant);
    } else {
      _addFavourite(restaurant);
    }
  }

  void _addFavourite(Restaurant restaurant) async {
    var user = await this.preferences.user();
    var result = await this.favorites.addFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, user.id, "favorites");
        Alert.show(context, restaurant.name + " adicionado aos favoritos.");
        break;
      default:
        Alert.error(context, Error.from(code).message);
        break;
    }
  }

  void _removeFavourite(Restaurant restaurant) async {
    var user = await this.preferences.user();
    var result = await this.favorites.removeFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        this.preferences.set(result.item2, user.id, "favorites");
        Alert.show(context, restaurant.name + " removido dos favoritos.");
        break;
      default:
        Alert.error(context, Error.from(code).message);
        break;
    }
  }

  void _booking(Restaurant restaurant) {}

  void _favorite(Restaurant restaurant) {
    _favorites(restaurant);
  }
}
