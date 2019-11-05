import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/service/user.dart';
import 'package:tcc_app/model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationViewModel extends Model {
  final UserInterface interface;

  AuthenticationViewModel({@required this.interface});

  User user = User();
  List<Filter> cities = [];
  Filter city;

  Future<User> getUser() async {
    var preferences = await SharedPreferences.getInstance();
    var user = preferences.get("user");
    if (user != null) {
      Map data = json.decode(user);
      return User.fromModel(data);
    } else {
      return User();
    }
  }

  void set(User user) async {
    var preferences = await SharedPreferences.getInstance();
    var data = json.encode({'data': user.toJson()});
    await preferences.setString("user", data);
  }

  Future<Tuple2<int, User>> search() async {
    return await this.interface.search(this.user.cpf.toString());
  }

  Future<Tuple2<int, User>> login() async {
    return await this.interface.login(
          this.user.cpf.toString(),
          this.user.password,
        );
  }

  Future<Tuple2<int, User>> register() async {
    return await this.interface.register(this.user);
  }

  Future<List<Filter>> getCities(BuildContext context) async {
    return await this.interface.cities(context);
  }
}
