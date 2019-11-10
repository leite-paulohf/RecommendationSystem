import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';

class Preferences {
  static final Preferences _singleton = Preferences._internal();

  factory Preferences() {
    return _singleton;
  }

  Preferences._internal();

  final _lock = Lock();

  Future<List<Filter>> filtersCache(String key) async {
    return await _lock.synchronized(() async {
      var cache = await SharedPreferences.getInstance();
      var data = cache.get(key);
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
    });
  }

  void setFilters(List<Filter> filters, String key) async {
    return await _lock.synchronized(() async {
      var cache = await SharedPreferences.getInstance();
      var list = filters.map((city) {
        return city.toJson();
      }).toList();
      var model = {'data': list};
      var data = json.encode(model);
      await cache.setString(key, data);
    });
  }

  Future<User> userCache() async {
    return await _lock.synchronized(() async {
      var cache = await SharedPreferences.getInstance();
      var user = cache.get("user");
      if (user != null) {
        Map data = json.decode(user);
        return User.fromModel(data);
      }
      return User();
    });
  }

  void setUser(User user) async {
    return await _lock.synchronized(() async {
      var cache = await SharedPreferences.getInstance();
      var data = json.encode({'data': user.toJson()});
      await cache.setString("user", data);
    });
  }

  Future<List<Restaurant>> restaurantsCache(int client, String key) async {
    return await _lock.synchronized(() async {
      if (client == null) return [];
      var clientId = client.toString();
      var path = clientId + "/" + key;
      var cache = await SharedPreferences.getInstance();
      var data = cache.get(path);
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
    });
  }

  void setRestaurants(
      List<Restaurant> restaurants, int client, String key) async {
    return await _lock.synchronized(() async {
      if (client == null) return;
      var clientId = client.toString();
      var path = clientId + "/" + key;
      var cache = await SharedPreferences.getInstance();
      var list = restaurants.map((restaurant) {
        return restaurant.toJson();
      }).toList();
      var model = {'data': list};
      var data = json.encode(model);
      await cache.setString(path, data);
    });
  }
}
