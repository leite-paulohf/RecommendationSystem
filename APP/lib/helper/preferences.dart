import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';

class Preferences {
  Future<List<Filter>> filters(String key) async {
    var preferences = await SharedPreferences.getInstance();
    var data = preferences.get(key);
    if (data != null) {
      Map map = json.decode(data);
      List list = map['data'];
      var cities = list.map((model) {
        return Filter.fromModel(model);
      }).toList();
      return cities;
    } else {
      return [];
    }
  }

  void setFilters(List<Filter> filters, String key) async {
    var preferences = await SharedPreferences.getInstance();
    var list = filters.map((city) {
      return city.toJson();
    }).toList();
    var model = {'data': list};
    var data = json.encode(model);
    await preferences.setString(key, data);
  }

  Future<User> user() async {
    var preferences = await SharedPreferences.getInstance();
    var user = preferences.get("user");
    if (user != null) {
      Map data = json.decode(user);
      return User.fromModel(data);
    }
    return User();
  }

  void setUser(User user) async {
    var preferences = await SharedPreferences.getInstance();
    var data = json.encode({'data': user.toJson()});
    await preferences.setString("user", data);
  }

  Future<List<Restaurant>> restaurants(int client, String key) async {
    if (client == null) return [];
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
    if (client == null) return;
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
