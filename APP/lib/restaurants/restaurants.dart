import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/favorites/viewmodel.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/restaurants/onboarding.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/favorites.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/usages.dart';
import 'package:tcc_app/usages/viewmodel.dart';

class Restaurants extends StatefulWidget {
  Restaurants({Key key}) : super(key: key);

  @override
  RestaurantsState createState() => RestaurantsState();
}

class RestaurantsState extends State<Restaurants> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = RestaurantViewModel(interface: RestaurantService());
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final usages = UsagesViewModel(interface: UsagesService());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOnboarding(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data)
              return OnBoarding();
            else
              return Scaffold(
                key: _key,
                backgroundColor: Colors.grey.shade200,
                appBar: AppBar(
                  title: Text("Restaurants"),
                  centerTitle: true,
                ),
                body: _body(),
              );
            break;
          default:
            return Scaffold(
              key: _key,
              backgroundColor: Colors.grey.shade200,
              appBar: AppBar(),
              body: Loader().show(),
            );
        }
      },
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
        _section(_restaurants(), 258, false),
        _header("RESTAURANTES RECOMENDADOS"),
        _sectionLogged(_recommendations(), 306),
        _header("RECOMENDAÇÕES: SUA PRÓXIMA RESERVA"),
        _sectionLogged(_usagesRecommendations(), 306),
        _header("RECOMENDAÇÕES: SEU PRÓXIMO FAVORITO"),
        _sectionLogged(_favoritesRecommendations(), 306),
      ],
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

  Widget _section(Future future, double height, bool preference) {
    return FutureBuilder<List<Restaurant>>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var restaurants = snapshot.data ?? [];
            if (restaurants.isNotEmpty)
              return _list(restaurants, height, preference);
            else
              return _empty("Sem restaurantes disponíveis", height);
            break;
          default:
            return Container(height: height, child: Loader().show());
        }
      },
    );
  }

  Widget _sectionLogged(Future future, double height) {
    return FutureBuilder<User>(
      future: Cache().userCache(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var user = snapshot.data;
            if (user.id != null)
              return _section(future, height, true);
            else
              return _empty("É necessário entrar com uma conta", height);
            break;
          default:
            return Container(height: height, child: Loader().show());
        }
      },
    );
  }

  Widget _list(List<Restaurant> restaurants, double height, bool preference) {
    return Container(
      height: height,
      child: ScopedModel<RestaurantViewModel>(
        model: this.viewModel,
        child: TableView(
          direction: Axis.horizontal,
          restaurants: restaurants ?? [],
          preference: preference,
          booking: _booking,
          favorite: _favorite,
          like: _like,
          unlike: _unlike,
        ),
      ),
    );
  }

  Widget _empty(String text, double height) {
    return Container(
        height: height,
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Icon(Icons.inbox, color: Colors.black26, size: 80),
            Text(text,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black26,
                )),
            Expanded(child: Container()),
          ],
        ));
  }

  Future<bool> _isOnboarding() async {
    var user = await Cache().userCache();
    if (user.id == null) return false;
    var isOnboarding = await Cache().flag(user.id, "isOnboarding");
    return isOnboarding;
  }

  Future<List<Restaurant>> _restaurants() async {
    var user = await Cache().userCache();
    var city = user.cityId ?? 10;
    var client = user.id;
    var key = "restaurants";
    var restaurants = await Cache().restaurantsCache(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.restaurantsAPI(city);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, client, key);
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _recommendations() async {
    var user = await Cache().userCache();
    if (user.id == null) return null;
    var city = user.cityId;
    var key = "recommendations";
    var restaurants = await Cache().restaurantsCache(user.id, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.recommendationsAPI(city, user.id);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, user.id, key);
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _usagesRecommendations() async {
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var key = "usages_recommendations";
    var restaurants = await Cache().restaurantsCache(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.usagesAPI(city, client);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, client, key);
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _favoritesRecommendations() async {
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var key = "favorites_recommendations";
    var restaurants = await Cache().restaurantsCache(client, key);
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.favoritesAPI(city, client);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, client, key);
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  void _updateFavorite(Restaurant restaurant) async {
    var user = await Cache().userCache();
    if (user.id == null) {
      return Alert().error(context, "É necessário entrar com uma conta!");
    }
    var restaurants = await Cache().restaurantsCache(user.id, "favorites");
    if (restaurants.isEmpty) {
      var result = await this.favorites.favorites(user.id);
      Cache().setRestaurants(result.item2, user.id, "favorites");
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
    var user = await Cache().userCache();
    var result = await this.favorites.addFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          var name = restaurant.name;
          Cache().setRestaurants(result.item2, user.id, "favorites");
          Cache().setRestaurants([], user.id, "favorites_recommendations");
          Alert().message(context, "$name adicionado aos favoritos.");
        });
        break;
      default:
        Alert().error(context, Error.from(code).message);
        break;
    }
  }

  void _removeFavourite(Restaurant restaurant) async {
    var user = await Cache().userCache();
    var result = await this.favorites.removeFavorite(user.id, restaurant.id);
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          var name = restaurant.name;
          Cache().setRestaurants(result.item2, user.id, "favorites");
          Cache().setRestaurants([], user.id, "favorites_recommendations");
          Alert().message(context, "$name removido dos favoritos.");
        });
        break;
      default:
        Alert().error(context, Error.from(code).message);
        break;
    }
  }

  void _createUsage(Restaurant restaurant) async {
    var user = await Cache().userCache();
    if (user.id == null) {
      Alert().error(context, "É necessário entrar com uma conta!");
      return;
    }
    var result = await this.usages.usage(
          restaurant.chairs,
          user.id,
          restaurant.id,
        );
    var code = result.item1;
    switch (code) {
      case 200:
        setState(() {
          var kind = restaurant.kind.id == 1 ? "Check-in" : "Reserva";
          var name = restaurant.name;
          Cache().setRestaurants(result.item2, user.id, "usages");
          Cache().setRestaurants([], user.id, "usages_recommendations");
          Alert().message(context, "$kind com sucesso em $name.");
        });
        break;
      default:
        Alert().error(context, Error.from(code).message);
        break;
    }
  }

  void _addPreference(Restaurant restaurant, int like) async {
    var user = await Cache().userCache();
    var code = await this.viewModel.addPreference(
          user.id,
          restaurant.id,
          like,
        );
    switch (code) {
      case 200:
        setState(() {
          Cache().setRestaurants([], user.id, "preferences");
          Cache().setRestaurants([], user.id, "recommendations");
          var name = restaurant.name;
          if (like == 1)
            Alert().message(context, "$name será usado em suas recomendações.");
          else
            Alert().message(context, "$name não será mais recomendado.");
        });
        break;
      default:
        Alert().error(context, Error.from(code).message);
        break;
    }
  }

  void _booking(Restaurant restaurant) {
    var kind = restaurant.kind.id == 1 ? "Check-in" : "Reserva";
    var discount = restaurant.offer.discount;
    var benefit = discount > 0 ? " com $discount%OFF" : " sem desconto";
    var usage = kind + benefit;
    var restrictions = restaurant.offer.restrictions
        ? "Válido para conta toda"
        : "Não válido para bebidas e sobremesas";
    var benefits = restaurant.offer.benefits
        ? "Com benefício extra"
        : "Sem benefício extra";
    var moment = restaurant.moment.name;
    var chairs = "Válido para " + restaurant.chairs.toString() + " pessoa(s)";
    var info = "$usage\n$chairs\n$benefits\n$restrictions\n$moment";
    Alert().booking(context, restaurant.name, info, () {
      Navigator.of(context).pop();
      _createUsage(restaurant);
    });
  }

  void _favorite(Restaurant restaurant) {
    _updateFavorite(restaurant);
  }

  void _like(Restaurant restaurant) {
    _addPreference(restaurant, 1);
  }

  void _unlike(Restaurant restaurant) {
    _addPreference(restaurant, 0);
  }
}
