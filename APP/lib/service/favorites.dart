import 'dart:async';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class FavoritesInterface {
  Future<Tuple2<int, List<Restaurant>>> addFavorite(
    int clientId,
    int restaurantId,
  );

  Future<Tuple2<int, List<Restaurant>>> removeFavorite(
    int clientId,
    int restaurantId,
  );

  Future<Tuple2<int, List<Restaurant>>> favorites(int clientId);
}

class FavoritesService implements FavoritesInterface {
  static final FavoritesService _internal = FavoritesService.internal();

  factory FavoritesService() => _internal;

  FavoritesService.internal();

  @override
  Future<Tuple2<int, List<Restaurant>>> addFavorite(
      int clientId, int restaurantId) async {
    Map<String, String> data = {
      'client_id': clientId.toString(),
      'restaurant_id': restaurantId.toString()
    };
    var response = await Service().post('favorites', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> removeFavorite(
      int clientId, int restaurantId) async {
    Map<String, String> data = {
      'client_id': clientId.toString(),
      'restaurant_id': restaurantId.toString()
    };
    var response = await Service().delete('favorites', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> favorites(int clientId) async {
    Map<String, String> data = {'client_id': clientId.toString()};
    var response = await Service().get('favorites', data);
    return Service().parseRestaurants(response);
  }
}
