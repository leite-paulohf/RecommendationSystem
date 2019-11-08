import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc_app/model/restaurant.dart';

class Preferences {
  Future<List<Restaurant>> restaurants(int client, String key) async {
    var clientId = client.toString();
    var path = clientId + "/" + key;
    var preferences = await SharedPreferences.getInstance();
    var data = preferences.get(path);
    if (data != null) {
      Map map = json.decode(data);
      List list = map['data'];
      var restaurants = list.map((model) {
        return Restaurant.fromModel(model);
      }).toList();
      return restaurants;
    } else {
      return [];
    }
  }

  void set(List<Restaurant> restaurants, int client, String key) async {
    var clientId = client.toString();
    var path = clientId + "/" + key;
    var preferences = await SharedPreferences.getInstance();
    var list = restaurants.map((restaurant) {
      return restaurant.toJson();
    }).toList();
    var model = {'data': list};
    var data = json.encode(model);
    await preferences.setString(path, data);
  }
}
