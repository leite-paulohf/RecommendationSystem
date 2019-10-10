import 'package:tuple/tuple.dart';
import 'package:tcc_app/model/user.dart';
import 'dart:async';
import 'package:tcc_app/helper/service.dart';

abstract class UserInterface {
  Future<Tuple2<int, User>> search(String document);

  Future<Tuple2<int, User>> login(String document, String password);

  Future<Tuple2<int, User>> register(User user);
}

class UserService implements UserInterface {
  static final UserService _internal = UserService.internal();

  factory UserService() => _internal;

  UserService.internal();

  @override
  Future<Tuple2<int, User>> search(String document) async {
    Map<String, String> data = {'document': document};
    var response = await Service().get('client/search', data);
    return Service().parse(response);
  }

  @override
  Future<Tuple2<int, User>> login(String document, String password) async {
    Map<String, String> data = {'document': document, 'password': password};
    var response = await Service().get('client/login', data);
    return Service().parse(response);
  }

  @override
  Future<Tuple2<int, User>> register(User user) async {
    Map data = user.toJson();
    var response = await Service().post('client/register', {'client': data});
    return Service().parse(response);
  }
}
