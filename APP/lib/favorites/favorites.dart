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

class Favorites extends StatefulWidget {
  Favorites({Key key}) : super(key: key);

  @override
  FavoritesState createState() => FavoritesState();
}

class FavoritesState extends State<Favorites> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = FavoritesViewModel(interface: FavoritesService());
  final usages = UsagesViewModel(interface: UsagesService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade200,
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
        preference: false,
        booking: _booking,
        favorite: _favorite,
        like: () {},
        unlike: () {},
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
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var restaurants = await Cache().restaurantsCache(user.id, "favorites");
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.viewModel.favorites(user.id);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, user.id, "favorites");
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  void _removeFavourite(Restaurant restaurant) async {
    var user = await Cache().userCache();
    if (user.id == null) return;
    var result = await this.viewModel.removeFavorite(user.id, restaurant.id);
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
    if (user.id == null) return;
    var result = await this.usages.usage(
          restaurant.chairs,
          user.id,
          restaurant.id,
        );
    var code = result.item1;
    switch (code) {
      case 200:
        var kind = restaurant.kind.id == 1 ? "Check-in" : "Reserva";
        var name = restaurant.name;
        Cache().setRestaurants(result.item2, user.id, "usages");
        Cache().setRestaurants([], user.id, "usages_recommendations");
        Alert().message(context, "$kind com sucesso em $name.");
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
    var chairs = restaurant.chairs.toString();
    chairs = "Válido para $chairs pessoa(s)";
    var info = "$usage\n$chairs\n$benefits\n$restrictions\n$moment";
    Alert().booking(context, restaurant.name, info, () {
      Navigator.of(context).pop();
      _createUsage(restaurant);
    });
  }

  void _favorite(Restaurant restaurant) {
    _removeFavourite(restaurant);
  }
}
