import 'package:flutter/widgets.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tuple/tuple.dart';
import 'package:tcc_app/model/user.dart';
import 'dart:async';
import 'package:tcc_app/service/service.dart';

abstract class UserInterface {
  Future<Tuple2<int, User>> search(String cpf);

  Future<Tuple2<int, User>> login(String cpf, String password);

  Future<Tuple2<int, User>> register(User user);

  Future<Tuple2<int, User>> update(User user);

  Future<Tuple2<int, List<Filter>>> cities();
}

class UserService implements UserInterface {
  static final UserService _internal = UserService.internal();

  factory UserService() => _internal;

  UserService.internal();

  @override
  Future<Tuple2<int, User>> search(String cpf) async {
    Map<String, String> data = {'cpf': cpf};
    var response = await Service().get('client/search', data);
    return Service().parseUser(response);
  }

  @override
  Future<Tuple2<int, User>> login(String cpf, String password) async {
    Map<String, String> data = {'cpf': cpf, 'password': password};
    var response = await Service().get('client/login', data);
    return Service().parseUser(response);
  }

  @override
  Future<Tuple2<int, User>> register(User user) async {
    Map data = user.toJson();
    var response = await Service().post('client/register', {'client': data});
    return Service().parseUser(response);
  }

  @override
  Future<Tuple2<int, User>> update(User user) async {
    Map data = user.toJson();
    var response = await Service().put('client/update', {'client': data});
    return Service().parseUser(response);
  }

  @override
  Future<Tuple2<int, List<Filter>>> cities() async {
    var response = await Service().get('cities', {});
    return Service().parseFilter(response);
  }
}
