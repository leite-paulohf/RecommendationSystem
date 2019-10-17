import 'dart:async';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class RestaurantInterface {
  Future<Tuple2<int, List<Restaurant>>> search(int city);
}

class RestaurantService implements RestaurantInterface {
  static final RestaurantService _internal = RestaurantService.internal();

  factory RestaurantService() => _internal;

  RestaurantService.internal();

  @override
  Future<Tuple2<int, List<Restaurant>>> search(int city) async {
    Map<String, String> data = {'city': city.toString()};
    var response = await Service().get('restaurants', data);
    return Service().parseRestaurants(response);
  }

}
