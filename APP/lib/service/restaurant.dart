import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as service;
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/model/restaurants.dart';

abstract class RestaurantInterface {
  Future<Restaurants> getRestaurants(int city);

  Future<Restaurants> getRecommendations(int uuid, int city);

  Future<Restaurants> getFavourites(int uuid);
}

class RestaurantService implements RestaurantInterface {
  static final RestaurantService _internal = RestaurantService.internal();

  factory RestaurantService() => _internal;

  RestaurantService.internal();

  String _base = 'http://127.0.0.1:5000';

  @override
  Future<Restaurants> getRestaurants(int city) async {
    final response = await service.get('$_base/restaurants?city=$city',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var code = response.statusCode;
    switch (code) {
      case 200:
        return Restaurants.fromModel(json.decode(response.body));
      default:
        throw Exception(Error.from(code).message);
    }
  }

  @override
  Future<Restaurants> getRecommendations(int uuid, int city) async {
    final response = await service.get(
        '$_base/recommendations?uuid=$uuid&city=$city',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var code = response.statusCode;
    switch (code) {
      case 200:
        return Restaurants.fromModel(json.decode(response.body));
      default:
        throw Exception(Error.from(code).message);
    }
  }

  @override
  Future<Restaurants> getFavourites(int uuid) async {
    final response = await service.get('$_base/favourites?uuid=$uuid',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var code = response.statusCode;
    switch (code) {
      case 200:
        return Restaurants.fromModel(json.decode(response.body));
      default:
        throw Exception(Error.from(code).message);
    }
  }
}
