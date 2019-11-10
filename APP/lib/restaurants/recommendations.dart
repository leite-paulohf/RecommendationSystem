import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/authentication.dart';
import 'package:tcc_app/helper/alert.dart';
import 'package:tcc_app/model/filter.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/user.dart';
import 'package:tcc_app/model/error.dart';

class Recommendations extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Recommendations({Key key, @required this.viewModel}) : super(key: key);

  @override
  _RecommendationsState createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final _key = GlobalKey<ScaffoldState>();
  final preferences = Preferences();
  final alert = Alert();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: this.preferences.user(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              key: _key,
              backgroundColor: Colors.black12,
              appBar: AppBar(title: Text("Recomendações"), centerTitle: true),
              body: _body(),
            );
          default:
            return Scaffold(
              key: _key,
              backgroundColor: Colors.black12,
              appBar: AppBar(),
              body: Loader().show(),
            );
        }
      },
    );
  }

  Widget _title(String text) {
    return Container(
      child: Text(text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          )),
    );
  }

  Widget _body() {
    return ListView(
      children: <Widget>[
        _title("Estamos quase lá!"),
        _title("Aqui tem algumas recomendações com base em suas preferências"),
        _title("Escolha 5 restaurantes para adicionar aos seus favoritos"),
      ],
    );
  }
}
