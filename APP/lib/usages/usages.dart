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
import 'package:tcc_app/service/usages.dart';
import 'package:tcc_app/usages/viewmodel.dart';

class Usages extends StatefulWidget {
  Usages({Key key}) : super(key: key);

  @override
  UsagesState createState() => UsagesState();
}

class UsagesState extends State<Usages> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = UsagesViewModel(interface: UsagesService());
  final favorites = FavoritesViewModel(interface: FavoritesService());
  final cache = Preferences();
  final alert = Alert();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("Histórico"),
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
      future: _usages(),
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
    return ScopedModel<UsagesViewModel>(
      model: this.viewModel,
      child: TableView(
        direction: Axis.vertical,
        restaurants: restaurants,
        booking: _booking,
        favorite: _favorite,
      ),
    );
  }

  Widget _empty() {
    return Center(
        child: Column(
      children: <Widget>[
        Expanded(child: Container()),
        Icon(Icons.inbox, color: Colors.black26, size: 80),
        Text("Você não possui utilizações",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black26,
            )),
        Expanded(child: Container()),
      ],
    ));
  }

  Future<List<Restaurant>> _usages() async {
    var user = await this.cache.userCache();
    if (user.id == null) return [];
    var restaurants = await this.cache.restaurantsCache(user.id, "usages");
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.usages(user.id);
    var code = result.item1;
    switch (code) {
      case 200:
        this.cache.setRestaurants(result.item2, user.id, "usages");
        return result.item2;
      default:
        this.alert.error(context, Error.from(code).message);
        return [];
    }
  }

  void _createUsage(Restaurant restaurant) async {
    var user = await this.cache.userCache();
    if (user.id == null) return;
    var result = await this.viewModel.usage(
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
          this.cache.setRestaurants(result.item2, user.id, "usages");
          this.cache.setRestaurants([], user.id, "usages_recommendations");
          this.alert.show(context, "$kind com sucesso em $name.");
        });
        break;
      default:
        this.alert.error(context, Error.from(code).message);
        break;
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
          this.cache.setRestaurants(result.item2, user.id, "favorites");
          this.cache.setRestaurants([], user.id, "favorites_recommendations");
          this
              .alert
              .show(context, restaurant.name + " adicionado aos favoritos.");
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
          this.cache.setRestaurants(result.item2, user.id, "favorites");
          this.cache.setRestaurants([], user.id, "favorites_recommendations");
          this
              .alert
              .show(context, restaurant.name + " removido dos favoritos.");
        });
        break;
      default:
        this.alert.error(context, Error.from(code).message);
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
    this.alert.booking(context, restaurant.name, info, () {
      Navigator.of(context).pop();
      _createUsage(restaurant);
    });
  }

  void _favorite(Restaurant restaurant) {
    _updateFavorite(restaurant);
  }
}
