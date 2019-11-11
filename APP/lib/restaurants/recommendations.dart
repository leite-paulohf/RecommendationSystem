import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/restaurants/viewmodel.dart';

class Recommendations extends StatefulWidget {
  final RestaurantViewModel viewModel;

  Recommendations({Key key, @required this.viewModel}) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.grey.shade200,
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
    return Column(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 20)),
        _title("Estamos quase lá!"),
        _title("Escolha as sugestões que mais agradar"),
        Padding(padding: EdgeInsets.only(top: 20)),
        Expanded(child: _list(restaurants)),
        _continue()
      ],
    );
  }

  Widget _title(String text) {
    var width = MediaQuery.of(context).size.width - 16;
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
        booking: _preference,
        favorite: _preference,
      ),
    );
  }

  Widget _continue() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Button(
        label: "SALVAR PREFERÊNCIAS",
        submitted: () {
          var preferences = this.widget.viewModel.preferences;
          if (preferences.isEmpty)
            Alert().error(context, "Escolha ao menos um restaurante.");
        },
      ),
    );
  }

  Future<List<Restaurant>> _onboarding() async {
    var user = await Cache().userCache();
    if (user.id == null) return [];
    var city = user.cityId;
    var client = user.id;
    var restaurants = await Cache().restaurantsCache(client, "onboarding");
    if (restaurants.isNotEmpty) return restaurants;
    var result = await this.widget.viewModel.onboardingAPI(city);
    var code = result.item1;
    switch (code) {
      case 200:
        Cache().setRestaurants(result.item2, client, "onboarding");
        return result.item2;
      default:
        Alert().error(context, Error.from(code).message);
        return [];
    }
  }

  void _addPreference(Restaurant restaurant) async {
    var like = 1;
    var user = await Cache().userCache();
    var code = await this.widget.viewModel.addPreference(
          user.id,
          restaurant.id,
          like,
        );
    switch (code) {
      case 200:
        this.widget.viewModel.preferences.add(restaurant);
        var name = restaurant.name;
        Alert().message(context, "$name adicionado a suas preferências.");
        break;
      default:
        Alert().error(context, Error.from(code).message);
        break;
    }
  }

  void _preference(Restaurant restaurant) {
    _addPreference(restaurant);
  }
}
