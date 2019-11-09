import 'package:flutter/widgets.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/service/user.dart';
import 'package:tcc_app/model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class AuthenticationViewModel extends Model {
  final UserInterface interface;

  AuthenticationViewModel({@required this.interface});

  User user = User();
  List<Filter> cities = [];
  Filter city;

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

  Future<Tuple2<int, User>> update() async {
    return await this.interface.update(this.user);
  }

  Future<Tuple2<int, List<Filter>>> regions() async {
    return await this.interface.cities();
  }
}
