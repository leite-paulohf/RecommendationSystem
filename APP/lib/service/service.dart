import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tuple/tuple.dart';

class Service {
  final _base = 'fc2fdc9d.ngrok.io';

  Future<http.Response> get(String path, Map<String, String> data) async {
    var url = Uri.http(_base, path, data);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var response = await http.get(url, headers: headers);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<http.Response> post(String path, Map data) async {
    var url = Uri.http(_base, path);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var body = json.encode(data);
    var response = await http.post(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<http.Response> put(String path, Map data) async {
    var url = Uri.http(_base, path);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var body = json.encode(data);
    var response = await http.put(url, headers: headers, body: body);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Future<http.Response> delete(String path, Map data) async {
    var url = Uri.http(_base, path, data);
    var headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var response = await http.delete(url, headers: headers);
    print(response.statusCode);
    print(response.body);
    return response;
  }

  Tuple2<int, User> parseUser(http.Response response) {
    try {
      var user = User.fromModel(json.decode(response.body));
      return Tuple2<int, User>(response.statusCode, user);
    } catch (error) {
      return Tuple2<int, User>(response.statusCode, User());
    }
  }

  Tuple2<int, List<Restaurant>> parseRestaurants(http.Response response) {
    try {
      Map map = json.decode(response.body);
      List list = map['data'];
      var restaurants = list.map((model) {
        return Restaurant.fromModel(model);
      }).toList();
      return Tuple2<int, List<Restaurant>>(response.statusCode, restaurants);
    } catch (error) {
      return Tuple2<int, List<Restaurant>>(response.statusCode, []);
    }
  }

  Tuple2<int, List<Filter>> parseFilter(http.Response response) {
    try {
      Map map = json.decode(response.body);
      List list = map['data'];
      var cities = list.map((model) {
        return Filter.fromModel(model);
      }).toList();
      return Tuple2<int, List<Filter>>(response.statusCode, cities);
    } catch (error) {
      return Tuple2<int, List<Filter>>(response.statusCode, []);
    }
  }
}
