import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';
import 'package:tcc_app/service/restaurant.dart';
import 'package:tcc_app/model/error.dart';

class Restaurants extends StatefulWidget {
  Restaurants({Key key}) : super(key: key);

  @override
  RestaurantsState createState() => RestaurantsState();
}

class RestaurantsState extends State<Restaurants> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = RestaurantViewModel(interface: RestaurantService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
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
        _header("CITY RESTAURANTS"),
        _section(_restaurants()),
        _header("GENERAL RECOMMENDATIONS"),
        _section(_generalRecommendations()),
        _header("USAGES RECOMMENDATIONS"),
        _section(_usagesRecommendations()),
        _header("FAVORITES RECOMMENDATIONS"),
        _section(_favoritesRecommendations()),
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
          )),
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
              height: 258,
              child: Loader().show(),
            );
        }
      },
    );
  }

  Widget _list(List<Restaurant> restaurants) {
    return Container(
      height: 258,
      child: ScopedModel<RestaurantViewModel>(
        model: this.viewModel,
        child: TableView(
          direction: Axis.horizontal,
          restaurants: restaurants ?? [],
          booking: _booking,
          favourite: _favourite,
        ),
      ),
    );
  }

  Widget _empty() {
    return Container(
        height: 258,
        child: Column(
          children: <Widget>[
            Expanded(child: Container()),
            Icon(Icons.inbox, color: Colors.black26, size: 80),
            Text("EMPTY LIST!",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black26,
                )),
            Expanded(child: Container()),
          ],
        ));
  }

  Future<List<Restaurant>> _restaurants() async {
    var result = await this.viewModel.restaurants(6);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _generalRecommendations() async {
    var result = await this.viewModel.general(6, 6);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _usagesRecommendations() async {
    var result = await this.viewModel.usages(6, 6);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  Future<List<Restaurant>> _favoritesRecommendations() async {
    var result = await this.viewModel.favorites(6, 6);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  void _booking() {}

  void _favourite() {}
}
