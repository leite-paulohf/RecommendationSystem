import 'package:flutter/material.dart';
import 'package:tcc_app/authentication/viewmodel.dart';
import 'package:tcc_app/model/user.dart';

class Profile extends StatefulWidget {
  final AuthenticationViewModel viewModel;

  Profile({Key key, @required this.viewModel}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RaisedButton(
          onPressed: () {
              this.widget.viewModel.set(User());
          },
          child: Text('Logout!'),
        ),
      ),
    );
  }
}
