import 'dart:async';
import 'package:tcc_app/service/service.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tuple/tuple.dart';

abstract class FavouritesInterface {
  Future<Tuple2<int, List<Restaurant>>> addFavourite(
    String clientUuid,
    String restaurantUuid,
  );

  Future<Tuple2<int, List<Restaurant>>> removeFavourite(
    String clientUuid,
    String restaurantUuid,
  );

  Future<Tuple2<int, List<Restaurant>>> getAllFavourites(
    String clientUuid,
    String restaurantUuid,
  );
}

class FavouritesService implements FavouritesInterface {
  static final FavouritesService _internal = FavouritesService.internal();

  factory FavouritesService() => _internal;

  FavouritesService.internal();

  @override
  Future<Tuple2<int, List<Restaurant>>> addFavourite(
      String clientUuid, String restaurantUuid) async {
    Map<String, String> data = {
      'client_uuid': clientUuid,
      'restaurant_uuid': restaurantUuid
    };
    var response = await Service().post('favourites', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> removeFavourite(
      String clientUuid, String restaurantUuid) async {
    Map<String, String> data = {
      'client_uuid': clientUuid,
      'restaurant_uuid': restaurantUuid
    };
    var response = await Service().delete('favourites', data);
    return Service().parseRestaurants(response);
  }

  @override
  Future<Tuple2<int, List<Restaurant>>> getAllFavourites(
      String clientUuid, String restaurantUuid) async {
    Map<String, String> data = {
      'client_uuid': clientUuid,
      'restaurant_uuid': restaurantUuid
    };
    var response = await Service().get('favourites', data);
    return Service().parseRestaurants(response);
  }
}
