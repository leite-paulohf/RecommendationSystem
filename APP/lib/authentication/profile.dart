import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tcc_app/authentication/authentication.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/components/button.dart';
import 'package:tcc_app/helper/loader.dart';
import 'package:tcc_app/helper/preferences.dart';
import 'package:tcc_app/model/user.dart';

class Profile extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Profile({Key key, @required this.viewModel}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _key = GlobalKey<ScaffoldState>();
  final preferences = Preferences();
  User _user;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: this.preferences.user(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            _user = snapshot.data;
            if (snapshot.data.id == null) return Authentication();
            return Scaffold(
              key: _key,
              backgroundColor: Colors.black12,
              appBar: AppBar(title: Text("Perfil"), centerTitle: true),
              body: Center(child: _body()),
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

  Widget _body() {
    return ScopedModel<AuthenticationViewModel>(
      model: this.widget.viewModel,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[_header(), _detail(), _logout()],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Icon(Icons.account_circle, color: Colors.teal, size: 80),
    );
  }

  Widget _detail() {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Text(
            _user.name.toUpperCase() ?? "",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _user.cpf.toString() ?? "",
            style: TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _logout() {
    return Button(
      label: "SAIR",
      submitted: () {
        setState(() {
          this.preferences.setUser(User());
        });
      },
    );
  }
}
