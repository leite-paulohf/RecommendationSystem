import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/favorites.dart';

class Recommendations extends StatefulWidget {
  final RestaurantViewModel viewModel;

  Recommendations({Key key, @required this.viewModel}) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final _key = GlobalKey<ScaffoldState>();
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final cache = Preferences();
  final alert = Alert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Sugestões"), centerTitle: true),
      body: _body(),
    );
  }

  Widget _body() {
    return FutureBuilder<List<Restaurant>>(
      future: _onboarding(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return _content(snapshot.data);
          default:
            return _content([]);
        }
      },
    );
  }

  Widget _content(List<Restaurant> restaurants) {
    return Padding(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          _title("Estamos quase lá!"),
          _title("Escolha 5 restaurantes sugeridos"),
          Padding(padding: EdgeInsets.only(top: 20)),
          Expanded(child: _list(restaurants)),
          _continue()
        ],
      ),
    );
  }

  Widget _title(String text) {
    var width = MediaQuery.of(context).size.width - 64;
    return Container(
      width: width,
      child: Text(text,
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _list(List<Restaurant> restaurants) {
    if (restaurants.isEmpty) return Loader().show();
    return ScopedModel<RestaurantViewModel>(
      model: this.widget.viewModel,
      child: TableView(
        direction: Axis.vertical,
        restaurants: restaurants,
        booking: _favorite,
        favorite: _favorite,
      ),
    );
  }

  Widget _continue() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Button(
        label: "SALVAR PREFERÊNCIAS",
        submitted: () {
          setState(() {
            this.cache.setUser(User());
          });
        },
      ),
    );
  }

  Future<List<Restaurant>> _onboarding() async {
    var user = await this.cache.userCache();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var restaurants = await this.cache.restaurantsCache(client, "onboarding");
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.widget.viewModel.onboardingAPI(city);
    var code = result.item1;
    switch (code) {
      case 200:
        this.cache.setRestaurants(result.item2, client, "onboarding");
        return result.item2;
      default:
        this.alert.error(context, Error.from(code).message);
        return [];
    }
  }

  void _updateFavorite(Restaurant restaurant) async {
    var user = await this.cache.userCache();
    if (user.id == null) return;
    var restaurants = await this.cache.restaurantsCache(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      this.cache.setRestaurants(result.item2, user.id, "favorites");
      restaurants = result.item2;
    }

    var ids = restaurants.map((restaurant) {
      return restaurant.id;
    }).toList();

    if (ids.contains(restaurant.id)) {
      _removeFavourite(restaurant);
    } else {
      _addFavourite(restaurant);
    }
  }

  void _addFavourite(Restaurant restaurant) async {
    var user = await this.cache.userCache();
    var result = await this.favorites.addFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          var name = restaurant.name;
          this.cache.setRestaurants(result.item2, user.id, "favorites");
          this.cache.setRestaurants([], user.id, "favorites_recommendations");
          this.alert.show(context, "$name adicionado aos favoritos.");
        });
        break;
      default:
        this.alert.error(context, Error.from(code).message);
        break;
    }
  }

  void _removeFavourite(Restaurant restaurant) async {
    var user = await this.cache.userCache();
    var result = await this.favorites.removeFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          var name = restaurant.name;
          this.cache.setRestaurants(result.item2, user.id, "favorites");
          this.cache.setRestaurants([], user.id, "favorites_recommendations");
          this.alert.show(context, "$name removido dos favoritos.");
        });
        break;
      default:
        this.alert.error(context, Error.from(code).message);
        break;
    }
  }

  void _favorite(Restaurant restaurant) {
    _updateFavorite(restaurant);
  }
}
