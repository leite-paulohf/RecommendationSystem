import 'dart:async';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class UsagesInterface {
  Future<Tuple2<int, List<Restaurant>>> usages(int clientId);

  Future<Tuple2<int, List<Restaurant>>> usage(
    int chairs,
    int clientId,
    int restaurantId,
  );
}

class UsagesService implements UsagesInterface {
  static final UsagesService _internal = UsagesService.internal();

  factory UsagesService() => _internal;

  UsagesService.internal();

  @override
  Future<Tuple2<int, List<Restaurant>>> usages(int clientId) async {
    Map<String, String> data = {'client_id': clientId.toString()};
    var response = await Service().get('usages', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> usage(
      int chairs, int clientId, int restaurantId) async {
    Map<String, String> data = {
      'chairs': chairs.toString(),
      'client_id': clientId.toString(),
      'restaurant_id': restaurantId.toString(),
    };
    var response = await Service().post('usage', data);
    return Service().parseRestaurants(response);
  }
}
