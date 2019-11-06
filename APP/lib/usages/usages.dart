import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/table.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/model/restaurant.dart';
import 'package:tcc_app/model/error.dart';
import 'package:tcc_app/service/usages.dart';
import 'package:tcc_app/service/user.dart';
import 'package:tcc_app/usages/viewmodel.dart';

class Usages extends StatefulWidget {
  Usages({Key key}) : super(key: key);

  @override
  UsagesState createState() => UsagesState();
}

class UsagesState extends State<Usages> {
  final _key = GlobalKey<ScaffoldState>();
  final viewModel = UsagesViewModel(interface: UsagesService());
  final helper = AuthenticationViewModel(interface: UserService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.black12,
      body: _body(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _body() {
    return FutureBuilder<List<Restaurant>>(
      future: _usages(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            var restaurants = snapshot.data ?? [];
            if (restaurants.isNotEmpty)
              return _list(restaurants);
            else
              return _empty();
            break;
          default:
            return Loader().show();
        }
      },
    );
  }

  Widget _list(List<Restaurant> restaurants) {
    return ScopedModel<UsagesViewModel>(
      model: this.viewModel,
      child: TableView(
        direction: Axis.vertical,
        restaurants: restaurants,
        booking: _booking,
        favourite: _favourite,
      ),
    );
  }

  Widget _empty() {
    return Center(
        child: Column(
      children: <Widget>[
        Expanded(child: Container()),
        Icon(Icons.error, color: Colors.black26, size: 80),
        Text("EMPTY LIST!",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black26,
            )),
        Expanded(child: Container()),
      ],
    ));
  }

  Future<List<Restaurant>> _usages() async {
    var user = await this.helper.getUser();
    if (user == null) {
      Alert.show(context, Error.from(401).message);
      return [];
    }
    this.helper.user = user;
    var result = await this.viewModel.usages(user.id);
    var code = result.item1;
    switch (code) {
      case 200:
        return result.item2;
      default:
        Alert.show(context, Error.from(code).message);
        return [];
    }
  }

  void _booking() {}

  void _favourite() {}
}
