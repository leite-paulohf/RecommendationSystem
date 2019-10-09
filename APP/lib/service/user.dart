import 'package:tuple/tuple.dart';
import 'package:tcc_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

abstract class UserInterface {
  Future<Tuple2<int, User>> search(String document);

  Future<Tuple2<int, User>> login(String document, String password);

  Future<Tuple2<int, User>> register(
      String name, String document, String password);
}

class UserService implements UserInterface {
  final _base = 'http://039d481a.ngrok.io';

  static final UserService _internal = UserService.internal();

  factory UserService() => _internal;

  UserService.internal();

  @override
  Future<Tuple2<int, User>> search(String document) async {
    final response = await http.get('$_base/client/search?document=$document',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var code = response.statusCode;
    try {
      var user = User.fromJson(json.decode(response.body));
      return Tuple2<int, User>(code, user);
    } catch (error) {
      return Tuple2<int, User>(code, User());
    }
  }

  @override
  Future<Tuple2<int, User>> login(String document, String password) async {
    final response = await http.get(
        '$_base/client/login?document=$document&password=$password',
        headers: {HttpHeaders.contentTypeHeader: 'application/json'});
    var code = response.statusCode;
    try {
      var user = User.fromJson(json.decode(response.body));
      return Tuple2<int, User>(code, user);
    } catch (error) {
      return Tuple2<int, User>(code, User());
    }
  }

  @override
  Future<Tuple2<int, User>> register(
      String name, String document, String password) async {
    var user = User(name: name, document: document, password: password);
    final response = await http.post('$_base/client/register',
        body: user.toString());
    var code = response.statusCode;
    try {
      var user = User.fromJson(json.decode(response.body));
      return Tuple2<int, User>(code, user);
    } catch (error) {
      return Tuple2<int, User>(code, User());
    }
  }
}
