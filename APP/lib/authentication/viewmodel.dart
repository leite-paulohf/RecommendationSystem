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
    var client = preferences.get("client");
    if (client != null) {
      Map data = json.decode(client);
      return User.fromJson(data);
    } else {
      return User();
    }
  }

  void set(User user) async {
    var preferences = await SharedPreferences.getInstance();
    var client = json.encode({'data': user.toJson()});
    await preferences.setString("client", client);
  }

  Future<Tuple2<int, User>> search() async {
    return await this.interface.search(this.document);
  }

  Future<Tuple2<int, User>> login() async {
    return await this.interface.login(this.document, this.password);
  }

  Future<Tuple2<int, User>> register() async {
    var user = User(
        uuid: null,
        name: this.name,
        document: this.document,
        password: this.password);
    return await this.interface.register(user);
  }
}
