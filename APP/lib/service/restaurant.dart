import 'dart:async';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class RestaurantInterface {
  Future<Tuple2<int, List<Restaurant>>> restaurants(int city);

  Future<Tuple2<int, List<Restaurant>>> general(int city, int client);

  Future<Tuple2<int, List<Restaurant>>> usages(int city, int client);

  Future<Tuple2<int, List<Restaurant>>> favorites(int city, int client);

  Future<Tuple2<int, List<Filter>>> moments();

  Future<Tuple2<int, List<Filter>>> cuisines();

  Future<Tuple2<int, List<Filter>>> chairs();

  Future<Tuple2<int, List<Filter>>> prices();

  Future<Tuple2<int, List<Filter>>> rating();
}

class RestaurantService implements RestaurantInterface {
  static final RestaurantService _internal = RestaurantService.internal();

  factory RestaurantService() => _internal;

  RestaurantService.internal();

  @override
  Future<Tuple2<int, List<Restaurant>>> restaurants(int city) async {
    Map<String, String> data = {'city_id': city.toString()};
    var response = await Service().get('restaurants', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> general(int city, int client) async {
    Map<String, String> data = {
      'city_id': city.toString(),
      'client_id': client.toString()
    };
    var response = await Service().get('usages/recommendations', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> usages(int city, int client) async {
    Map<String, String> data = {
      'city_id': city.toString(),
      'client_id': client.toString()
    };
    var response = await Service().get('usages/recommendations', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> favorites(int city, int client) async {
    Map<String, String> data = {
      'city_id': city.toString(),
      'client_id': client.toString()
    };
    var response = await Service().get('favorites/recommendations', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> moments() async {
    var response = await Service().get('moments', {});
    return Service().parseFilter(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> cuisines() async {
    var response = await Service().get('cuisines', {});
    return Service().parseFilter(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> chairs() async {
    var response = await Service().get('chairs', {});
    return Service().parseFilter(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> prices() async {
    var response = await Service().get('prices', {});
    return Service().parseFilter(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> rating() async {
    var response = await Service().get('rating', {});
    return Service().parseFilter(response);
  }
}
