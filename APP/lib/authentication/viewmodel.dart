import 'dart:convert';
import 'package:tcc_app/service/user.dart';
import 'package:tcc_app/model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationViewModel extends Model {
  final UserInterface interface;

  AuthenticationViewModel({@required this.interface});

  String name;
  String document;
  String password;

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
    return await this.interface.search(this.document);
  }

  Future<Tuple2<int, User>> login() async {
    return await this.interface.login(this.document, this.password);
  }

  Future<Tuple2<int, User>> register() async {
    var user = User(
        id: null,
        name: this.name,
        cpf: this.document,
        password: this.password);
    return await this.interface.register(user);
  }
}
