import 'package:tcc_app/service/user.dart';
import 'package:tcc_app/model/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:meta/meta.dart';
import 'package:tuple/tuple.dart';

class AuthenticationViewModel extends Model {
  final UserInterface interface;

  AuthenticationViewModel({@required this.interface});

  String name;
  String document;
  String password;

  Future<Tuple2<int, User>> search() async {
    return await this.interface.search(this.document);
  }

  Future<Tuple2<int, User>> login() async {
    return await this.interface.login(this.document, this.password);
  }

  Future<Tuple2<int, User>> register() async {
    return await this
        .interface
        .register(this.name, this.document, this.password);
  }
}
